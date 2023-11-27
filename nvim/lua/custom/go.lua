function AltGoFile()
    if vim.bo.filetype ~= "go" then
        return
    end

    local cfile = vim.fn.expand('%:f')

    if string.find(cfile, "_test.go$") then
        cfile = string.gsub(cfile, "_test.go$", ".go")
    else
        cfile = string.gsub(cfile, ".go$", "_test.go")
    end

    print(cfile)
    vim.cmd(":edit " .. cfile)
end

vim.keymap.set("n", "<leader>tb", '<cmd>!go test -bench=.<CR>')
