" gitgutter.vim

if exists('g:vscode') | finish | endif

let g:gitgutter_map_keys = 0

nnoremap ]g <Plug>(GitGutterNextHunk)
nnoremap [g <Plug>(GitGutterPrevHunk)

nnoremap <leader>gs <Plug>(GitGutterStageHunk)
nnoremap <leader>gx <Plug>(GitGutterUndoHunk)
nnoremap <leader>gP <Plug>(GitGutterPreviewHunk)
