-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  To update plugins you can run
--    :Lazy update
--
require('lazy').setup({
  'rhysd/committia.vim', -- show the diff when editing a git commit
  'tpope/vim-eunuch', -- Add Linux commands like :Move and :Rename
  'vim-scripts/ReplaceWithRegister',
  'kshenoy/vim-signature', -- display marks

  {
    'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
    config = function() require('guess-indent').setup {} end
  },

  {
    'jeetsukumaran/vim-filebeagle',
    config = function() vim.g.filebeagle_show_hidden = 1 end
  },

  {
    'ludovicchabant/vim-gutentags',
    config = function()
      if vim.fn.executable("rg") == 1 then
        vim.g.gutentags_file_list_command = "rg --files"
      end
    end,
  },


  -- require 'plugins.onedark',
  -- require 'plugins.kanagawa',
  {
    'pacokwon/onedarkhc.vim',
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.opt.background = "dark"
      vim.cmd("colorscheme onedarkhc")
    end
  },

  require 'plugins.blink-cmp',
  require 'plugins.conform',
  require 'plugins.gitsigns',
  require 'plugins.gundo',
  require 'plugins.hop',
  require 'plugins.indent_line',
  require 'plugins.lualine',
  require 'plugins.lint',
  require 'plugins.lspconfig',
  require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.which-key',


  {
    '2kabhishek/nerdy.nvim',
    dependencies = {
      'folke/snacks.nvim',
    },
    cmd = 'Nerdy',
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
