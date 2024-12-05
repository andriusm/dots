vim.opt.tabstop = 4

vim.keymap.set("n", "<localleader>e", '<cmd>!go run %<CR>')
vim.keymap.set("n", "<localleader>r", '<cmd>!go run ./...<CR>')
vim.keymap.set("n", "<localleader>t", '<cmd>GoTest<CR>')
vim.keymap.set("n", "<localleader>b", '<cmd>GoBuild<CR>')
vim.keymap.set("n", "<localleader>j", '<cmd>lua AltGoFile()<CR>')
vim.keymap.set("n", "<leader>tb", '<cmd>!go test -bench=.<CR>')
