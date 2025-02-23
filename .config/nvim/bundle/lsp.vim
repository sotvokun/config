" bundle/lsp.vim - plugins bundle of lsp
"

" Section: fidget.nvim
" -----------------------------------------------------------------------------
"
Plug 'j-hui/fidget.nvim', {'on': []}
augroup lazyload_fidget
	autocmd!
	autocmd BufReadPre *
		\ call plug#load('fidget.nvim')
		\ | call v:lua.require'fidget'.setup()
		\ | autocmd! lazyload_fidget
augroup END
