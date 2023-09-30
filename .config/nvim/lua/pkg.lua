-- Guard -------------------------------
if pcall(debug.getlocal, 4, 1) then
    print('[pkg.lua] pkg.lua is only for execution')
end


-- Def_initions -------------------------
local pkg_home = vim.fn.stdpath('data') .. '/site/pack/pkg'


-- Packages ----------------------------
local packages = [[

# Core

github.com/kylechui/nvim-surround
github.com/jiangmiao/auto-pairs
github.com/dcampos/nvim-snippy
github.com/tpope/vim-fugitive
github.com/ggandor/leap.nvim
github.com/tpope/vim-abolish
github.com/tpope/vim-commentary
github.com/suy/vim-context-commentstring
github.com/gpanders/nvim-parinfer
github.com/tommcdo/vim-lion

# Language Support
github.com/sotvokun/fennel.vim

# Enhanced
github.com/vijaymarupudi/nvim-fzf
github.com/stevearc/oil.nvim

github.com/anuvyklack/hydra.nvim

# LSP

# github.com/neovim/nvim-lspconfig                opt sync
# github.com/williamboman/mason.nvim              opt sync
# github.com/williamboman/mason-lspconfig.nvim    opt sync
# github.com/hrsh7th/cmp-nvim-lsp                 opt sync

# Completion

# github.com/hrsh7th/nvim-cmp        opt
# github.com/hrsh7th/cmp-buffer      opt
# github.com/hrsh7th/cmp-path        opt
# github.com/dcampos/cmp-snippy      opt

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
        if #line == 0 or line:sub(1,1) == '#' then
	        goto continue
        end
        local parts = vim.split(line, '%s', split_opt)
        local pkg = {}
        -- name
        local name_parts = vim.split(parts[1], '/')
        pkg['name'] = name_parts[#name_parts]
        -- attribute
        for _, attr in ipairs({unpack(parts, 2)}) do
            if #attr ~= 0 then
                pkg[attr] = true
            end
        end
        -- location
        pkg['remote'] = parts[1]
        pkg['local'] = 
            pkg_home .. 
            (pkg['opt'] and '/opt/' or '/start/') .. 
            pkg['name']
        -- installed
        local isdir = vim.fn.isdirectory
        pkg['installed'] = isdir(pkg['local']) == 1
        --
        table.insert(result, pkg)
        ::continue::
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
        path_ = string.gsub(path, '/', '\\')
        local cmd = string.format('rmdir /S /Q "%s"', path_)
        vim.print(vim.fn.system(cmd))
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
        local p_doc = p['local'] .. '/doc'
        if isdir(p_doc) == 1 then
            vim.cmd('helptags ' .. p_doc)
        end
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

function list_()
    local str = ''
    str = string.format('%-10s %5s %20s', 'STATUS', 'TYPE', 'NAME') .. '\n'
    str = str .. '--------------------------------------\n'

    for index, p in ipairs(_parse()) do
        local msg = string.format(
            '%-10s %5s %20s',
            (p['installed'] and '[I]' or '[ ]'),
            (p['opt'] and 'opt' or 'start'),
            p['name']
        )
        str = str .. msg .. '\n'
    end
    print(str)
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
    list_()
end

if arg[1] == 'sync' then
    sync()
end

if arg[1] == 'clean' then
    clean()
end
