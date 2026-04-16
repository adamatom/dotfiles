return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      require('nvim-treesitter').setup({
        -- Where parsers get installed (default is fine)
        install_dir = vim.fn.stdpath('data') .. '/site',
      })

      -- Install parsers you want. This runs async on first launch.
      require('nvim-treesitter').install({
        'bash', 'c', 'diff', 'html', 'lua', 'luadoc',
        'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
      })

      -- Enable highlighting + indent per filetype.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'bash', 'c', 'diff', 'html', 'lua', 'luadoc',
          'markdown', 'query', 'vim', 'help',
        },
        callback = function(args)
          -- Highlighting
          local ok = pcall(vim.treesitter.start, args.buf)
          if not ok then return end
          -- Indent (opt-in per buffer; skip for filetypes where it misbehaves)
          if vim.bo[args.buf].filetype ~= 'ruby' then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
          -- Folds, if you want them
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
      })
    end,
  },
}
