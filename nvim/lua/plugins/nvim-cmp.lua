return {
	-- cmp-nvim-lsp loads early (tiny, needed for LSP capabilities)
	{ 'hrsh7th/cmp-nvim-lsp', lazy = false },

	-- Autocompletion - deferred until first insert mode
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
		config = function()
			require('base.nvim-cmp')
		end,
	},
}
