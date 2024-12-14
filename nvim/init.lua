require('base.core')
require('base.plugins')
require('base.keymap')
require('base.misc')

require('base.lsp')
require('base.nvim-cmp')

-- require('plugins_prev.telescope')
require('plugins_prev.treesitter')

require('custom.ruby')
require('custom.go')
require('custom.lsp')
require('custom.utils')
require('custom.experiments')
require('custom.codeowners')

if vim.loop.fs_stat(vim.fn.expand("~/.config/nvim/lua/custom/work.lua")) then
	require('custom.work')
end
