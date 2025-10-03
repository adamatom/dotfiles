vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- When using a true color terminal like alacritty, some popup window plugins allow us to set
-- a transparency. We use this in our configuration in these plugins so we dont have to change it
-- everywhere.
vim.g.default_blend_level = 0

require 'options'
require 'functions'
require 'keymaps'
require 'autocommands'
require 'plugins'
