if exists('g:loaded_gitgutter_after')
	finish
endif
let g:loaded_gitgutter_after = 1


" Section: Settings

let g:gitgutter_map_keys = 0


" Section: Mappings

nnoremap ]g <Plug>(GitGutterNextHunk)
nnoremap [g <Plug>(GitGutterPrevHunk)

nnoremap <leader>gs <Plug>(GitGutterStageHunk)
nnoremap <leader>gx <Plug>(GitGutterUndoHunk)
nnoremap <leader>gP <Plug>(GitGutterPreviewHunk)
