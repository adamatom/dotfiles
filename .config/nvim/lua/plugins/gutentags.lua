return {
  {
    'ludovicchabant/vim-gutentags',
    config = function()
      if vim.fn.executable("rg") == 1 then
        vim.g.gutentags_file_list_command = "rg --files"
      end
    end,
  }
}
