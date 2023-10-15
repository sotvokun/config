if exists("g:loaded_session")
    finish
endif
let g:loaded_session = 1
let g:session_enabled = 0

let $SESSIONHOME = stdpath('data') . '/session'

function! s:SessionFileName()
    let l:cwd = getcwd()
    if has('win32')
        let l:cwd = substitute(l:cwd, '\:', '', '')
        let l:cwd = substitute(l:cwd, '\\', '/', '')
    endif
    let l:cwd = substitute(l:cwd, '/', '_', 'g')
    return $SESSIONHOME . '/' . l:cwd . '.vim'
endfunction

function! s:SessionSave()
    if !g:session_enabled
        return
    endif
    if !isdirectory($SESSIONHOME)
        call mkdir($SESSIONHOME, 'p')
    endif
    execute 'mksession! ' . s:SessionFileName()
endfunction

function! s:SessionLoad()
    if !g:session_enabled
        return
    endif
    let l:session_file = s:SessionFileName()
    if filereadable(l:session_file)
        execute 'source ' . l:session_file
    endif
endfunction

command Session call s:SessionSave()
command SessionLoad call s:SessionLoad()
command SessionClean call delete(s:SessionFileName())

augroup session#
    au!
    autocmd VimLeavePre * call s:SessionSave()

    " here is why use 'nested'
    " REFERENCE: https://github.com/neovim/neovim/issues/8136
    autocmd VimEnter * nested
        \ if argc() == 0
        \ | let g:session_enabled = 1
        \ | call s:SessionLoad()
        \ | endif
augroup END

" vim: sw=4
