
nnoremap <leader>gg <cmd>Git<cr>

augroup fugitive_setup
	au!
	autocmd FileType fugitive
		\ setlocal nowrap
		\ | set nonumber
		\ | nnoremap <buffer> q <cmd>quit<cr>
augroup END

