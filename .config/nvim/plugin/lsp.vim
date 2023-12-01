" lsp.vim
"
" A plugin that provides some useful commands and functions for LSP.
"
" FUNCTIONS:
"       LspRegisterClient {opt} Register a LSP client. The options are same as
"                               the `lsp.register()` function in
"                               `lua/lsp.lua`.
"
" COMMANDS:
"       LspStart   {name}           Start a registered LSP client by name.
"       LspStop    {name}           Stop a running LSP client by name.
"       LspRestart {name}           Restart a running LSP client by name.
"
" VARIABLES:
"       g:lsp_disabled_clients  A list of disabled LSP clients. Disabled LSP
"                               clients will not be started.
"       g:lsp_allow_vscode      Allow LSP start when neovim is attached to
"                               vscode. (Defeault: 0 when neovim is
"                               running in vscode)
"
" LUA:
"       If you want to use lua to configure LSP, you can use the `lsp` module.
"       The `lsp` module provides the following functions:
"       - lsp.register(opts)        Register a LSP client.
"       - lsp.start_by_name(name)   Start a registered LSP client by name.
"       - lsp.stop_by_name(name)    Stop a running LSP client by name.
"       - lsp.restart_by_name(name) Restart a running LSP client by name.
"       - lsp.stop_all()            Stop all running LSP clients.
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

if !exists('g:lsp_disabled_clients')
    let g:lsp_disabled_clients = []
endif

let g:lsp_allow_vscode = 0

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
    call v:lua.require'lsp'.register(a:opts)
endfunction


" Section: Private functions

function! s:start_client_by_name(name)
    if exists('g:vscode') && g:lsp_allow_vscode == 0
        return
    endif
    if index(g:lsp_disabled_clients, a:name) >= 0
        return
    endif
    call v:lua.require'lsp'.start_by_name(a:name)
endfunction

function! s:start_client_by_ft(filetype)
    if exists('g:vscode') && g:lsp_allow_vscode == 0
        return
    endif
    let l:matched_clients =
        \ v:lua.require'lsp'.util.get_registered_by_filetype(a:filetype)
    for l:client in l:matched_clients
        let name = get(l:client, 'name')
        if index(g:lsp_disabled_clients, name) >= 0
            continue
        endif
        call v:lua.require'lsp'.start_by_name(name)
    endfor
endfunction

function! s:stop_client_by_name(...)
    if exists('g:vscode') && g:lsp_allow_vscode == 0
        return
    endif
    if len(a:000) == 0
        call v:lua.require'lsp'.stop_all()
    else
        call v:lua.require'lsp'.stop_by_name(a:000[0])
    endif
endfunction

function! s:restart_client_by_name(name)
    call v:lua.require'lsp'.restart_by_name(a:name)
endfunction

" vim: et sw=4 cc=80
