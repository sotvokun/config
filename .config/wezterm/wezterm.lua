local wezterm = require('wezterm')
local actions = wezterm.action

-- Wezterm Events

-- Configuration

local configuration = {}

if wezterm.config_builder then
    configuration = wezterm.config_builder()
end

local mouse_binding = {
  {
    event = { Down = { streak = 1, button = 'Right' }},
    mods = 'NONE',
    action = wezterm.action({ PasteFrom = 'Clipboard' })
  }
}

configuration = {
    color_scheme = 'Builtin Tango Dark',

  -- Window and Pane
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  },
  inactive_pane_hsb = { saturation = 0, brightness = 0.5 },

  -- Font
  font = wezterm.font_with_fallback ({
    { family = 'Iosevka Pragmatus' } ,
    'Source Han Sans'
  }),
  -- freetype_load_target = 'Normal',
  -- freetype_render_target = 'HorizontalLcd',
  -- freetype_load_flags = 'MONOCHROME',
  font_size = 12,

  -- Tab
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = true,

  -- Keys
  enable_kitty_keyboard = true,
  enable_csi_u_key_encoding = true,
  disable_default_key_bindings = true,
  keys = {
    { key = 'F11', mods='ALT', action = wezterm.action.ToggleFullScreen },
  },
  mouse_bindings = mouse_binding
}

if (wezterm.target_triple == 'x86_64-pc-windows-msvc') then
  configuration.default_prog = { 'powershell' }
elseif (string.match(wezterm.target_triple, 'darwin')) then
  configuration.font_size = 14
end

return configuration
-- vim: sw=2:ts=2
