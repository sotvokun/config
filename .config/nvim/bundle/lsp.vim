" bundle/lsp.vim - plugins bundle of lsp
"


" Section: mason.nvim
" -----------------------------------------------------------------------------
"
Plug 'williamboman/mason.nvim', {'on': []}
augroup lazyload_mason
	autocmd!
	autocmd VimEnter *
		\ call plug#load('mason.nvim')
		\ | call v:lua.require'mason'.setup()
		\ | autocmd! lazyload_mason
augroup END



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
