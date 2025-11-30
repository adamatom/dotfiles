return {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cyberdream").setup({
        -- Set light or dark variant
        variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`

        -- Enable italics comments
        italic_comments = true,

        -- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
        borderless_pickers = true,

        -- Disable or enable colorscheme extensions
        extensions = {
            telescope = true,
            notify = true,
            mini = true,
        },
    })
    vim.cmd("colorscheme cyberdream")
  end,
}
