" bundle/edit.vim - plugins bundle of git
"


" Section: vim-fugitive
" -----------------------------------------------------------------------------
"
Plug 'tpope/vim-fugitive'

nnoremap <leader>gg <cmd>Git<cr>
augroup setup_fugitive
	autocmd!
	autocmd FileType fugitive,fugitiveblame,git
		\ nnoremap <buffer> q <cmd>q<cr>
		\ | set nonumber
augroup END

command! -nargs=0 Gsync execute 'G stash | G pull --rebase | G push | G stash pop'


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
