return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      views = {
        cmdline_popup = {
          position = {
            row = 10,
            col = "50%",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winblend = vim.g.default_blend_level / 2,
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winblend = vim.g.default_blend_level,
          },
        },
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and pop up menu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.vim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      -- Hide specific messages that appear too often:
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written", },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", kind = "", find = "lines yanked", },
          opts = { skip = true },
        },
        {
          filter = { event = 'msg_show', kind = '', find = 'more line', },
          opts = { skip = true },
        },
        {
          filter = { event = 'msg_show', kind = '', find = 'fewer line', },
          opts = { skip = true },
        },
        {
          filter = { event = 'msg_show', kind = '', find = 'lines >ed', },
          opts = { skip = true },
        },
        {
          filter = { event = 'msg_show', kind = '', find = 'lines <ed', },
          opts = { skip = true },
        },
        {
          filter = { event = 'msg_show', kind = '', find = 'indented', },
          opts = { skip = true },
        },
        {
          filter = { event = 'msg_show', kind = '', find = 'E37: No write since last change', },
          opts = { skip = true },
        },
        {
          filter = { event = 'msg_show', kind = '', find = 'Hop 1 char', },
          opts = { skip = true },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = { stages = "fade", render = "compact", },
      },
    }
  }
}
