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

	let g:dissession_ready = 1
	let g:dissession_session_file = session_filepath
	return 1
endfunction

function! dissession#save()
	if isdirectory(g:dissession_dir) == 0
		call mkdir(g:dissession_dir, 'p')
	endif

	let session_filename = function('s:session_file_name')(getcwd())
	let session_filepath = fnameescape(g:dissession_dir . '/' . session_filename)
	execute 'mksession! ' . session_filepath

	let g:dissession_ready = 1
	let g:dissession_session_file = session_filepath
endfunction

function! dissession#load()
	if !g:dissession_ready
		echohl WarningMsg
		echomsg 'No session file found'
		echohl None
	endif

	let session_filepath = g:dissession_session_file
	execute 'source ' . session_filepath
endfunction

function! dissession#prune()
	if !g:dissession_ready
		return
	endif

	let session_filepath = g:dissession_session_file
	call delete(session_filepath)

	let g:dissession_ready = 0
	let g:dissession_session_file = ''
endfunction
