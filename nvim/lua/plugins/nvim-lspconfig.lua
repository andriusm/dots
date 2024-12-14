return {
	'neovim/nvim-lspconfig',
	dependencies = {
		{ 'williamboman/mason.nvim', config = true },
		{ 'williamboman/mason-lspconfig.nvim' },

		{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
}
