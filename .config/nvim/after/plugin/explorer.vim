" explorer.vim
"
" - dirvish.vim
" - fern.vim

if exists('g:vscode')
    finish
endif

" Section: Dirvish
" Sub: Settings

" Sort directories, dotfiles, first
" https://github.com/justinmk/vim-dirvish/issues/89#issuecomment-488564543
let g:dirvish_mode = ':sort | sort ,^.*[^/]$, r'


" Sub: Mappings

nnoremap <c-g>d <cmd>Dirvish<cr>


" Sub: Autocmd

augroup dirvish_config
    autocmd!

    " - Clear default mappings
    "   TODO: Enable this when dirfloat is ready
    " autocmd FileType dirvish silent! mapclear <buffer>
augroup END


" Section: Fern
" References:
" - https://github.com/lambdalisue/fern.vim/wiki/Tips#close-fern-after-open
"
" Sub: Settings

let g:fern#renderer#default#root_symbol = '~ '
let g:fern#renderer#default#leaf_symbol = '│ '
let g:fern#renderer#default#leading = '  '
let g:fern#renderer#default#collapsed_symbol = '+ '
let g:fern#renderer#default#expanded_symbol = '- '

let g:fern#disable_default_mappings = 1

" Sub: Mappings

nnoremap <c-g>n <cmd>Fern . -drawer -toggle<cr>
nnoremap <Plug>(fern-close-drawer) <cmd>FernDo close -drawer -stay<cr>
