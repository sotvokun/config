if exists('g:loaded_floaterm_after')
    finish
endif
let g:loaded_floaterm_after = 1


" Section: Settings

let g:floaterm_wintype = 'split'
let g:floaterm_height = 0.35

if has('win32')
    let g:floaterm_shell = 'powershell'
endif


" Section: Mappings

nnoremap <c-\> <cmd>execute v:count . 'FloatermToggle'<cr>


" Section: autocmd

augroup terminal#
    au!
    autocmd FileType floaterm setlocal nonumber
    autocmd FileType floaterm call s:setup_mappings()
augroup END


" Section: Functions

function! s:setup_mappings()
    tnoremap <buffer> <c-\> <cmd>execute v:count . 'FloatermToggle'<cr>
    nnoremap <buffer> <c-[> <cmd>FloatermPrev<cr>
    nnoremap <buffer> <c-]> <cmd>FloatermNext<cr>
    nnoremap <buffer> <c-t><space> <cmd>echo g:floaterm#buflist#gather()<cr>
    nnoremap <buffer> <c-t>a <cmd>FloatermNew<cr>
    nnoremap <buffer> <c-t>d <cmd>FloatermKill<cr>
endfunction
