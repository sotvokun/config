-- paq.lua
-- Variables --------------------------------------------------------------------------------------

local CONFIG_PATH = vim.fs.normalize(vim.fn.stdpath("config"))
local PKG_MANIFEST = CONFIG_PATH .. "/pkg"


-- Functions --------------------------------------------------------------------------------------

function parse_line(str)
    str = vim.trim(str)
    if string.sub(str, 1, 1) == "#" or #str == 0 then
        return nil
    end
    local parts = vim.split(str, "%s", {trimempty=true})
    local pkg = {
        name = "",
        opt = false,
        sync = false,
        branch = "",
        remote = ""
    }

    local name_parts = vim.split(parts[1], "/")
    pkg.name = name_parts[#name_parts]
    pkg.remote = "https://" .. parts[1]

    for _, attr in ipairs({unpack(parts, 2)}) do
        if attr == "opt" then pkg.opt = true 
        elseif attr == "sync" then pkg.sync = true
        else
            local match = string.match(attr, "^branch:(.*)$")
            if match then pkg.branch = match end
        end
    end

    return pkg
end

function parse_manifest()
    local lines = vim.fn.readfile(PKG_MANIFEST)
    local pkgs = {}
    for _, v in ipairs(lines) do
        local pkg = parse_line(v)
        if pkg == nil then
            goto continue
        end
        table.insert(pkgs, pkg)
        ::continue::
    end
    return pkgs
end


-- Setup ------------------------------------------------------------------------------------------

local ok, paq = pcall(require, "paq")
if not ok then
    return
end

local pkgs = parse_manifest()
local paq_requires = vim.tbl_map(function(p)
    local ret = {
        name = p.name,
        opt = p.opt,
        pin = (not p.sync),
        url = p.remote
    }
    if p.branch ~= "" then
        ret.branch = p.branch
    end
    return ret
end, pkgs)
paq(paq_requires)


-- User command -----------------------------------------------------------------------------------

-- [[
--      :PaqPackAdd
--      -nargs=*
--
--      packadd all optional packages if no argument passed in. `:PaqPackAdd`
--      add specified packages by pass package names.           `:PaqPackAdd foobar`
--      also can add multiple packages.                         `:PaqPackAdd foo bar zak`
--      to add all packages, you can pass the asterisk.         `:PaqPackAdd *`
--      to avoid some package you specified, put a attention mark before package name.
--      EXAMPLE: packadd all packages exclude 'foo' and 'bar'.  `:PaqPackAdd * !foo !bar`
-- ]]
vim.api.nvim_create_user_command("PaqPackAdd", function(args)
    local fargs = args.fargs
    local optpkgs = vim.tbl_filter(function(p) 
        return p.opt
    end, pkgs)
    optpkgs = vim.tbl_map(function(p) return p.name end, optpkgs)

    local proc_pkgs = {}

    if #fargs == 0 then
        proc_pkgs = optpkgs
    else
        for _, pkg in ipairs(fargs) do
            if pkg == "*" then
                proc_pkgs = vim.list_extend(proc_pkgs, optpkgs)
            elseif pkg:sub(1,1) == "!" then
                proc_pkgs = vim.tbl_filter(function (p)
                    return p ~= pkg:sub(2)
                end, proc_pkgs)
            else
                table.insert(proc_pkgs, pkg)
            end
        end
    end

    for _, p in ipairs(proc_pkgs) do
        vim.cmd(string.format("packadd %s", p))
    end
end, {
    desc = "packadd optional packages",
    nargs = "*"
})
