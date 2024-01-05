function! statusline#lsp#component()
	if !has('nvim') || !exists('g:loaded_lsp')
		return ''
	endif
	let l:clients = v:lua.require'lsp'.util.client_names(bufnr('%'))
	if len(l:clients) == 0
		return ''
	else
		return ' [' . join(l:clients, ' ') . ']'
	endif
endfunction
