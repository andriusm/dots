return {
	{
		'nvim-treesitter/nvim-treesitter',
		branch = 'main',
		lazy = false,
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter').install({ 'go', 'lua' }, { summary = false }):wait(30000)

			vim.api.nvim_create_autocmd('FileType', {
				callback = function(event)
					pcall(vim.treesitter.start, event.buf)
				end,
			})
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		branch = 'main',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			local ts_textobjects = require('nvim-treesitter-textobjects')
			ts_textobjects.setup {
				select = {
					lookahead = true,
				},
				move = {
					set_jumps = true,
				},
			}

			local select = require('nvim-treesitter-textobjects.select')
			vim.keymap.set({ 'x', 'o' }, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end)
			vim.keymap.set({ 'x', 'o' }, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end)
			vim.keymap.set({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end)
			vim.keymap.set({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end)
			vim.keymap.set({ 'x', 'o' }, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end)
			vim.keymap.set({ 'x', 'o' }, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end)

			local move = require('nvim-treesitter-textobjects.move')
			vim.keymap.set({ 'n', 'x', 'o' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end)
			vim.keymap.set({ 'n', 'x', 'o' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end)
			vim.keymap.set({ 'n', 'x', 'o' }, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end)
			vim.keymap.set({ 'n', 'x', 'o' }, '][', function() move.goto_next_end('@class.outer', 'textobjects') end)
			vim.keymap.set({ 'n', 'x', 'o' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end)
			vim.keymap.set({ 'n', 'x', 'o' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end)
			vim.keymap.set({ 'n', 'x', 'o' }, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end)
			vim.keymap.set({ 'n', 'x', 'o' }, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end)

			local swap = require('nvim-treesitter-textobjects.swap')
			vim.keymap.set('n', '<leader>i', function() swap.swap_next('@parameter.inner') end)
			vim.keymap.set('n', '<leader>I', function() swap.swap_previous('@parameter.inner') end)
		end,
	},
}
