" bundle/completion.vim - plugins bundle of completion
"

" Section: cmp family
" -----------------------------------------------------------------------------
" NOTE: setup cmp after lazy loaded
"
Plug 'hrsh7th/nvim-cmp'    , {'on': []}
Plug 'hrsh7th/cmp-nvim-lsp', {'on': []}
Plug 'hrsh7th/cmp-buffer'  , {'on': []}
Plug 'hrsh7th/cmp-path'    , {'on': []}
Plug 'hrsh7th/cmp-vsnip'   , {'on': []}
augroup lazyload_cmp
	autocmd!
	autocmd BufReadPre *
		\ call plug#load('nvim-cmp', 'cmp-nvim-lsp', 'cmp-buffer', 'cmp-path', 'cmp-vsnip')
		\ | runtime bundle/plugin/cmp.lua
		\ | autocmd! lazyload_cmp
augroup END


" Section: copilot
" -----------------------------------------------------------------------------
"
Plug 'zbirenbaum/copilot.lua', {'on': []}
augroup lazyload_copilot
	autocmd!
	autocmd InsertEnter *
		\ call plug#load('copilot.lua')
		\ | runtime bundle/plugin/copilot.lua
		\ | autocmd! lazyload_copilot
augroup END


" Section: codecompanion.nvim
" -----------------------------------------------------------------------------
"
Plug 'olimorris/codecompanion.nvim', {'on': []}
augroup lazyload_codecompanion
	autocmd!
	autocmd BufRead *
		\ call plug#load('codecompanion.nvim')
		\ | runtime bundle/plugin/codecompanion.lua
		\ | autocmd! lazyload_codecompanion
augroup END
augroup setup_codecompanion
	autocmd! FileType codecompanion
		\ setlocal nonumber
		\ | setlocal syntax=markdown
		\ | setlocal nonumber
		\ | TSBufEnable highlight
augroup END
