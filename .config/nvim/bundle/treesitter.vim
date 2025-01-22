" bundle/treesitter.vim - plugins bundle of treesitter
"


" Section: nvim-treesitter
" -----------------------------------------------------------------------------
"
Plug 'nvim-treesitter/nvim-treesitter', {'on': []}
augroup lazyload_treesitter
	autocmd!
	autocmd BufRead *
		\ call plug#load('nvim-treesitter')
		\ | autocmd! lazyload_treesitter
augroup END
