vim.cmd([[ autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy ]])

vim.cmd([[ autocmd BufRead,BufNewFile Dangerfile set filetype=ruby ]])

vim.api.nvim_create_autocmd("VimResized", {
  pattern = '*',
  callback = function()
    vim.cmd('wincmd =')
  end
})
