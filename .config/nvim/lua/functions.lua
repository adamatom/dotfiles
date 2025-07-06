-- ripgrep integration
if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep"
    vim.opt.grepformat = { "%f:%l:%c:%m", "%f:%l:%m" }
    vim.api.nvim_create_user_command("Rg", function(opts)
        local args = table.concat(opts.fargs, " ")
        local cmd = "silent grep! " ..
            (opts.bang and "--no-ignore --hidden --glob '!tags' " or "") .. args
        vim.cmd(cmd)
        vim.cmd("botright copen 10 | redraw!")
    end, { bang = true, nargs = "+" })
end
