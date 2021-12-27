--[[
{
    [1]:string          -- profile file path in repo
    [2]:string          -- [alternative] target path to all platform, empty means do not deploy it
    [2]:{ win:string, unix:string }
    -- [alternative] target path for specified platform
    -- [^] if table is empty, it means do not deploy it
    -- [^] if there has one of win or unix, it means only for the specified os

    folder:boolean      -- [default:false, optional]
    copy:boolean        -- [default:false, optional]
    ignore:boolean      -- [default:false, optional]
}
--]]
local deploy_list = {
    -- powershell profile
    {
        'windows/Microsoft.PowerShell_profile.ps1',
        {
            win = '~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1',
            unix = '~/.config/powershell/Microsoft.PowerShell_profile.ps1'
        },
        copy=true
    },
    -- windows terminal
    {
        'windows/terminal.json',
        {win = '~/AppData/Local/Microsoft/Windows Terminal/settings.json'},
        copy=true
    },
    -- [[vscode::begin]]
    {
        'common/vscode_settings.json',
        {
            win = '~/AppData/Roaming/Code/User/settings.json',
            unix = '~/.config/Code/User/settings.json'
        },
        copy=true, ignore=true
    },
    {
        'common/vscode_keybindings.json',
        {
            win = '~/AppData/Roaming/Code/User/keybindings.json',
            unix = '~/.config/Code/User/keybindings.json'
        },
        copy=true, ignore=true
    },
    -- [[vscode::end]]
    -- bashrc
    {'unix/.bashrc', {unix='~/.bashrc'}, copy=true},
}
--[[-------------------------------------------------------------------------------------------[[--
  _____             _               _
 |  __ \           | |             | |
 | |  | | ___ _ __ | | ___  _   _  | |_   _  __ _
 | |  | |/ _ \ '_ \| |/ _ \| | | | | | | | |/ _` |
 | |__| |  __/ |_) | | (_) | |_| |_| | |_| | (_| |
 |_____/ \___| .__/|_|\___/ \__, (_)_|\__,_|\__,_|
             | |             __/ |
             |_|            |___/
--[[-------------------------------------------------------------------------------------------]]--
-- Exit deploy program if lua version is lower than 5.2 or is LuaJIT
if tonumber(_VERSION:sub(#_VERSION, #_VERSION)) < 2 or _VERSION == "LuaJIT" then
    print("! Lua VERSION NUMBER MUST GREATER THAN 5.2 !")
    return
end

-- Get the name of current os
-- @return 'win' for Microsoft Windows, 'unix' for all others
local function os_name()
    if package.config:sub(1,1) == '\\' then
        return 'win'
    else
        return 'unix'
    end
end

-- Generate copy command for current os
-- @param f string the original path
-- @param t string the destination of path
-- @return string
local function os_copy(f, t)
    if os_name() == 'win' then
        return
            string.format(
                "powershell copy-item (resolve-path '%s').Path '%s' -recurse -force", f, t)
    else
        return string.format("cp -r -f $(realpath %s) %s", f, t)
    end
end

-- Generate link command for current os
-- @param f string the original path
-- @param t string the destination of path
-- @param folder boolean link as folder (only for win)
-- @return string
local function os_link(f, t, folder)
    local result = ""
    if os_name() == 'win' then
        result = "powershell new-item -force "
        if folder and folder==true then
            result = result .. "-type Junction "
        else
            result = result .. "-type SymbolicLink "
        end
        result = result .. string.format("-path '%s' -value (resolve-path '%s').path ", t, f)
        return result
    else
        result = string.format("ln -sf $(realpath %s) %s", f, t)
        return result
    end
end

-- Main Processing
local current_os_total = 0
local deployed_copy_cnt = 0
local deployed_link_cnt = 0
local invalid_cnt = 0
for _, value in ipairs(deploy_list) do
    local f = value[1]
    if not f then
        invalid_cnt = invalid_cnt + 1
        goto continue
    end

    local t = value[2]
    if (not t) or (type(t) ~="string" and type(t) ~= "table") then
        goto continue
    end
    if t and type(t) == "table" then
        if next(t) == nil then
            goto continue
        else
            t = t[os_name()]
            if t == nil then
                goto continue
            end
            current_os_total = current_os_total + 1
        end
    end

    if t and type(t) == "string" and #t == 0 then
        goto continue
    end

    if value.ignore then
        goto continue
    end

    if value.copy then
        os.execute(os_copy(f, t))
        deployed_copy_cnt = deployed_copy_cnt + 1
        goto continue
    else
        os.execute(os_link(f, t))
        deployed_link_cnt = deployed_link_cnt + 1
        goto continue
    end

    ::continue::
end
print(string.format("Profiles:%d\n  Deployed:%d\n   by copy:%d\n   by link:%d",
                    current_os_total,
                    deployed_copy_cnt + deployed_link_cnt,
                    deployed_copy_cnt,
                    deployed_link_cnt))
print(string.format("Invalid profiles:%d", invalid_cnt))
