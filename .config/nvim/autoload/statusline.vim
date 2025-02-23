" autoload/statusline.vim - statusline components
"

function! statusline#filename()
	let winwidth = winwidth('%')
	let bufname = bufname('%')
	let filename = fnamemodify(bufname, ':p')
	let isfile = &buftype == '' && filereadable(filename)

	if &buftype == 'help'
		return fnamemodify(bufname, ':t')
	endif

	if isfile
		let bufname = fnamemodify(bufname, ':~:.')
		return (len(bufname) >= 60 && winwidth < 100) ? pathshorten(bufname) : bufname
	else
		return '%f'
	endif
endfunction


function! statusline#lsp_clients()
	if has('nvim')
		let bufnum = bufnr()
		silent! let clients = v:lua.vim.lsp.get_clients({'bufnr': bufnum})
		if len(clients) == 0 || empty(clients) || type(clients) != type([])
			return ''
		else
			return printf('[%s]', join(map(clients, {_, val -> val['name']}), ' '))
		endif
	else
		return ''
	endif
endfunction


function! statusline#fugitive()
	if !exists(':G')
		return ''
	endif
	return fugitive#statusline()
endfunction

function! statusline#gitgutter()
	if !exists(':GitGutter')
		return ''
	endif
	let [a, m, r] = GitGutterGetHunkSummary()
	if a + m + r == 0
		return ''
	endif
	let msgarr = []
	if a > 0
		call add(msgarr, printf('%%#Added#+%d%%*', a))
	endif
	if m > 0
		call add(msgarr, printf('%%#Changed#~%d%%*', m))
	endif
	if r > 0
		call add(msgarr, printf('%%#Removed#-%d%%*', r))
	endif
	return printf('[%s]', join(msgarr, ' '))
endfunction
