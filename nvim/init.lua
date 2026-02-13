require('base.core')
require('base.plugins')
require('base.keymap')
require('base.misc')

require('base.lsp')
require('base.nvim-cmp')

require('custom.markdown')
require('custom.todo')
require('custom.ruby')
require('custom.go')
require('custom.lsp')
require('custom.adoc')
require('custom.utils')
require('custom.experiments')

if vim.uv.fs_stat(vim.fn.expand("~/.config/nvim/lua/custom/work.lua")) then
	require('custom.work')
end
