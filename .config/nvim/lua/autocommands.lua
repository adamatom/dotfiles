vim.api.nvim_create_augroup("allfiles", { clear = true })

local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  pattern = "markdown",
  group = "allfiles",
  callback = function()
    vim.opt_local.formatoptions:append("t")
    vim.opt_local.iskeyword:append("-")
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 79
    vim.opt_local.colorcolumn = "80"
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end
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
