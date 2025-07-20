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
        return vim.bo.readonly and "󰈡" or ""
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
          section_separators = { left = "", right = "" },
          component_separators = "",
        },

        winbar = { lualine_c = { custom_filename, readonly_icon }, },
        inactive_winbar = { lualine_c = { custom_filename, readonly_icon }, },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {  },
          lualine_x = { "lsp_status", gutentags_status, "searchcount", "selectioncount" },
          lualine_y = { "fileformat", "fileencoding", "filetype" },
          lualine_z = {
            { "location", "progress" },
            {
              function() return "" end,
              padding = { left = 0, right = 1 },
            },
          },
        },
        inactive_sections = {
          lualine_a = { },
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {  },
          lualine_x = { "lsp_status", gutentags_status, "searchcount", "selectioncount" },
          lualine_y = { "fileformat", "fileencoding", "filetype" },
          lualine_z = {
            { "location", "progress" },
            {
              function() return "" end,
              padding = { left = 0, right = 1 },
            },
          },
        },
      })
    end,
  }
}
