if exists('g:loaded_dirvish_after')
	finish
endif
let g:loaded_dirvish_after = 1


" Section: Fix the special initialization order to remove netrw handler

autocmd! FileExplorer *


" Section: Mappings

nnoremap <c-g>d <cmd>Dirvish<cr>


" Section: Settings

" Sort directories, dotfiles, first
" https://github.com/justinmk/vim-dirvish/issues/89#issuecomment-488564543
let g:dirvish_mode = ':sort | sort ,^.*[^/\\]$, r'
