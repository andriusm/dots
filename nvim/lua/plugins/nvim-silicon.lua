return {
	'michaelrommel/nvim-silicon',
	lazy = true,
	cmd = "Silicon",
	config = function()
		require("silicon").setup({
			font = "Menlo=34;Menlo=34",
			background = "#e3f9fd"
		})
	end
}
