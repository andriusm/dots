vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.cmd([[ autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy ]])

vim.cmd([[ autocmd BufRead,BufNewFile Dangerfile set filetype=ruby ]])
