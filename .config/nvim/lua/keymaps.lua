-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local opts = { silent = true }

-- toggle spelling quickly
vim.keymap.set("n", "<leader>os", ":set spell! spell?<CR>", silent)

-- toggle line numbers
vim.keymap.set("n", "<leader>on", ":set number! number?<CR>", silent)

-- toggle relative number
vim.keymap.set("n", "<leader>or", ":set relativenumber! relativenumber?<CR>", silent)

-- navigate through quickfix and locationlists
vim.keymap.set("n", "<leader>q", ":cnext<CR>", silent)
vim.keymap.set("n", "<leader>Q", ":cprevious<CR>", silent)
vim.keymap.set("n", "<leader>l", ":lnext<CR>", silent)
vim.keymap.set("n", "<leader>L", ":lprevious<CR>", silent)

-- save on leader w
vim.keymap.set("n", "<leader>w", ":w<CR>", silent)

-- Switch between the last two files
vim.keymap.set("n", "<leader>a", "<C-^>")

-- search for the word under the cursor using Rg, defined in functions
vim.keymap.set("n", "<leader>F", [[:Rg "<C-R><C-w>"]], { noremap = true })


-- Spell check the last error.
-- <ctrl-g>u     create undo marker (before fix) so we can undo/redo this
--               change. Otherwise vim treats the spelling correction as the
--               same change as our edit.
-- esc           enter normal mode
-- [s            jump back to previous spelling mistake
-- 1z=           take the first correction
-- `]            jump back
-- a             continue editing
-- <ctrl-g>u     create another undo marker
vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u")


-- Begin a word search and replace
vim.keymap.set("n", "<leader>R", [[:%s/\<<C-r><C-w>\>//c<Left><Left>]])

-- Dont clobber the yank register when replacing text by pasting on top of a visual selection
vim.keymap.set("x", "p", [[p:let @+=@0<CR>:let @"=@0<CR>]], silent)

-- Advance to next misspelling after adding a word to the spellfile.
vim.keymap.set("n", "zg", "zg]s")

-- typing jj in insert mode gets you out.
vim.keymap.set("i", "jj", "<Esc>")

-- disable arrow keys in normal mode
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("n", "<left>", "<nop>")
vim.keymap.set("n", "<right>", "<nop>")

-- fix direction keys for line wrap, other wise they jump over wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- remap f1. I'll type :help when I want it
vim.keymap.set("n", "<F1>", "<Esc>")
vim.keymap.set("i", "<F1>", "<Esc>")

-- I have never intentionally entered the mode that q: gives.
vim.keymap.set("n", "q:", ":q")
vim.keymap.set("n", "Q", "<nop>")

-- Indent in visual and select mode automatically re-selects.
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")


-- Scroll the page, keeping the cursor in the same location
vim.keymap.set("n", "<C-j>", "<C-e>j")
vim.keymap.set("n", "<C-k>", "<C-y>k")

-- Disable this quit command, it is a small typo away from <C-w>w, which cycles windows
vim.keymap.set("n", "<C-w>q", "<nop>")
vim.keymap.set("n", "<C-w>Q", "<nop>")


-- Command-line abbreviations
-- :wq when I meant :w. Nudges towards using :x
-- :W isnt a command, and I usually intend on :w
-- :X is a strange crypto thing that I dont care about, intention is :x
-- :Q enters modal ex mode, I'm happy with just ex command line. Generally mistyped :q
-- Similar to above, I generally mean :qa
-- Tabnew -> tabnew
vim.cmd([[
cabbrev wq w
cabbrev W w
cabbrev X x
cabbrev Q q
cabbrev Qa qa
cabbrev Tabnew tabnew
]])

-- vim: ts=2 sts=2 sw=2 et
