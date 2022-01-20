local util = require('util')

local packer_path =
    vim.fn.stdpath('data').."/site/pack/packer/start/packer.nvim"

local init_file_path =
    vim.fn.stdpath('config').."/_general_init_"

local core = {}

function core.setup(opt)
    --[[GENERAL_MODE::BEGIN]]
    if vim.fn.isdirectory(packer_path) == 0 then
       if vim.fn.filereadable(init_file_path) == 0 then
            util.create_file(init_file_path,
                "DELETE THIS FILE TO DISPLAY MESSAGE AGAIN")

            util.echo("INFO", "packer installed folder does not exist")
            util.echo("INFO",
                "to enable the plugins please install packer manually")
            util.echo("INFO",
                "please read https://github.com/wbthomason/packer.nvim")
        end
        return
    end
    --[[GENERAL_MODE::END]]


    --[[PLUGIN_MODE::BEGIN]]
    if vim.fn.isdirectory(packer_path) == 1 and
        vim.fn.filereadable(init_file_path) == 1 then
        util.remove_file(init_file_path)
    end

    -- Terminal
    -- -- set shell
    if opt.shell then
        --[==[
        if opt.shell == 'powershell' or opt.shell == 'pwsh' then
            vim.cmd[[let &shell = has('win32') ? 'powershell' : 'pwsh']]
            vim.cmd[[let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;']]
		    vim.cmd[[let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode']]
		    vim.cmd[[let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode']]
		    vim.cmd[[set shellquote= shellxquote=]]
        end
        --]==]
    end


    -- Plugins
    -- -- load plugins
    local plugins = require('plugins')
    -- -- setup plugins
    for _, v in ipairs(plugins) do
        if v.setup then
            v.setup()
        end
    end


    -- Theme
    -- -- light background [REF:'bg']
    do
        local hr = tonumber(vim.fn.strftime("%H"))

        if not opt.lightmode then
            opt.lightmode = {}
            opt.lightmode.start = 7
            opt.lightmode.stop = 17
        end

        opt.lightmode.start = opt.lightmode.start or 7
        opt.lightmode.stop = opt.lightmode.stop or 17

        if hr >= opt.lightmode.start and hr < opt.lightmode.stop then
            vim.opt.background='light'
        else
            vim.opt.background='dark'
        end
    end

    -- -- apply theme
    vim.opt.termguicolors = true
    if not opt.theme then
        opt.theme = "zenwritten"
    end
    vim.cmd("colorscheme "..opt.theme)


    -- Keymapping
    -- load keymapping list
    local keymaps = require('keymaps')
    -- register keymap
    for _, v in ipairs(keymaps) do
        local map = {
            [v[1]] = {v[2], v[3]}
        }
        local opts = {
            mode = v.mode or "n",
            prefix = v.prefix or "",
            buffer = v.buffer or nil,
            silent = v.silent or true,
            noremap = v.noremap or true,
            nowait = v.nowait or false
        }
        require('which-key').register(map, opts)
    end

    --[[PLUGIN_MODE::END]]
end

return core
