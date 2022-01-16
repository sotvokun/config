require('lualine').setup {
    options = {
        section_separators = "",
        component_separators = "",
    },
    sections = {
        lualine_x = {
            {
                'fileformat',
                symbols = { unix = "LF", dos = "CRLF", mac = "CR" },
            },
            {'filetype'},
            {'encoding'}
        },
        lualine_y = {{'location'}},
        lualine_z = {{'progress'}}
    }
}
