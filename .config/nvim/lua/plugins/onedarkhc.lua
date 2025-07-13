return {
  {
    'pacokwon/onedarkhc.vim',
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.opt.background = "dark"
      vim.cmd("colorscheme onedarkhc")
    end
  },
}
