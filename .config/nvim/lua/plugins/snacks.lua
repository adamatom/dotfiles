local sections = {
  { pane = 1, section = "startup" },
  { section = "keys", gap = 1, padding = 1 },
  { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
  { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
  {
    pane = 2,
    icon = " ",
    title = "Git Status",
    section = "terminal",
    enabled = function()
      return Snacks.git.get_root() ~= nil
    end,
    cmd = "git status --short --branch --renames",
    height = 10,
    padding = 1,
    ttl = 5 * 60,
    indent = 3,
  },
}

return {
  {
    "folke/snacks.nvim",
    priority=1000,
    opts = {
      dashboard = { sections = sections },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
    },
  }
}
