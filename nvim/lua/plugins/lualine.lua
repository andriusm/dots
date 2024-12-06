return {
	-- Set lualine as statusline
	'nvim-lualine/lualine.nvim',
	-- See `:help lualine.txt`
	-- opts = {
	--   options = {
	--     path = 1,
	--     icons_enabled = false,
	--     theme = 'auto',
	--     component_separators = '|',
	--     section_separators = '',
	--   },
	-- },
	config = function()
		require('lualine').setup({
			path = 0,
			icons_enabled = false,
			theme = 'auto',
			component_separators = '|',
			section_separators = '',
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { function()
					return ""
				end
				},
				lualine_c = { 'filename' },
				lualine_x = { 'encoding', 'fileformat', 'filetype' },
				lualine_y = { 'progress' },
				lualine_z = { 'location' },
			},
		})
	end
}
