-- This allows you to select a compile_commands.json from any found in your repository, and then it
-- creates a corresponding .clangd in the repo root that configures clangd to use it. It reads the
-- compiler command from the chosen database and adds the necessary isystem flags to attempt to
-- avoid false positives and errors about missing standard C headers.
local M = {}

local uv = vim.uv or vim.loop

local function norm(p)
  if not p or p == "" then return p end
  local rp = uv.fs_realpath(p) or p
  return vim.fs.normalize(rp)
end

local function rel(root, path)
  root, path = norm(root), norm(path)
  if #path >= #root and path:sub(1, #root) == root then
    local r = path:sub(#root + 1)
    if r:sub(1,1) == "/" then r = r:sub(2) end
    return r
  end
  return path
end

-- Present a message at a given level.
local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "clangd-db" })
end

local function read_file(path)
  local fd = uv.fs_open(path, "r", 438)
  if not fd then
    return nil
  end

  local st = uv.fs_fstat(fd)
  local data = uv.fs_read(fd, st.size, 0)
  uv.fs_close(fd)

  return data
end

local function write_file(path, data)
  local dir = vim.fs.dirname(path)
  uv.fs_mkdir(dir, 493) -- 0755 best-effort

  local fd = uv.fs_open(path, "w", 420)
  if not fd then
    return false
  end

  uv.fs_write(fd, data, 0)
  uv.fs_close(fd)
  return true
end

local function find_git_root(start)
  start = norm(start)
  local git = vim.fs.find(".git", { path = start, upward = true })[1]
  return git and norm(vim.fs.dirname(git)) or start
end

-- Run a command; return code, stdout (trim), stderr (trim)
local function run(args, stdin_text)
  local res = vim.system(args, { text = true, stdin = stdin_text or "" }):wait()
  local out = (res.stdout or ""):gsub("%s+$","")
  local err = (res.stderr or ""):gsub("%s+$","")
  return res.code or 1, out, err
end

-- returns (compiler_path, full_cmdline, lang)
local function compiler_name_extract_from_entry(entry)
  -- Prefer to parse from the arguments array.
  if type(entry.arguments) == "table" and #entry.arguments > 0 then
    -- Skip "ccache" in the string, it isn't the compiler.
    local i = 1
    while i <= #entry.arguments and entry.arguments[i]:match("ccache$") do
      i = i + 1
    end

    local lang
    for j = i, #entry.arguments do
      if entry.arguments[j] == "-x" and entry.arguments[j+1] then
        lang = entry.arguments[j+1]
        break
      end
    end

    return entry.arguments[i], table.concat(entry.arguments, " "), lang
  end

  -- Fall back to parsing the command string.
  if type(entry.command) == "string" then
    local words = {}
    for w in entry.command:gmatch("%S+") do
      table.insert(words, w)
    end

    local i = 1
    while i <= #words and words[i]:match("ccache$") do
      i = i + 1
    end

    local lang
    for j = i, #words do
      if words[j] == "-x" and words[j+1] then
        lang = words[j+1]
        break
      end
    end

    return words[i], entry.command, lang
  end

  return nil, nil, nil
end

local function target_extract_from_cmd(cmdline)
  if not cmdline then return nil end

  local t = cmdline:match("%-%-target=([%w%-%._]+)")
  if not t or #t == 0 then
    return nil
  end

  return t
end

local function target_extract_from_compiler_path(cc_path)
  local base = cc_path:match("([^/]+)$") or cc_path
  if base == "ccache" then return nil end

  local triplet = base:gsub("%-?g?cc$", ""):gsub("%-?clang$", "")
  if not triplet:match("%-") then
    return nil
  end

  return triplet
end

local function target_extract_from_dump_machine(cc_path)
  local code, out = run({ cc_path, "-dumpmachine" })
  if code ~= 0 or out == "" then
    return nil
  end

  return out
end

local function sysroot_extract_from_print_sysroot(cc_path, target)
  local args = { cc_path, "-print-sysroot" }
  if target and #target > 0 then
    table.insert(args, "--target=" .. target)
  end

  local code, out = run(args)
  if code ~= 0 or out == "" then
    return ""
  end

  return out
end

-- Return dirs from the "#include <...> search starts here:" block
local function includes_extract_from_report(cc_path, lang)
  lang = lang or "c"
  local args = { cc_path, "-E", "-x", lang, "-", "-v" }

  local code, _out, err = run(args, "/* */\n") -- feed a tiny TU
  if code ~= 0 then
    notify("could not get report from compiler: %d", vim.log.levels.WARN)
    return {}
  end

  local lines = {}
  for line in err:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  local collecting = false
  local dirs = {}
  for _, line in ipairs(lines) do
    if line:find("^#include <%.%.%.> search starts here:") then
      collecting = true
    elseif collecting and line:find("^End of search list%.") then
      break
    elseif collecting then
      local d = line:gsub("^%s+", ""):gsub(" %(%a+%s+directory%)$", "")
      if d ~= "" and uv.fs_stat(d) then
        table.insert(dirs, norm(d))
      end
    end
  end

  -- dedup
  local seen, uniq = {}, {}
  for _, d in ipairs(dirs) do
    if not seen[d] then seen[d] = true; table.insert(uniq, d) end
  end
  return uniq
end


