function! s:session_file_name(path)
	let iswin = has('win32')
	let parts = split(a:path, iswin ? '\' : '/')
	let parts = map(parts, {i, v -> substitute(v, '[[:punct:]]', '_', 'g')})
	return join(parts, '_') . '.vim'
endfunction


function! dissession#check()
	let session_filename = function('s:session_file_name')(getcwd())
	let session_filepath = fnameescape(g:dissession_dir . '/' . session_filename)
	if !filereadable(session_filepath)
		return 0
	endif

	let g:dissession__ready = 1
	let g:dissession__session_file = session_filepath
	return 1
endfunction


" Save the current session to a file.
"
" Arguments:
" - [optional] clear_buffers: If true, clears non-modifiable and non-listed buffers.
function! dissession#save(...)
	if isdirectory(g:dissession_dir) == 0
		call mkdir(g:dissession_dir, 'p')
	endif

	" clear nomodifiable buffers
	if a:0 > 0 && a:1
		let clear_condition = '!buflisted(v:val) || getbufvar(v:val, "&modifiable") == 0'
		let buffers = filter(range(1, bufnr('$')), clear_condition)
		for buf in buffers
			silent! execute 'bdelete! '.buf
		endfor
	endif

	let session_filename = function('s:session_file_name')(getcwd())
	let session_filepath = fnameescape(g:dissession_dir . '/' . session_filename)
	execute 'mksession! ' . session_filepath

	let g:dissession__ready = 1
	let g:dissession__session_file = session_filepath
endfunction


function! dissession#load()
	if !g:dissession__ready
		echohl WarningMsg
		echomsg 'No session file found'
		echohl None
	endif

	let session_filepath = g:dissession__session_file
	execute 'source ' . session_filepath
endfunction


function! dissession#prune()
	if !g:dissession__ready
		return
	endif

	let session_filepath = g:dissession__session_file
	call delete(session_filepath)

	let g:dissession__ready = 0
	let g:dissession__session_file = ''
endfunction
