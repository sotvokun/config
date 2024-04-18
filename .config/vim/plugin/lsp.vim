" lsp.vim
"
" A plugin that provides some useful commands and functions for LSP.
"
" FUNCTIONS:
"       LspRegister       {opt} Register a LSP client. The options are same as
"                               the `lsp.register()` function in
"                               `lua/lsp.lua`.
"
" VARIABLES:
"       g:lsp_engine            Which LSP engine to use.
"                               (VALUE: 'nvim', 'coc', 'vscode')
"                               (DEFAULT: 'nvim' for neovim, 'coc' for vim,
"                               'vscode' for vscode)
"       g:lsp_disabled_clients  A list of disabled LSP clients. Disabled LSP
"                               clients will not be started.
"
" COMMANDS:
"       LspStart   {name}           Start a registered LSP client by name.
"       LspStop    {name}           Stop a running LSP client by name.
"       LspRestart {name}           Restart a running LSP client by name.
"
" LUA:
"       If you want to use lua to configure LSP, you can use the `lsp` module.
"       The `lsp` module provides the following functions:
"       - lsp.register(opts)        Register a LSP client.
"       - lsp.start_by_name(name)   Start a registered LSP client by name.
"                                   (ONLY WORKS IN NEOVIM)
"       - lsp.stop_by_name(name)    Stop a running LSP client by name.
"                                   (ONLY WORKS IN NEOVIM)
"       - lsp.restart_by_name(name) Restart a running LSP client by name.
"                                   (ONLY WORKS IN NEOVIM)
"       - lsp.stop_all()            Stop all running LSP clients.
"                                   (ONLY WORKS IN NEOVIM)
"
"       The `lsp` module also provides the following variables:
"       - lsp.registered            A dictionary of registered LSP clients.
"
"       About the parameters of the functions, please see the `lsp.lua` file.


" Section: Setup

if exists('g:loaded_lsp')
    finish
endif
let g:loaded_lsp = 1


" Section: Variables
"    Part: g:lsp_engine
if exists('g:vscode')
    let g:lsp_engine = 'vscode'
elseif has('nvim')
    let g:lsp_engine = 'nvim'
else
    let g:lsp_engine = 'coc'
endif

let g:lsp_disabled_clients = get(g:, 'lsp_disabled_clients', [])


" Section: Autocmd

augroup Lsp
    au!
    autocmd FileType * call s:start_client_by_ft(expand('<amatch>'))
augroup END


" Section: Commands

command!
    \ -nargs=1
    \ -complete=customlist,v:lua.require'lsp'.util.registered_names
    \ LspStart call s:start_client_by_name(<f-args>)

command!
    \ -nargs=?
    \ -complete=customlist,v:lua.require'lsp'.util.started_names
    \ LspStop call s:stop_client_by_name(<f-args>)

command!
    \ -nargs=1
    \ -complete=customlist,v:lua.require'lsp'.util.started_names
    \ LspRestart call s:restart_client_by_name(<f-args>)


" Section: Functions

function! LspRegister(opts)
    if g:lsp_engine == 'vscode'
        return
    endif
    if g:lsp_engine == 'nvim'
        if index(v:lua.require'lsp'.util.started_names(), a:opts['name']) >= 0
            return
        endif
        if index(v:lua.require'lsp'.util.registered_names(), a:opts['name']) < 0
            call v:lua.require'lsp'.register(a:opts)
        endif
        call s:start_client_by_name(a:opts['name'])
        return
    endif
    if g:lsp_engine == 'coc'
        if index(v:lua.require'lsp'.util.started_names(), a:opts['name']) >= 0
            return
        endif
        if index(v:lua.require'lsp'.util.registered_names(), a:opts['name']) < 0
            call v:lua.require'lsp'.register(a:opts)
        endif
        let l:client = v:lua.require'lsp'.util.coc_serialize(a:opts['name'])
        call coc#config('languageserver.'.a:opts['name'], l:client)
        return
    endif
endfunction


" Section: Private functions

function! s:start_client_by_name(name)
    if g:lsp_engine == 'vscode'
        return
    endif
    if g:lsp_engine == 'nvim'
        if index(g:lsp_disabled_clients, a:name) >= 0
            return
        endif
        call v:lua.require'lsp'.start_by_name(a:name)
        return
    endif
endfunction

function! s:start_client_by_ft(filetype)
    if g:lsp_engine == 'vscode'
        return
    endif
    if g:lsp_engine == 'nvim'
        let l:matched_clients =
            \ v:lua.require'lsp'.util.get_registered_by_filetype(a:filetype)
        for l:client in l:matched_clients
            let name = get(l:client, 'name')
            if index(g:lsp_disabled_clients, name) >= 0
                continue
            endif
            call v:lua.require'lsp'.start_by_name(name)
        endfor
        return
    endif
endfunction

function! s:stop_client_by_name(...)
    if g:lsp_engine == 'vscode'
        return
    endif
    if g:lsp_engine == 'nvim'
        if len(a:000) == 0
            call v:lua.require'lsp'.stop_all()
        else
            call v:lua.require'lsp'.stop_by_name(a:000[0])
        endif
        return
    endif
endfunction

function! s:restart_client_by_name(name)
    if g:lsp_engine == 'vscode'
        return
    endif
    if g:lsp_engine == 'nvim'
        call v:lua.require'lsp'.restart_by_name(a:name)
        return
    endif
endfunction

" vim: et sw=4 cc=80
