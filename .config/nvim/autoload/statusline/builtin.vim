function statusline#builtin#modified()
	return &modified ? '[+]' : ''
endfunction


function statusline#builtin#readonly()
	return &readonly ? '[RO]' : ''
endfunction


function statusline#builtin#fileformat()
	let l:format = &fileformat
	if l:format == 'dos'
		return '[CRLF]'
	elseif l:format == 'mac'
		return '[CR]'
	else
		return ''
	endif
endfunction


function statusline#builtin#fileencoding()
	if &fileencoding == 'utf-8' || &fileencoding == ''
		return ''
	else
		return '[' . toupper(&fileencoding) . ']'
	endif
endfunction


function statusline#builtin#filetype()
	if &filetype == ''
		return ''
	else
		return '[' . (&filetype) . ']'
	endif
endfunction


function! s:get_floaterm_title()
	let arg2 = len(g:floaterm#buflist#gather())
	let arg1 = index(g:floaterm#buflist#gather(), bufnr()) + 1
	let title = b:floaterm_title
	let title = substitute(title, '\$1', arg1, '')
	let title = substitute(title, '\$2', arg2, '')
	return title
endfunction

function! statusline#builtin#filename()
	let l:winwidth = winwidth('%')
	let l:bufname = bufname('%')
	let l:filename = fnamemodify(l:bufname, '%:p:h')
	let l:isfile = &buftype == '' && filereadable(l:filename)

	if l:bufname == ''
		return '[No Name]'
	endif

	if l:isfile
		return (len(l:bufname) > 60 && l:winwidth < 100) ? pathshorten(l:bufname) : l:bufname
	elseif &buftype == 'help'
		return fnamemodify(l:bufname, ':t')
	elseif &filetype == 'floaterm'
		return s:get_floaterm_title()
	else
		return l:bufname
	endif
endfunction


function! statusline#builtin#location()
	return line('.') . ':' . virtcol('.')
endfunction


function! s:mode_hl(mode)
	if a:mode == 'v' || a:mode == 'V' || a:mode == '\22' || a:mode == 's' || a:mode == 'S' || a:mode == '\19'
		return 'StatusLineModeVisual'
	elseif a:mode == 'i'
		return 'StatusLineModeInsert'
	elseif a:mode == 'r' || a:mode == 'R' || a:mode == 'Rv'
		return 'StatusLineModeReplace'
	elseif a:mode == 'c' || a:mode == 'cv' || a:mode == 'ce'
		return 'StatusLineModeCommand'
	elseif a:mode == 't'
		return 'StatusLineModeTerminal'
	elseif a:mode == '!'
return 'StatusLineModeShell'
	else
		return 'Normal'
	endif
endfunction


function statusline#builtin#mode()
	let l:mode = mode()
	let s:mode = {
		\ 'v': 'visual',
		\ 'V': 'visual-line',
		\ '\22': 'visual-block',
		\ 's': 'select',
		\ 'S': 'select-line',
		\ '\19': 'select-block',
		\ 'i': 'insert',
		\ 'r': 'replace',
		\ 'R': 'replace',
		\ 'Rv': 'visual-replace',
		\ 'c': 'command',
		\ 'cv': 'ex',
		\ 'ce': 'ex',
		\ '!': 'shell',
		\ 't': 'terminal'
		\ }
	if get(s:mode, l:mode, '') == ''
		return ''
	else
		return '%#' . s:mode_hl(l:mode) . '#' . s:mode[l:mode] . '%*'
	endif
endfunction
