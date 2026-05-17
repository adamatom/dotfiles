vim.api.nvim_create_augroup("allfiles", { clear = true })

local autocmd = vim.api.nvim_create_autocmd
local qf_cleanup_running = false

local function is_normal_window(winid)
  if not vim.api.nvim_win_is_valid(winid) then
    return false
  end

  local bufnr = vim.api.nvim_win_get_buf(winid)
  local win_config = vim.api.nvim_win_get_config(winid)

  if vim.fn.buflisted(bufnr) ~= 1 then
    return false
  end

  if vim.bo[bufnr].buftype ~= "" then
    return false
  end

  if vim.wo[winid].previewwindow then
    return false
  end

  if win_config.relative ~= "" then
    return false
  end

  return true
end

local function maybe_close_last_qf_tab()
  if qf_cleanup_running then
    return
  end

  local current_buf = vim.api.nvim_get_current_buf()
  if vim.bo[current_buf].buftype ~= "quickfix" then
    return
  end

  local tab_windows = vim.api.nvim_tabpage_list_wins(0)
  for _, winid in ipairs(tab_windows) do
    if is_normal_window(winid) then
      return
    end
  end

  qf_cleanup_running = true

  vim.schedule(function()
    local ok, err = pcall(function()
      if not vim.api.nvim_win_is_valid(0) then
        return
      end

      local buf = vim.api.nvim_win_get_buf(0)
      if vim.bo[buf].buftype ~= "quickfix" then
        return
      end

      if vim.fn.tabpagenr("$") == 1 then
        vim.cmd("quit")
      else
        vim.cmd("tabclose")
      end
    end)

    qf_cleanup_running = false

    if not ok and err:match("E444") == nil then
      vim.notify(err, vim.log.levels.WARN)
    end
  end)
end

autocmd("FileType", {
  pattern = "markdown",
  group = "allfiles",
  callback = function()
    vim.opt_local.formatoptions:append("tro")
    vim.opt_local.comments = "b:*,b:-,b:+,b:>"
    vim.opt_local.iskeyword:append("-")
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 79
    vim.opt_local.colorcolumn = "80"
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true

    vim.keymap.set('n', '<BS>', '<C-o>', { buffer = true, desc = 'Jump back' })
  end,
})

autocmd("FileType", {
  pattern = "gitcommit",
  group = "allfiles",
  command = "setlocal spell"
})

autocmd("FileType", {
  pattern = "python",
  group = "allfiles",
  command = "setlocal textwidth=99 colorcolumn=100 sw=4 sts=4 et"
})

autocmd("FileType", {
  pattern = "vim",
  group = "allfiles",
  command = "setlocal textwidth=99 colorcolumn=100 sw=2 sts=2 et"
})

autocmd("FileType", {
  pattern = "lua",
  group = "allfiles",
  command = "setlocal sw=2 sts=2 et"
})

autocmd("InsertLeave", {
  pattern = "*",
  group = "allfiles",
  command = "pclose"
})

autocmd({ "WinEnter", "BufWinEnter" }, {
  group = "allfiles",
  callback = maybe_close_last_qf_tab,
})
