return {
	'nvim-lualine/lualine.nvim',
	config = function()
		local cached_branch = ''

		local function refresh_branch()
			vim.system({ 'git', 'rev-parse', '--abbrev-ref', 'HEAD' }, { text = true }, function(result)
				if result.code == 0 then
					cached_branch = vim.trim(result.stdout)
				else
					cached_branch = ''
				end
			end)
		end

		refresh_branch()

		vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'DirChanged' }, {
			callback = refresh_branch,
		})

		require('lualine').setup({
			options = {
				icons_enabled = false,
				theme = 'auto',
				component_separators = '|',
				section_separators = '',
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = {
					{
						function()
							return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
						end,
					},
					{
						function()
							return cached_branch
						end,
					},
				},
				lualine_c = { 'filename' },

				lualine_x = { 'encoding', 'fileformat', 'filetype' },
				lualine_y = { 'progress' },
				lualine_z = { 'location' },
			},
		})
	end
}
