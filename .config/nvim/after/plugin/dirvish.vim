if exists('g:vscode') | finish | endif


" Section: Mappings

nnoremap <c-g>d <cmd>Dirvish<cr>


" Section: Settings

" Sort directories, dotfiles, first
" https://github.com/justinmk/vim-dirvish/issues/89#issuecomment-488564543
let g:dirvish_mode = ':sort | sort ,^.*[^/]$, r'


" Section: Autocmd

augroup dirvish_config
    autocmd!

    " - Clear default mappings
    "   TODO: Enable this when dirfloat is ready
    " autocmd FileType dirvish silent! mapclear <buffer>
augroup END
