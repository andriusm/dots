vim.opt.tabstop = 4
vim.opt.colorcolumn = '120'
vim.opt.textwidth = 120

vim.keymap.set("n", "<localleader>x", '<cmd>lua DbMigrate()<CR>')
vim.keymap.set("n", "<localleader>c", '<cmd>lua BundleInstall()<CR>')
vim.keymap.set("n", "<localleader>j", '<cmd>lua AltRubyFile()<CR>')
vim.keymap.set("n", "<localleader>m", '<cmd>lua PackwerkPackageFile()<CR>')
vim.keymap.set("n", "<leader>xp", "<cmd>lua PackwerkCheck()<CR>")
vim.keymap.set("n", "<leader>ro", "<cmd>lua BundleOutdated()<CR>")
vim.keymap.set("n", "<leader>fo", require('toolbox.fs').find_owners_of_current_file)
