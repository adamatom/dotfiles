-- [[ Setting options ]]

-- Make line numbers default
vim.opt.number = true

-- Run with full color support
vim.opt.termguicolors = true

-- popup windows use a slight transparency
vim.opt.winblend = vim.g.default_blend_level

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.history = 1000

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn off if nothing to show
vim.opt.signcolumn = 'auto'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Indentation
vim.opt.expandtab = true  -- Use spaces instead of tabs by default
vim.opt.tabstop = 4  -- A tab is four characters wide
vim.opt.shiftwidth = 4  -- four characters for auto-indenting
vim.opt.softtabstop = 4
vim.opt.smartindent = true  -- follow c-like indentation guidelines
vim.opt.shiftround = true  -- round to shiftwidth instead of inserting tabstop characters
vim.opt.list = true  -- show whitespaces as defined by listchars
vim.opt.listchars = { tab = '»·', trail = '·', nbsp = '␣', extends = '…' }
vim.opt.showbreak = "  … "

-- Layout and wrapping
vim.opt.textwidth = 99
vim.opt.scrolloff = 15
vim.opt.sidescroll = 5
vim.opt.colorcolumn = "100"
vim.opt.wrap = false

-- Formatting
vim.opt.formatoptions = "crqn1"

-- Preview substitutions live
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Match ls-style tab completion on the cmdmenu
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }

-- Make g the default on things like s/PATTERN/REPLACE/g
vim.opt.gdefault = true

-- Enable spellchecker
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

-- Set the title of the window
vim.opt.title = true
vim.opt.titleold = ""

-- filler is default and inserts empty lines for sync
vim.opt.diffopt = { "filler", "context:1000000" }

-- decrease timeout for terminal keycodes for faster insert exits
vim.opt.ttimeoutlen = 10

vim.opt.completeopt = { "menuone", "noinsert" }

-- Spell undercurl
vim.cmd([[
highlight SpellBad cterm=undercurl
highlight SpellBad gui=undercurl
]])
