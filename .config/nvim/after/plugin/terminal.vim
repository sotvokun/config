" terminal.vim
"
" - vim-floaterm

if exists('g:vscode')
    finish
endif

let g:floaterm_wintype = 'split'
let g:floaterm_height = 0.3

nnoremap <c-\> <cmd>execute v:count . 'FloatermToggle'<cr>

augroup terminal#
    au!
    autocmd FileType floaterm
            \ setlocal nonumber
            \ | tnoremap <buffer> <c-\> <cmd>execute v:count . 'FloatermToggle'<cr>
            \ | nnoremap <buffer> <c-[> <cmd>FloatermPrev<cr>
            \ | nnoremap <buffer> <c-]> <cmd>FloatermNext<cr>
            \ | nnoremap <buffer> <space> <cmd>echo g:floaterm#buflist#gather()<cr>
            \ | nnoremap <buffer> <c-n> <cmd>FloatermNew<cr>
            \ | nnoremap <buffer> <c-x> <cmd>FloatermKill<cr>
augroup END

" vim: et sw=4
