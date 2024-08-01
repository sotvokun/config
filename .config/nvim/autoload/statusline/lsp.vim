function! statusline#lsp#component()
	if !exists('g:vlsps')
		return ''
	endif
	let clients = vlsp#get_clients()
	if len(clients) == 0
		return ''
	else
		return ' [' . join(clients, ' ') . ']'
	endif
endfunction
