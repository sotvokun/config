" config.vim
"
" This file contains some configuration options for some plugin that need to
" be set before they are loaded.

" Plugin: vim-sneak

let g:sneak#label = 1

nnoremap f <Plug>Sneak_f
nnoremap F <Plug>Sneak_F
nnoremap t <Plug>Sneak_t
nnoremap T <Plug>Sneak_T


" Plugin: AutoPairs

let g:AutoPairsCompatibleMaps = 1
let g:AutoPairsShortcutToggleMultilineClose = ''
let g:AutoPairsShortcutIgnore = ''
let g:AutoPairsMoveExpression = ''
