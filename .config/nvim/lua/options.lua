-- [[ Setting options ]]

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.history = 1000

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.list = true
vim.opt.listchars = { tab = '»·', trail = '·', nbsp = '␣', extends = '…' }
vim.opt.showbreak = "  … "

-- Layout and wrapping
vim.opt.wrap = false
vim.opt.textwidth = 99
vim.opt.scrolloff = 15
vim.opt.sidescroll = 5
vim.opt.colorcolumn = "100"

-- Formatting
vim.opt.formatoptions = "crqn1"

-- Preview substitutions live
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

vim.opt.gdefault = true
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }
vim.opt.title = true
vim.opt.titleold = ""
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildignore:append { "*.pyc", "*.o", "*.zwc" }
vim.opt.foldenable = false
vim.opt.diffopt = { "filler", "context:1000000" }
vim.opt.laststatus = 2
vim.opt.ttimeoutlen = 10
vim.opt.belloff = "all"
vim.opt.completeopt = { "menuone", "noinsert" }
vim.opt.timeout = false

-- Spell undercurl
vim.cmd([[
highlight SpellBad cterm=undercurl
highlight SpellBad gui=undercurl
]])

-- vim: ts=2 sts=2 sw=2 et
