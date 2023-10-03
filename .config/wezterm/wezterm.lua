local wezterm = require('wezterm')
local actions = wezterm.action

-- Wezterm Events

-- Configuration

local configuration = {}

if wezterm.config_builder then
  configuration = wezterm.config_builder()
end

-- Keybindings

local leader_key = { key='`', mods='CTRL', timeout_milliseconds=500 }

local key_bindings = {
  -- Fix Leader Key
  { 
    key='`', 
    mods='LEADER|CTRL', 
    action=wezterm.action.SendKey({
      key='`',
      mods='CTRL'
    })
  },

  { key='F11', mods='ALT', action=wezterm.action.ToggleFullScreen },
  { key='e', mods='CTRL|ALT', action=wezterm.action.ActivateCommandPalette },

  -- MUX
  { 
    key='s', 
    mods='LEADER', 
    action=wezterm.action.SplitVertical({
      domain='CurrentPaneDomain'
    }) 
  },
  { 
    key='v', 
    mods='LEADER', 
    action=wezterm.action.SplitHorizontal({
      domain='CurrentPaneDomain'
    }) 
  },
  { key='h', mods='LEADER', action=wezterm.action.ActivatePaneDirection('Left') },
  { key='j', mods='LEADER', action=wezterm.action.ActivatePaneDirection('Down') },
  { key='k', mods='LEADER', action=wezterm.action.ActivatePaneDirection('Up') },
  { key='l', mods='LEADER', action=wezterm.action.ActivatePaneDirection('Right') },
  { key='q', mods='LEADER|CTRL', action=wezterm.action.CloseCurrentPane({ confirm=false }) },

  { 
    key='c', 
    mods='LEADER', 
    action=wezterm.action.SpawnTab('CurrentPaneDomain')
  },
  { key='[', mods='LEADER', action=wezterm.action.ActivateTabRelative(-1) },
  { key=']', mods='LEADER', action=wezterm.action.ActivateTabRelative( 1) },
  { key='x', mods='LEADER|CTRL', action=wezterm.action.CloseCurrentTab({ confirm=false }) },
  { key='c', mods='CTRL|SHIFT', action=wezterm.action.CopyTo('Clipboard') },
  { key='v', mods='CTRL|SHIFT', action=wezterm.action.PasteFrom('Clipboard') }
}

local macos_bindings = {
  { key='c', mods='CMD', action=wezterm.action.CopyTo('Clipboard') },
  { key='v', mods='CMD', action=wezterm.action.PasteFrom('Clipboard') },
}

-- Configurations

configuration = {
  -- Faces
  use_resize_increments = true,
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
  keys = key_bindings,
  leader = leader_key
}

if (wezterm.target_triple == 'x86_64-pc-windows-msvc') then
  configuration.default_prog = { 'powershell' }
elseif (string.match(wezterm.target_triple, 'darwin')) then
  configuration.font_size = 14
  for _, v in ipairs(macos_bindings) do
    table.insert(configuration.keys, v)
  end
end

return configuration
-- vim: sw=2:ts=2
