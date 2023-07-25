" Configuration

let g:fern#renderer#default#leaf_symbol = ' '
let g:fern#renderer#default#collapsed_symbol = '+ '
let g:fern#renderer#default#expanded_symbol = '- '
let g:fern#hide_cursor = 1

" Keymap

nnoremap <c-n> <cmd>Fern . -drawer -toggle<cr>

augroup FernFileType
    au!
    autocmd FileType fern
            \ set nonumber | 
            \ nnoremap <c-l> <c-w>l |
            \ nnoremap <c-n> <cmd>Fern . -drawer -toggle<cr> |
            \ nnoremap <c-r> <Plug>(fern-action-redraw)
augroup END
