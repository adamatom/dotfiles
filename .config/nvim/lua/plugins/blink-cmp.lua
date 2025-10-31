return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
      preset = 'none',
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<Esc>'] = { 'hide', 'fallback' },

        ['<CR>'] = { 'accept', 'fallback' },

        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },

        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
        ['<C-d>'] = { 'show_documentation', 'hide_documentation' },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = 'normal',
      },

      cmdline = {
        keymap = {
          ['<Tab>'] = { 'show_and_insert', 'select_next' },
          ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },


          ['/'] = {'accept', 'fallback' },
          ['<C-space>'] = { 'show', 'fallback' },

          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
          ['<Right>'] = { 'select_next', 'fallback' },
          ['<Left>'] = { 'select_prev', 'fallback' },
          ['<C-k>'] = { 'select_prev', 'fallback' },
          ['<C-j>'] = { 'select_next', 'fallback' },

          ['<C-y>'] = { 'select_and_accept' },
          ['<C-e>'] = { 'cancel' },
        },
        completion = {
          menu = { auto_show = false },
          ghost_text = { enabled = false },
        },
      },

      completion = {
        documentation = {
          -- Controls whether the documentation window will automatically show
          auto_show = false,
          -- Delay before showing the documentation window
          auto_show_delay_ms = 500,
          -- Delay before updating the documentation window when selecting a new item,
          -- while an existing item is still visible
          update_delay_ms = 50,
          -- Whether to use treesitter highlighting, disable if you run into performance issues
          treesitter_highlighting = true,
          window = { winblend = vim.g.default_blend_level },
        },
        list = { selection = { preselect = false, auto_insert = true }, },
        menu = {
          winblend = vim.g.default_blend_level,
        },
        trigger = { show_in_snippet = false },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead
      fuzzy = { implementation = 'lua' },
    },
  },
}
