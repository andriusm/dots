local wezterm = require("wezterm")

local config = {}

-- config.color_scheme = "Tokyo Night"

config.font_size = 28.0
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
-- config.font_size = 16.0 -- best fit for split screen

config.scrollback_lines = 10000
config.default_workspace = "home"

-- config.window_background_opacity = 0.8
config.window_close_confirmation = "AlwaysPrompt"
config.default_window_size = { width = 140, height = 40 }
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
-- config.use_fancy_title_bar = false
config.status_update_interval = 1000

--
-- events
--

wezterm.on("update-right-status", function(window, pane)
	local time = os.date("%H:%M:%S    ")
	if time then
		window:set_right_status(time, { fg_color = "#ff0000" })
	end
end)

wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
end)

return config
