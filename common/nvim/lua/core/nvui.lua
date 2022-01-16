local nvui = {}

function nvui.animation(b)
    if b == true then
        vim.cmd[[NvuiAnimationsEnabled v:true]]
    else
        vim.cmd[[NvuiAnimationsEnabled v:false]]
    end
end

function nvui.font(fonts, hight)
    local str = ""
    for index, value in ipairs(fonts) do
        if index == 1 then
            str = string.format("%s:h%d", value, hight)
        else
            str = str .. string.format(",%s", value)
        end
    end
    vim.opt.guifont = str
end

return nvui
