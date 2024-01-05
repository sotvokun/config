if has('unnamedplus')
	set clipboard^=unnamedplus
else
	set clipboard^=unnamed
endif

if has('nvim') && has('win32') || has('wsl')
	let s:win32yank_path = 'win32yank'
	if has('wsl')
		let s:win32yank_winpath =
			\ system('/mnt/c/Windows/System32/where.exe win32yank')
		let s:win32yank_path =
			\ '/mnt/c' . trim(substitute(s:win32yank_winpath[2:], '\\', '/', 'g'))
	endif
	let g:clipboard = {
		\ 'name': 'win32yank',
		\ 'copy': { '+': s:win32yank_path . ' -i --crlf', '*': s:win32yank_path . ' -i --crlf' },
		\ 'paste': { '+': s:win32yank_path . ' -o --lf', '*': s:win32yank_path . ' -o --lf' },
		\ 'cache_enabled': 0
		\ }
endif
