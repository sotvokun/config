-- Guard -------------------------------
if pcall(debug.getlocal, 4, 1) then
    print('[pkg.lua] pkg.lua is only for execution')
end


-- Def_initions -------------------------
local pkg_home = vim.fn.stdpath('data') .. '/site/pack/pkg'


-- Packages ----------------------------
local packages = [[

github.com/machakann/vim-sandwich
github.com/jiangmiao/auto-pairs
github.com/dcampos/nvim-snippy
github.com/justinmk/vim-sneak
github.com/tpope/vim-fugitive
github.com/tpope/vim-abolish
github.com/tpope/vim-commentary
github.com/gpanders/nvim-parinfer

github.com/mfussenegger/nvim-lsp-compl opt
github.com/neovim/nvim-lspconfig opt

]]


-- Functions ---------------------------
function _init()
    local isdir = vim.fn.isdirectory
    local opt_dir = pkg_home .. '/opt'
    local start_dir = pkg_home .. '/start'
    if isdir(pkg_home) ~= 1 then
        vim.fn.mkdir(pkg_home, 'p')
    end
    if isdir(opt_dir) ~= 1 then
        vim.fn.mkdir(pkg_home .. '/opt', 'p')
    end
    if isdir(start_dir) ~= 1 then
        vim.fn.mkdir(pkg_home .. '/start', 'p')
    end
    return {
        opt = opt_dir,
        start = start_dir
    }
end

function _parse()
    local result = {}
    local split_opt = {trimempty=true}
    local pkgstr = vim.trim(packages)
    for index, line in ipairs(vim.split(pkgstr, '\n', split_opt)) do
        local parts = vim.split(line, '%s', split_opt)
        local pkg = {}
        -- name
        local name_parts = vim.split(parts[1], '/')
        pkg['name'] = name_parts[#name_parts]
        -- attribute
        for _, attr in ipairs({unpack(parts, 2)}) do
            pkg[attr] = true
        end
        -- location
        pkg['remote'] = parts[1]
        pkg['local'] = 
            pkg_home .. 
            (pkg['opt'] and '/opt/' or '/start/') .. 
            pkg['name']
        table.insert(result, pkg)
    end
    return result
end

function _packages_filter()
    local pkgs = _parse()
    local result = {
        opt = {},
        start = {}
    }
    for index, p in ipairs(pkgs) do
        if p['opt'] then
            table.insert(result.opt, p)
        else
            table.insert(result.start, p)
        end
    end
    return result
end

function _has_pkg(name, type_)
    local pkgs = _packages_filter()
    local f_result = vim.tbl_filter(function(u)
        return u['name'] == name
    end, pkgs[type_])
    return not vim.tbl_isempty(f_result)
end

function _git_clone(remote, path)
    remote = 'https://' .. remote
    vim.print(vim.fn.system({
        'git', 'clone', '--depth=1', remote, path
    }))
end

function _git_pull(path)
    vim.print(vim.fn.system({
        'git', '-C', path, 'pull'
    }))
end

function _rmdir(path)
    if vim.fn.has('win32') == 0 then
        vim.print(vim.fn.system({
            'rm', '-rf', path
        }))
    else
        vim.print(vim.fn.system({
            'rmdir', path, '/s', '/q'
        }))
    end
end

function sync()
    local isdir = vim.fn.isdirectory
    local readdir = vim.fn.readdir
    local pkgs = _parse()

    for index, p in ipairs(pkgs) do
        if isdir(p['local']) ~= 1 then
            _git_clone(p['remote'], p['local'])
            goto continue
        end
        if p['sync'] then
            _git_pull(p['local'])
            goto continue
        end
        ::continue::
    end
end

function clean()
    local readdir = vim.fn.readdir
    local dir = _init()

    -- start
    for index, d in ipairs(readdir(dir.start)) do
        if not _has_pkg(d, 'start') then
            _rmdir(dir.start .. '/' .. d)
        end
    end
    -- opt
    for index, d in ipairs(readdir(dir.opt)) do
        if not _has_pkg(d, 'opt') then
            _rmdir(dir.opt .. '/' .. d)
        end
    end
end

function help()
    print [[
usage:
    pkg.lua <command>

commands:
    list    print all packages
    sync    install and update packages (only for sync mark)
    clean   delete packages
    help    print this message
]]
end


-- Main --------------------------------
if #arg == 0 or arg[1] == 'help' then
    help()
    os.exit()
end

if arg[1] == 'list' then
    vim.print(_parse())
end

if arg[1] == 'sync' then
    sync()
end

if arg[1] == 'clean' then
    clean()
end