-- Build .clangd from probed data + fallbacks
local function build_clangd_yaml(db_dir, opts)
  local rd           = assert(opts.repo_root, "repo_root required")
  local target       = opts.target or ""
  local sysroot      = opts.sysroot or ""
  local include_dirs = opts.include_dirs or {}
  local extra_isys   = opts.extra_isystem or {}

  local lines = {}
  table.insert(lines, "CompileFlags:")
  table.insert(lines, ("  CompilationDatabase: %s"):format(rel(rd, db_dir)))
  table.insert(lines, "  Add:")
  table.insert(lines, '    - "-nostdinc"')

  table.insert(lines, "  # Target")
  if target ~= "" then
    table.insert(lines, ('    - "--target=%s"'):format(target))
  end

  table.insert(lines, "  # Sysroot")
  if sysroot ~= "" then
    table.insert(lines, ('    - "--sysroot=%s"'):format(sysroot))
  end

  table.insert(lines, "  # Include dirs")
  for _, d in ipairs(include_dirs) do
    if d and #d > 0 then
      table.insert(lines, '    - "-isystem"')
      table.insert(lines, ('    - "%s"'):format(d))
    end
  end

  table.insert(lines, "  # Extra isystem dirs")
  for _, d in ipairs(extra_isys) do
    if d and #d > 0 then
      table.insert(lines, '    - "-isystem"')
      table.insert(lines, ('    - "%s"'):format(d))
    end
  end

  return table.concat(lines, "\n") .. "\n"
end

-- Stop clangd for this repo so it restarts with new flags
local function restart_clangd_for_root(root)
  root = norm(root)
  local function repo_of_client(c)
    local rd = c.config and c.config.root_dir or ""
    local git = vim.fs.find(".git", { path = rd, upward = true })[1]
    return git and norm(vim.fs.dirname(git)) or nil
  end

  local n = 0
  for _, c in ipairs(vim.lsp.get_clients({ name = "clangd" })) do
    if repo_of_client(c) == root then
      c:stop(true)
      n = n + 1
    end
  end

  if n > 0 then
    notify(("Restarted clangd for %s"):format(root))
  end
  vim.lsp.enable("clangd")
end

-- Find all compile_commands.json in repo.
local function find_all_cc(root)
  local files = vim.fs.find("compile_commands.json",
                            { path = root, type = "file", limit = math.huge })
  local out = {}
  for _, f in ipairs(files) do
    local st = uv.fs_stat(f)
    table.insert(out, {
      file = norm(f),
      dir = norm(vim.fs.dirname(f)),
      mtime = st and st.mtime and st.mtime.sec or 0
    })
  end

  table.sort(out, function(a,b) return a.mtime > b.mtime end)
  return out
end

function M.pick_for_current_project(opts)
  opts = opts or {}

  local buf = 0
  local fname = vim.api.nvim_buf_get_name(buf)
  if fname == "" then
    notify("Open a C/C++ file first", vim.log.levels.WARN)
    return
  end
  local repo_root = find_git_root(vim.fs.dirname(fname))

  local candidates = find_all_cc(repo_root)
  if #candidates == 0 then
    notify(("No compile_commands.json found under %s"):format(repo_root), vim.log.levels.WARN)
    return
  end

  local ok = pcall(require, "telescope")
  if not ok then
    notify("telescope.nvim not found", vim.log.levels.ERROR)
    return
  end

  local pickers      = require("telescope.pickers")
  local finders      = require("telescope.finders")
  local conf         = require("telescope.config").values
  local actions      = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "Select compile_commands.json",
    finder = finders.new_table {
      results = candidates,
      entry_maker = function(item)
        local display = rel(repo_root, item.file)
        return { value = item, display = display, ordinal = display, path = item.file }
      end,
    },
    sorter = conf.generic_sorter({}),
    previewer = conf.file_previewer({}),
    attach_mappings = function(bufnr, _)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(bufnr)

        local db_dir = entry.value.dir

        -- Load database as a json object so we can extract info about the compiler.
        local json = read_file(entry.value.file)
        if not json then
          notify("Failed to read compile_commands.json", vim.log.levels.ERROR)
          return
        end

        local ok2, data = pcall(vim.json.decode, json)
        if not ok2 or type(data) ~= "table" or #data == 0 then
          notify("Invalid compile_commands.json", vim.log.levels.ERROR)
          return
        end

        local cc_path, full_cmd, lang = compiler_name_extract_from_entry(data[1])
        if not cc_path or cc_path == "" then
          notify("Could not parse compiler from compile_commands.json", vim.log.levels.ERROR)
          return
        end

        cc_path = norm(cc_path)

        -- Determine target.
        local target  = target_extract_from_cmd(full_cmd) or
                        target_extract_from_dump_machine(cc_path) or
                        target_extract_from_compiler_path(cc_path) or
                        ""

        -- Determine sysroot.
        local sysroot = sysroot_extract_from_print_sysroot(cc_path, target)

        -- Try to get the compiler's real include search list.
        local include_dirs = includes_extract_from_report(cc_path, lang)

        -- Write .clangd
        local yaml = build_clangd_yaml(db_dir, {
          repo_root = repo_root,
          target = target,
          sysroot = sysroot,
          include_dirs = include_dirs,
          extra_isystem = {}, -- add manual extras here if needed
        })

        local cfg_path = repo_root .. "/.clangd"
        local changed = (read_file(cfg_path) or "") ~= yaml
        if not changed then
          notify(".clangd unchanged (clangd not restarted)")
        end

        if not write_file(cfg_path, yaml) then
          notify("Failed to write " .. cfg_path, vim.log.levels.ERROR)
          return
        end

        restart_clangd_for_root(repo_root)
        notify(("Wrote %s\nCompiler: %s\nTarget: %s\nSysroot: %s\nIncludes: %d")
          :format(rel(repo_root, cfg_path),
                  cc_path,
                  target ~= "" and target or "(none)",
                  sysroot ~= "" and sysroot or "(none)",
                  #include_dirs))
      end)
      return true
    end,
  }):find()
end

return M
