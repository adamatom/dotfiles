-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  To update plugins you can run
--    :Lazy update
--
require('lazy').setup({
  --- Colorschemes
  -- onedark, high contrast
  -- require 'plugins.onedarkhc',
  require 'plugins.catppuccin',
  -- require 'plugins.nightfox',
  -- require 'plugins.github-nvim-theme',
  -- require 'plugins.colorscheme-arctic',
  -- require 'plugins.colorscheme-cyberdream',
  -- require 'plugins.colorscheme-doomone',

  -- Show hex color codes as the color
  {'norcalli/nvim-colorizer.lua', config = function() require'colorizer'.setup() end},

  -- I use nvim as my 'git commit' editor, show the diff when editing a git commit
  'rhysd/committia.vim',

  -- Add Linux commands like :Move, :Rename, :Remove, and fix the vim buffers and state
  'tpope/vim-eunuch',

  -- allow things like 'griw' to replace the inner word with the " register in normal mode
  'vim-scripts/ReplaceWithRegister',

  -- display marks
  'kshenoy/vim-signature',

  -- reload files that are edited outside of nvim
  'djoshea/vim-autoread',

  -- Project wide search and replace
  'MagicDuck/grug-far.nvim',

  -- Completion engine
  require 'plugins.blink-cmp',

  -- File explorer
  require 'plugins.filebeagle',

  -- Git integration, mostly for GitBlame
  require 'plugins.fugitive',

  -- Show git gutter signs
  require 'plugins.gitsigns',

  -- Guess indentations
  require 'plugins.guess-indent',

  -- Provide an undo window to visualize the vim undo tree
  require 'plugins.gundo',

  -- Generate tags file automatically
  -- require 'plugins.gutentags',

  -- Jump to characters
  require 'plugins.hop',

  -- Show indentation level indicators
  require 'plugins.indent_line',

  -- Lint source code files
  require 'plugins.lint',

  -- Pull in sane defaults for LSP servers
  require 'plugins.lspconfig',

  -- Fancy status line
  require 'plugins.lualine',

  -- Changes vi UI elements, such as the command input and notifications
  require 'plugins.noice',

  -- Snacks for dashboard
  require 'plugins.snacks',

  -- Fuzzy find files (and other things like symbols from lsp)
  require 'plugins.telescope',

  -- Language aware syntax highlighting
  require 'plugins.treesitter',

  -- Show keybinds while we learn them
  require 'plugins.which-key',


  -- Allow for switching between which compile_commands.json
  require 'plugins.clangd_db_picker',

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
