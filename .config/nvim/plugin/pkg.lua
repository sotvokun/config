-- pkg.lua
--
-- pkg.lua is a minimal "frontend" for neovim plugin managers,
-- it defined a unified DSL to describe plugins version and type.
--
-- SUPPORTS:
--      [paq-nvim](https://github.com/savq/paq-nvim)
--
-- SYNTAX:
--      <URL> [opt] [sync] [branch:xxx] [commit:xxx] [name:xxx]
--
-- ATTRIBUTES:
--      opt
--          installed plugin as optional, you should load it with `packadd`
--      sync
--          plugin should be synchronized with remote
--      branch:xxx
--          install plugin with specified branch
--      commit:xxx
--          install plugin with specified commit
--          (not all plugin managers implemented)
--      name:xxx
--          plugin with be installed with the speicifed name as alias,
--          the default is last part of the URL.
--
-- EXAMPLE:
--      github.com/tpope/vim-fugitive
--      github.com/williamboman/mason.nvim      sync
--
-- USER COMMAND:
--      PkgAdd
--          `:PkgAdd`           packadd all optional packages
--          `:PkgAdd foo`       packadd specified packages by pass package name
--          `:PkgAdd foo bar`   also can add multiple packages
--          `:PkgAdd *`         add all packages with pass the asterisk
--          `:PkgAdd * !foo !bar`
--                              add all packages excluding specified packages
--
-- AUTOCMD:
--      User PkgAddPre:<pkgname>
--      User PkgAddPost:<pkgname>
--          If you use `PkgAdd` usercommand to load optional package, there are
--          two autocmd will be invoked before and after `packadd`. You could
--          use this mechanism to implement lazy loading.
--
--          <pkgname> is transformed from any string to camel-case.
--          The transformation looks like the following pipes:
--          ```
-- pkgname | splitwith(['.', '-', '_']) | map(i -> upperfirst(i)) | join('')
--          ```
--          exmaple:
--              vim-fugitive -> VimFugitive
--              mason.nvim -> MasonNvim
--
-- VARIABLES:
--      g:pkg_manifest
--          The path of the plugin manifest file.
--          (Default: stdpath('config') . '/pkg')
--
--      g:pkg_name_separator
--          The separator to split plugin name to parts.
--          (Default: [',', '-', '_', '.'])
--      g:pkg_manager
--          The package manager that to handle the plugins.
--          (Default: paq)


-- Boostrap

if vim.g.loaded_pkg then return end
vim.g.loaded_pkg = true

local DEFAULT_PATH = vim.fs.normalize(vim.fn.stdpath("config")) .. '/pkg'
local PKG_MANIFEST =
    vim.g.pkg_manifest and vim.g.pkg_manifest or DEFAULT_PATH

local DEFAULT_SEPARATOR = {'%,', '%-', '%_', '%.'} 
local PKG_NAME_SEPARATOR =
        vim.g.pkg_name_separator and vim.g.pkg_name_separator or DEFAULT_SEPARATOR

local DEFAULT_MANAGER = 'paq'
local PKG_MANAGER =
        vim.g.pkg_manager and vim.g.pkg_manager or DEFAULT_MANAGER

local VAR_ATTR = {"branch", "commit", "name"}


-- Functions

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
        remote = "",
        commit = ""
    }

    local name_parts = vim.split(parts[1], "/")
    pkg.name = name_parts[#name_parts]
    pkg.remote = "https://" .. parts[1]

    for _, attr in ipairs({unpack(parts, 2)}) do
        if attr == "opt" then pkg.opt = true 
        elseif attr == "sync" then pkg.sync = true
        else
            for _, var_attr in ipairs(VAR_ATTR) do
                local pattern = string.format("^%s:(.*)$", var_attr)
                local match = string.match(attr, pattern)
                if match then
                    pkg[var_attr] = match
                    goto continue
                end
            end
        end
        ::continue::
    end

    return pkg
end

function parse_manifest()
    if vim.fn.filereadable(PKG_MANIFEST) ~= 1 then
        return {}
    end
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

function transform_pkg_name(name)
    local separators = PKG_NAME_SEPARATOR
    for _, sep in ipairs(separators) do
        name = string.gsub(name, sep, " ")
    end
    local parts = vim.split(name, " ", {plain=true, trimempty=true})
    parts = vim.tbl_map(function(p)
        return string.gsub(p, "^%l", string.upper)
    end, parts)
    return vim.fn.join(parts, "")
end


-- User command

vim.api.nvim_create_user_command("PkgAdd", function(args)
    local doautocmd = vim.api.nvim_exec_autocmds
    local pkgs = parse_manifest()
    local fargs = args.fargs
    local optpkgs = vim.tbl_filter(function(p) return p.opt end, pkgs)
    optpkgs = vim.tbl_map(function(p) return p.name end, optpkgs)

    local proc_pkgs = {}

    function process_fargs()
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

    if #fargs == 0 then
        proc_pkgs = optpkgs
    else
        process_fargs()
    end

    for _, p in ipairs(proc_pkgs) do
        local pkgname = transform_pkg_name(p)
        doautocmd("User", {pattern=string.format("PkgAddPre:%s", pkgname)})
        vim.cmd.packadd(p)
        doautocmd("User", {pattern=string.format("PkgAddPost:%s", pkgname)})
    end
end, {
    desc = "packadd optional packages",
    nargs = "*"
})


-- Providers
local P = {
    paq = function(pkgs)
        local ok, paq = pcall(require, "paq")
        if not ok then
            return
        end

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
    end
}


-- Setup

vim.api.nvim_create_augroup("Pkg", {})
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local provider = P[PKG_MANAGER]
        if type(provider) == 'nil' then
            return
        end
        local pkgs = parse_manifest()
        provider(pkgs)
    end
})

-- vim: expandtab shiftwidth=4 colorcolumn=80
