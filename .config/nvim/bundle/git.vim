" bundle/edit.vim - plugins bundle of git
"


" Section: vim-fugitive
" -----------------------------------------------------------------------------
"
Plug 'tpope/vim-fugitive'

nnoremap <leader>gg <cmd>Git<cr>
augroup setup_fugitive
	autocmd!
	autocmd FileType fugitive,fugitiveblame
		\ nnoremap <buffer> q <cmd>q<cr>
augroup END


" Section: gv
" -----------------------------------------------------------------------------
"
Plug 'junegunn/gv.vim', {'on': ['GV']}

nnoremap <leader>gv <cmd>GV<cr>


" Section: gitgutter
" -----------------------------------------------------------------------------
"
Plug 'airblade/vim-gitgutter', {'on': []}

let g:gitgutter_map_keys = 0
nnoremap ]g <Plug>(GitGutterNextHunk)
nnoremap [g <Plug>(GitGutterPrevHunk)
nnoremap <leader>gss <Plug>(GitGutterStageHunk)
nnoremap <leader>gsu <Plug>(GitGutterUndoHunk)
nnoremap <leader>gsp <Plug>(GitGutterPreviewHunk)
augroup lazyload_gitgutter
	autocmd!
	autocmd BufReadPre * call plug#load('vim-gitgutter') | autocmd! lazyload_gitgutter
augroup END

