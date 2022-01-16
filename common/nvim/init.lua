-- General Options
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.expandtab = true

vim.opt.ignorecase = true
--[[
setup {
    theme = "zenwritten"    -- [default]
    lightmode = {           -- switch 'background' to light during the time span
        start = 7           -- [default]
        stop = 17           -- [default]
    },
    font = {
        default = "",       -- [default]
        fallback = {},      -- fallback font list
        hight = 12,         -- [default]
    },
    shell = ""              -- [default]
}
--]]
require("core").setup{
    shell = "powershell"
}

if vim.g.nvui then
    local nvui = require("core/nvui")
    nvui.animation(false)
    nvui.font({"Iosevka Pragmatus", "Source Han Sans HW"}, 12)
end
