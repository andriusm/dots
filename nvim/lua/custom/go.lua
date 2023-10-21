vim.keymap.set("n", "<localleader>r", '<cmd>GoRun<CR>')
vim.keymap.set("n", "<localleader>t", '<cmd>GoTest<CR>')
vim.keymap.set("n", "<localleader>b", '<cmd>GoBuild<CR>')

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

vim.keymap.set("n", "<localleader>j", '<cmd>lua AltGoFile()<CR>')
