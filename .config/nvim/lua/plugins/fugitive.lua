return {
  {
    'tpope/vim-fugitive',
    dependencies = {
      'tommcdo/vim-fugitive-blame-ext'  -- Show commit message in fugitive blame window
    },
    config = function()
      -- Create an augroup to avoid duplicate autocmds on reload
      local group = vim.api.nvim_create_augroup("fugitivecleanup", { clear = true })

      -- Automatically delete fugitive:// buffers after reading
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = group,
        pattern = "fugitive://*",
        command = "set bufhidden=delete",
      })
    end,
  },
}
