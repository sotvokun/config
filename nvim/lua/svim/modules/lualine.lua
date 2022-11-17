local use = require('svim.modules.package').use

use {'nvim-lualine/lualine.nvim'}
use {'sotvokun/falcon-lualine'}

-- Options -----------------------------------------------------------
local options = {
  section_separators = '',
  component_separators = ''
}

vim.api.nvim_create_augroup('SetLualineFalconTheme', {})
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Set lualine theme when theme is falcon',
  group = 'SetLualineFalconTheme',
  pattern = '*',
  callback = function()
    local colorscheme = vim.g.colors_name
    local lualine_setup_theme = function(theme)
      require('lualine').setup({
        options = {
          theme = theme or 'auto'
        }
      })
    end
    if colorscheme == 'falcon' and pcall(require, 'falcon-lualine') then
      lualine_setup_theme(require('falcon-lualine').theme())
      return
    end
    lualine_setup_theme()
  end
})

-- Components --------------------------------------------------------
local lsp_server = function()
  local bufnr = vim.fn.bufnr()
  local active_clients = vim.lsp.get_active_clients()
  local client_strings = {}
  for _, server in ipairs(active_clients) do
    if server.attached_buffers[bufnr] then
      table.insert(client_strings, server.name)
    end
  end
  return table.concat(client_strings, ' ')
end

local indent = function ()
  local expandtab = 'SPC'
  if not vim.bo.expandtab then
    expandtab = 'TAB'
  end
  local tabstop = vim.bo.tabstop
  local shiftwidth = vim.bo.shiftwidth
  return table.concat(
    {expandtab, ' ts=', tabstop, ' sw=', shiftwidth}, '')
end

-- Active Sections
local sections = {
  lualine_a = {}, lualine_b = {}, lualine_c = {},
  lualine_x = {}, lualine_y = {}, lualine_z = {}
}

sections.lualine_a = {
  {
    'mode',
    fmt = function() return ' ' end,
    padding = {left = 0, right = 0}
  }
}

sections.lualine_b = {
  {'filename', path = 1}
}

sections.lualine_c = {
  {'branch'},
  {'diff'}
}

sections.lualine_x = {
  {
    'diagnostics',
    symbols = {error = 'E ', warn = 'W ', info = 'I ', hint = 'H '}
  },
  { lsp_server },
  {'filetype'},
  {
    'fileformat',
    symbols = {unix = 'LF', dos = 'CRLF', mac = 'CR'}
  },
  {
    'encoding',
    fmt = function(str) return string.upper(str) end
  },
  {'location'}
}

-- Inactive sectionss
local inactive_sections = {
  lualine_a = {}, lualine_b = {}, lualine_c = {},
  lualine_x = {}, lualine_y = {}, lualine_z = {}
}

inactive_sections.lualine_c = {
  {'filename', path = 1}
}

inactive_sections.lualine_x = {
  {'location'}
}

-- Tabline
local tabline = {
  lualine_a = {}, lualine_b = {}, lualine_c = {},
  lualine_x = {}, lualine_y = {}, lualine_z = {}
}

tabline.lualine_b = {
  {'tabs', mode = 2},
}

tabline.lualine_x = {
  {indent, color = 'Comment'}
}

-- Apply -------------------------------------------------------------
do
  local ok, lualine = pcall(require, 'lualine')
  if ok then
    lualine.setup({
      options = options,
      extensions = {
        'aerial', 'neo-tree', 'quickfix', 'toggleterm', 'nvim-tree'
      },
      sections = sections,
      inactive_sections = inactive_sections,
      tabline = tabline
    })
  end
end
