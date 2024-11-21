function! statusline#lsp#component()
	if !has('nvim')
		return ''
	endif
	let clients = map(v:lua.vim.lsp.get_clients({'bufnr':bufnr()}), {_, v -> v['name']})
	if len(clients) == 0
		return ''
	else
		return ' [' . join(clients, ' ') . ']'
	endif
endfunction
