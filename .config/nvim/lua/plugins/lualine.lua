return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Custom function for filename display
      local function custom_filename()
        local buftype = vim.bo.buftype
        if buftype == "quickfix" then
          return vim.fn.getqflist({ title = 0 }).title or "[Quickfix List]"
        elseif buftype == "nofile" and vim.bo.filetype == "qf" then
          return "[Location List]"
        end
 
        local fullpath = vim.fn.expand("%:~:.")
        local short = vim.fn.expand("%:t")
        local max_len = 120
 
        if #fullpath > max_len then
          return (#short > max_len) and "[No Name]" or short
        end
        return fullpath ~= "" and fullpath or "[No Name]"
      end
 
      -- Readonly icon if file is readonly
      local function readonly_icon()
        return vim.bo.readonly and "🔒" or ""
      end
 
      -- Git branch using fugitive#head()
      local function fugitive_branch()
        if vim.bo.filetype ~= "vimfiler" and vim.fn.exists("*fugitive#head") == 1 then
          return vim.fn["fugitive#head"]()
        end
        return ""
      end
 
      -- Gutentags statusline integration
      local function gutentags_status()
        if vim.fn.exists("*gutentags#statusline") == 1 then
          return vim.fn["gutentags#statusline"]()
        end
        return ""
      end
 
      require("lualine").setup({
        options = {
          theme = "onedark",  -- equivalent to 'one' in lightline
          icons_enabled = true,
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = { "mode", "paste" },
          lualine_b = { fugitive_branch },
          lualine_c = { custom_filename, readonly_icon },
          lualine_x = { gutentags_status },
          lualine_y = { "fileformat", "fileencoding", "filetype" },
          lualine_z = { "location", "progress" },
        },
      })
    end,
  }
}
