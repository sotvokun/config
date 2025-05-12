" bundle/completion.vim - plugins bundle of completion
"

" Section: cmp family
" -----------------------------------------------------------------------------
" NOTE: setup cmp after lazy loaded
" NOTE: use blink.cmp instead of cmp-family-bucket
"
" Plug 'hrsh7th/nvim-cmp'    , {'on': []}
" Plug 'hrsh7th/cmp-nvim-lsp', {'on': []}
" Plug 'hrsh7th/cmp-buffer'  , {'on': []}
" Plug 'hrsh7th/cmp-path'    , {'on': []}
" Plug 'hrsh7th/cmp-vsnip'   , {'on': []}
" augroup lazyload_cmp
" 	autocmd!
" 	autocmd BufReadPre *
" 		\ call plug#load('nvim-cmp', 'cmp-nvim-lsp', 'cmp-buffer', 'cmp-path', 'cmp-vsnip')
" 		\ | runtime bundle/plugin/cmp.lua
" 		\ | autocmd! lazyload_cmp
" augroup END


" Section: blink.cmp
" -----------------------------------------------------------------------------
"
Plug 'saghen/blink.cmp', {'on': []}
augroup lazyload_blink_cmp
	autocmd!
	autocmd InsertEnter *
		\ call plug#load('blink.cmp')
		\ | runtime bundle/plugin/blink.cmp.lua
		\ | autocmd! lazyload_blink_cmp
augroup END
