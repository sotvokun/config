set clipboard=unnamed

if !has('nvim') && has('unnamedplus')
	set clipboard=unnamedplus
	finish
endif

if has('nvim')
	set clipboard=unnamedplus

	if has('win32')
		let s:win32yank = 'win32yank'
	endif

	if has('wsl')
		let s:win32yank_winpath =
			\ system('/mnt/c/Windows/System32/where.exe win32yank.exe')
		let s:win32yank_posixpath = printf(
			\ '/mnt/%s%s',
			\ tolower(s:win32yank_winpath[0]),
			\ trim(substitute(s:win32yank_winpath[2:], '\\', '/', 'g')))
		let s:win32yank = s:win32yank_posixpath
	endif

	if has('win32') || has('wsl')
		let g:clipboard = {
			\ 'name': 'win32yank',
			\ 'copy': {
			\   '+': [s:win32yank, '-i', '--crlf'],
			\   '*': [s:win32yank, '-i', '--crlf'],
			\ },
			\ 'paste': {
			\   '+': [s:win32yank, '-o', '--lf'],
			\   '*': [s:win32yank, '-o', '--lf'],
			\ },
			\ 'cache_enabled': 0,
			\ }
		finish
	endif
endif
