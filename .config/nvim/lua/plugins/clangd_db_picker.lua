return {
  "adamatom/clangd-db-picker.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  keys = {
    {
      "<leader>cc",
      "<cmd>ClangdDbPick<cr>",
      desc = "Pick compile_commands.json (clangd-db-picker)",
    },
  },
  config = function()
    require("clangd_db_picker").setup({})
  end,
}
