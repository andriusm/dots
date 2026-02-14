return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'j-hui/fidget.nvim', opts = {} },

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
	},

	-- mason: only loads when you run :Mason or :MasonInstall
	{
		'williamboman/mason.nvim',
		cmd = { 'Mason', 'MasonInstall', 'MasonUpdate', 'MasonUninstall' },
		opts = {},
	},
	{
		'williamboman/mason-lspconfig.nvim',
		cmd = { 'LspInstall', 'LspUninstall' },
		dependencies = { 'williamboman/mason.nvim' },
		opts = {
			ensure_installed = { 'lua_ls', 'vimls', 'gopls', 'ts_ls', 'html', 'eslint' },
		},
	},
}
