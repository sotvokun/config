" bundle/misc.vim - plugins bundle of misc
"


" Section: vim-startuptime
" -----------------------------------------------------------------------------
"
Plug 'dstein64/vim-startuptime'

augroup setup_startuptime
	autocmd!
	autocmd FileType startuptime nnoremap <buffer> q <cmd>q<cr>
augroup END


" Section: ccc.nvim
" -----------------------------------------------------------------------------
" NOTE: setup ccc after lazy loaded
"
Plug 'uga-rosa/ccc.nvim', {'on': ['CccPick', 'CccHighlighterEnable', 'CccHighlighterDisable', 'CccHighlighterToggle']}

augroup lazyload_ccc
	autocmd!
	autocmd User ccc.nvim runtime bundle/plugin/ccc.lua | autocmd! lazyload_ccc
augroup END


" Section: plenary.nvim
" -----------------------------------------------------------------------------
"
Plug 'nvim-lua/plenary.nvim'


" Section: vim-im-select
" -----------------------------------------------------------------------------
"
Plug 'brglng/vim-im-select'
