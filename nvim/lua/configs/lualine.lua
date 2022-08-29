return function()
  local options = {
    section_separators = '',
    component_separators = ''
  }
  
  local sections = {
    lualine_a = {
      { 
        'mode', 
        fmt = function(str) return string.sub(str, 1, 1) end,
      }
    },
    lualine_b = {
      { 'filename', path = 1 }
    },
    lualine_c = {
      {'branch'}
    },
    lualine_x = {
      {
        'diagnostics',
        symbols = {
          ['error'] = 'E ',
          ['warn'] = 'W ',
          ['info'] = 'I ',
          ['hint'] = 'H ',
        }
      }
    },
    lualine_y = {
      {'filetype'},
      {
        'fileformat',
        symbols = {
          unix = 'LF',
          dos = 'CRLF',
          mac = 'CR'
        }
      },
      {
        'encoding',
        fmt = function(str) return string.upper(str) end
      }
    },
    lualine_z = {
      {'location'}
    }
  }
  
  local inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  }
  
  local extensions = {
    'nvim-tree',
    'quickfix'
  }
  
  local tabline = {
    lualine_a = {
      {
        'tabs',
        max_length = vim.o.columns,
        mode = 2
      }
    }
  }

  require('lualine').setup({
    options = options,
    sections = sections,
    inactive_sections = inactive_sections,
    extensions = extensions
  })
  vim.opt.showtabline = 1
end
