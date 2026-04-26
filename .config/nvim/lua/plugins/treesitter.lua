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

      local ts_filetypes = {
        bash = true,
        c = true,
        diff = true,
        html = true,
        lua = true,
        luadoc = true,
        markdown = true,
        query = true,
        vim = true,
        help = true,
      }

      local function enable_treesitter(buf)
        local ft = vim.bo[buf].filetype
        if ft == '' or not ts_filetypes[ft] then
          return
        end

        local ok = pcall(vim.treesitter.start, buf)
        if not ok then
          return
        end

        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      -- Enable highlighting + indent for future buffers.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = vim.tbl_keys(ts_filetypes),
        callback = function(args)
          enable_treesitter(args.buf)
        end,
      })

      -- Retry once startup has fully completed. This covers the initial file
      -- opened by `nvim somefile` when early-render plugins attach too soon.
      vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          enable_treesitter(buf)

          -- If treesitter is not enabled for this filetype and quickfile ran
          -- before filetype detection completed, ensure classic syntax
          -- highlighting is attached after startup.
          if vim.bo[buf].buftype == '' and vim.bo[buf].filetype ~= '' and vim.bo[buf].syntax == '' then
            vim.bo[buf].syntax = vim.bo[buf].filetype
          end
        end,
      })
    end,
  },
}
