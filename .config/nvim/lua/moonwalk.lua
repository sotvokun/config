-- moonwalk.lua - a fennel wrapper to make neovim support fennel language
-- REFERENCE: https://github.com/gpanders/nvim-moonwalk
-- REFERENCE: https://github.com/gpanders/dotfiles/blob/master/.config/nvim/lua/moonwalk.lua

local CONFIG_PATH = vim.fs.normalize(vim.fn.stdpath("config"))
local DATA_PATH = vim.fs.normalize(vim.fn.stdpath("data"))
local STATE_PATH = vim.fs.normalize(vim.fn.stdpath("state"))
local STATE_MARKER = STATE_PATH .. "/moonwalk"

local DEFAULT_SUBDIRS = function ()
    return {
        "plugin",
        "indent",
        "ftplugin",
        "colors"
    }
end

-- Functions --------------------------------------------------------------------------------------

local events = {}

--- Register event
-- @param name  the name of event
-- @param callback      the event procedure
--
-- support events:
--   pre-compile        string -> string
--   post-compile       string -> string
--   ignore-path        nil -> string[]
local function on(name, callback)
    events[vim.fn.tolower(name)] = callback
end

--- Compile a fennel file content to lua
-- @param path  fennel file path
-- @param out   the output lua file path [default: stdpath('data')/site]
-- @return      the lua file path
local function compile(path, out)
    local ok, fennel = pcall(require, "fennel")
    if not ok then
        error("[moonwalk.lua] no 'fennel' can be required; " .. fennel)
    end

    path = vim.fs.normalize(path)

    local base = string.gsub(
        path, 
        vim.fs.normalize(CONFIG_PATH) .. "/", 
        ""
    )

    if events["ignore-path"] then
        for _, v in ipairs(events["ignore-path"]()) do
            if base == v then
                return
            end
        end
    end

    local src = (function()
        local f = assert(io.open(path))
        local content = f:read("*a")
        f:close()
        return content or nil
    end)()

    if not src then
        return
    end

    local macro_path = fennel["macro-path"]
    fennel["macro-path"] = macro_path .. ";" .. vim.fs.normalize(CONFIG_PATH) .. "/fnl/?.fnl"
    if events["pre-compile"] then
        src = events["pre-compile"](src)
    end
    local compiled = fennel.compileString(src, { filename = path })
    if events["post-compile"] then
        compiled = events["post-compile"](compiled)
    end
    fennel["macro-path"] = macro_path

    if not out then
        out = DATA_PATH .. "/site/" .. base:gsub("^fnl/", "lua/"):gsub("%.fnl$", ".lua")
    end
    vim.fn.mkdir(vim.fn.fnamemodify(out, ":h"), "p")

    local f = assert(io.open(out, "w"))
    f:write(compiled)
    f:close()

    return out
end

--- Apply a function to all files and its path in a directory and its children
-- @param dir   the directory
-- @param ext   the extension name
-- @param f     the function
local function walk(dir, ext, f)
    local subdirs = vim.list_extend(DEFAULT_SUBDIRS(), {ext})
    local pred = function(name)
        return string.match(name, string.format(".*%%.%s", ext))
    end
    for _, path in ipairs({ dir, dir .. "/after" }) do
        for _, subpath in ipairs(subdirs) do
            local files = vim.fs.find(pred, {
                limit = math.huge,
                path = vim.fs.normalize(path .. "/" .. subpath)
            })
            for _, v in ipairs(files) do
                f(v)
            end
        end
    end
end

local function clear()
    walk(DATA_PATH .. "/site", "lua", function(path)
        os.remove(path)
    end)
end

--- Compile fennels to lua
local function moonwalk()
    vim.loader.disable()

    clear()

    walk(CONFIG_PATH, "fnl", compile)

    local f = assert(io.open(STATE_MARKER, "w"))
    f:write("")
    f:close()

    -- Reset runtimepath cache so new Lua files are discovered
    vim.o.runtimepath = vim.o.runtimepath

    vim.schedule(vim.loader.enable)
end

local function moonwalk_clean()
    vim.loader.disable()
    clear()
    vim.schedule(vim.loader.enable)
end


-- Usercommand ------------------------------------------------------------------------------------

vim.api.nvim_create_user_command("Moonwalk", moonwalk, {
    desc = "Compile all fennel files to lua"
})

vim.api.nvim_create_user_command("MoonwalkClean", moonwalk_clean, {
    desc = "Clean all compiled lua files"
})


-- Export ------------------------------------------------------------------------------------------

local function setup()
    -- TODO Remove this compatible statement when neovim 0.10.0 release
    local uv = vim.uv or vim.loop
    if not uv.fs_stat(STATE_MARKER) then
        moonwalk()
    end
end

return {
    compile = compile,
    walk = walk,
    moonwalk = moonwalk,
    setup = setup,
    on = on
}
