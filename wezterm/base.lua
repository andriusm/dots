local wezterm = require("wezterm")
local config = {}

-- config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
-- config.font = wezterm.font("DaddyTimeMono Nerd Font Mono")
-- config.font = wezterm.font("BigBlueTermPlus Nerd Font Mono")
-- config.font = wezterm.font("CaskaydiaCove Nerd Font Mono")
-- config.font = wezterm.font("ComicShannsMono Nerd Font Mono")
-- config.font = wezterm.font("GoMono Nerd Font Mono")
-- config.font = wezterm.font("GohuFont uni11 Nerd Font Mono")
config.font = wezterm.font("Hack Nerd Font Mono")
-- config.font = wezterm.font("Hurmit Nerd Font Mono")
-- config.font = wezterm.font("Iosevka Nerd Font Mono")
-- config.font = wezterm.font("Lekton Nerd Font Mono")
-- config.font = wezterm.font("M+1Code Nerd Font Mono")
-- config.font = wezterm.font("Monoid Nerd Font Mono")
-- config.font = wezterm.font("ProFont IIx Nerd Font Mono")
-- config.font = wezterm.font("ProggyClean Nerd Font Mono")
-- config.font = wezterm.font("ShureTechMono Nerd Font Mono")
-- config.font = wezterm.font("SpaceMono Nerd Font Mono")
config.font_size = 16.0 -- best fit for split screen

-- config.color_scheme = 'PaleNightHC'
-- config.color_scheme = 'PencilLight'
-- config.color_scheme = 'PencilDark'
config.color_scheme = 'Solar Flare (base16)'
-- config.color_scheme = 'Solarized Light (Gogh)'

config.pane_select_font_size=64

config.scrollback_lines = 10000
config.default_workspace = "home"
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.window_close_confirmation = "AlwaysPrompt"
-- config.default_window_size = { width = 140, height = 40 }
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
-- config.use_fancy_title_bar = false
config.status_update_interval = 1000

return config
