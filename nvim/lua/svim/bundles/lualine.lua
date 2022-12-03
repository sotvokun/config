-- =========================================================
--
-- lualine.lua
--
-- =========================================================

svim.use {'nvim-lualine/lualine.nvim'}
svim.use {'sotvokun/falcon-lualine'}

svim.require('falcon-lualine', function(fl)
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
    if vim.g.colors_name == 'falcon' then
        vim.cmd('silent! colorscheme falcon')
    end
end)

-- - Options
local options = {
    section_separators = '',
    component_separators = ''
}


-- - Components
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

if vim.g.svim_lsp then
    table.insert(sections.lualine_x, 1, { lsp_server })
    table.insert(sections.lualine_x, 1, {
        'diagnostics',
        symbols = {
            error = 'E ', warn = 'W ', info = 'I ', hint = 'H '
        }
    })
elseif vim.g.svim_coc then
    table.insert(sections.lualine_x, 1, function()
        local str = vim.fn['coc#status']()
        return vim.trim(str)
    end)
end


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

-- - Apply

svim.require('lualine', function(lualine)
    lualine.setup({
        options = options,
        extensions = {
            'aerial', 'neo-tree', 'quickfix', 'toggleterm', 'nvim-tree',
            'fern'
        },
        sections = sections,
        inactive_sections = inactive_sections,
        tabline = tabline
    })
end)
