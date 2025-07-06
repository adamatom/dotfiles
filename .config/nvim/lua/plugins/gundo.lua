return {
  {
    "sjl/gundo.vim",
    config = function()
      if vim.fn.has("python3") == 1 then
        vim.g.gundo_prefer_python3 = 1
      end

      vim.keymap.set("n", "<leader>Wg", ":GundoToggle<CR>", {
        silent = true,
        desc = "show the [W]indow for [g]undo",
      })
    end,
  }
}
