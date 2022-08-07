local wezterm = require('wezterm')

-- Configuration

local configuration = {
  font = wezterm.font_with_fallback ({
    'Iosevka Pragmatus',
    'Source Han Sans'
  }),

  color_scheme = 'Neutron',

  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
  },

  tab_bar_at_bottom = true,

  prefer_egl = false
}

if (wezterm.target_triple == 'x86_64-pc-windows-msvc') then
  configuration.default_prog = { 'powershell' }
end

return configuration
-- vim: sw=2
