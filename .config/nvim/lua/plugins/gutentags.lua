return {
  {
    'ludovicchabant/vim-gutentags',
    config = function()
      if vim.fn.executable("rg") == 1 then
        vim.g.gutentags_file_list_command = "rg --files"
      end
      -- put tags/temp/lock files into ~/.cache/tags instead of project root
      vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/tags")

      -- Good defaults for Universal Ctags
      vim.g.gutentags_ctags_extra_args = {
        "--tag-relative=yes",
        "--fields=+l",      -- include language
        "--fields=+iaS",    -- include access, implementation, signature (useful)
        "--extras=+q",      -- include qualified tag names where available
      }

      -- exclude noisy dirs
      vim.g.gutentags_ctags_exclude = {
        ".git", "node_modules", "dist", ".cache", ".venv", "venv",
      }
    end,
  }
}
