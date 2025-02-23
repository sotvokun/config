" after/ftplugin/go.vim - go filetype after
"

if exists('g:vscode')
	finish
endif

if exists('b:did_ftplugin_after')
	finish
endif
let b:did_ftplugin_after = 1

if executable('goimports')
	setlocal formatprg=goimports
else
	setlocal formatprg=gofmt
endif

augroup go_ftplugin_after
	autocmd!
	autocmd BufWritePre <buffer> call s:format()
augroup END


" Section: Functions
"

function! s:format()
	let formatprg = &formatprg
	if -1 == index(['gofmt', 'goimports'], formatprg)
		echoerr printf('unsupported formatprg: %s, only support gofmt and goimports yet', formatprg)
		return
	endif
	
	let curpos = getcurpos()

	let bufcontent = getline(1, '$')
	let tempfile = tempname()
	call writefile(bufcontent, tempfile)

	let output = system([formatprg, '-w', tempfile])
	if v:shell_error
		call delete(tempfile)
		let fixlist = s:handle_format_error(output, tempfile, expand('%:.'))
		if len(fixlist) == 0
			return
		endif
		call setloclist(0, fixlist, 'r', 'Go format error')
		return
	endif
	call setloclist(0, [], 'r')

	let formatted = readfile(tempfile)
	call deletebufline('%', 1, '$')
	call setline(1, formatted)
	call delete(tempfile)
	
	let lineoffset = len(formatted) - len(bufcontent)
	let curpos[1] += lineoffset
	call setpos('.', curpos)
endfunction

let s:FORMATPRG_FORMAT = '^\(.*\):\(\d\+\):\(\d\+\): \(.*\)'
function! s:handle_format_error(output, tempfile, bufname)
	let outputlist = split(a:output, '\n')
	let tempfile = a:tempfile
	if has('win32')
		let tempfile = escape(tempfile, '\')
	endif
	let bufname = a:bufname
	if has('win32')
		let bufname = escape(bufname, '\')
	endif

	let fixlist = []
	for line in outputlist
		let line = substitute(line, '\V'.tempfile, bufname, 'g')
		let match = matchlist(line, s:FORMATPRG_FORMAT)
		if len(match) == 0
			continue
		endif
		let item = {'filename': match[1], 'lnum': match[2], 'col': match[3], 'text': match[4]}
		call add(fixlist, item)
	endfor
	return fixlist
endfunction
