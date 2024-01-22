local M = {}

M.on_file_load = function()
    if vim.bo.filetype == "ruby" then
        vim.keymap.set("n", "<localleader>x", '<cmd>lua DbMigrate()<CR>')
        vim.keymap.set("n", "<localleader>c", '<cmd>lua BundleInstall()<CR>')
        vim.keymap.set("n", "<localleader>j", '<cmd>lua AltRubyFile()<CR>')
        vim.keymap.set("n", "<localleader>m", '<cmd>lua PackwerkPackageFile()<CR>')
    end

    if vim.bo.filetype == "go" then
        vim.keymap.set("n", "<localleader>r", '<cmd>!go run ./...<CR>')
        vim.keymap.set("n", "<localleader>t", '<cmd>GoTest<CR>')
        vim.keymap.set("n", "<localleader>b", '<cmd>GoBuild<CR>')
        vim.keymap.set("n", "<localleader>j", '<cmd>lua AltGoFile()<CR>')
    end
end

vim.cmd [[
    autocmd BufReadPost * lua require'custom.keymap'.on_file_load()
]]

return M
