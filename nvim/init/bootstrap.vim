"===========================================================
"
" Svim Bootstrap - Enable full feature version
"
" Created: 2022-11-22
" Modified: 2022-11-24
"
"===========================================================

" Tinymode detection
" -----------------------------
if exists('g:svim_tinymode') && g:svim_tinymode
    finish
endif


" Bootstrap
" -----------------------------
function! s:ensure_install(user, repo, opt = 0) abort
    let l:github_repo = printf('https://github.com/%s/%s', a:user, a:repo)
    let l:path = printf('%s/%s/%s', g:svim_plugman_path, a:opt ? 'opt' : 'start', a:repo)
    let l:doc_path = l:path . '/doc'
    call system(['git', 'clone', '--depth', '1', l:github_repo, l:path])
    if isdirectory(l:doc_path)
        execute(printf('helptags %s', l:doc_path))
    endif
endfunction

if !g:svim_has_plugman
    let s:plugman_install_prompt = 'Install basic plugins [Y/n]: '
    let s:do_plugman_install = input(s:plugman_install_prompt, 'n')
    if s:do_plugman_install == 'n'
        call writefile([], g:svim_tinymode_token)
        finish
    endif
    call s:ensure_install('savq', 'paq-nvim')
    call s:ensure_install('lewis6991', 'impatient.nvim')
endif

" Require Lua module
" -----------------------------
RequireSource lua/svim/init.lua
