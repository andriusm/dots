local wezterm = require("wezterm")

local keys = {}
local scheme_light = 'Solarized Light (Gogh)'
local scheme_dark = 'Solar Flare (base16)'

keys = {
  {
    key = 't',
    mods = 'ALT',
    action = wezterm.action.SpawnTab('CurrentPaneDomain'),
  },
  {
    key = 'c',
    mods = 'ALT',
    action = wezterm.action_callback(function(window, pane)
      local overrides = window:get_config_overrides() or {}
      local current_scheme = overrides.color_scheme
      local new_scheme = current_scheme == scheme_light and scheme_dark or scheme_light

      print('Switching color scheme to', new_scheme)

      window:set_config_overrides({
        color_scheme = new_scheme,
      })
    end),
  },
  {
    key = '\\',
    mods = 'ALT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '|',
    mods = 'SHIFT|ALT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  { key = 'a', mods = 'ALT', action = wezterm.action.PaneSelect },
  {
    key = 'h',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
}

for i = 1, 8 do
  table.insert(keys, {
    key = tostring(i),
    mods = 'ALT',
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return keys
