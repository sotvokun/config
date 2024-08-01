" ftplugin/dirvish.vim
"


if exists('b:did_dirvish_ftplugin')
	finish
endif
let b:did_dirvish_ftplugin = 1


" Section: Mappings

nnoremap <buffer> ga <cmd>call <sid>create_file()<cr>
nnoremap <buffer> gA <cmd>call <sid>create_dir()<cr>
nnoremap <buffer> D <cmd>call <sid>delete_under_cursor()<cr>


" Section: Functions

function! s:create_file()
	let filename = input('File name: ')
	if trim(filename) == ''
		return
	endif
	let filepath = expand('%') . filename
	execute printf('edit %s', filepath)
endfunction

function! s:create_dir()
	let dirname = input('Directory name: ')
	if trim(dirname) == ''
		return
	endif
	let dirpath = expand('%') . dirname
	if isdirectory(dirpath)
		redraw
		echomsg printf('"%s" already exists.', dirpath)
		return
	endif
	call mkdir(dirpath, 'p')
	Dirvish %
endfunction

function! s:delete_under_cursor()
	let path = getline('.')
	let is_dir = isdirectory(path)
	let prompt = printf('Delete %s "%s"', is_dir ? 'directory' : 'file', path)
	let userconfirm = confirm(prompt, "&Yes\n&no", 2)
	if userconfirm != 1
		echomsg 'Cancelled.'
		return
	endif
	let result = delete(path, is_dir ? 'rf' : '')
	if result != 0
		echomsg printf('FAILED! %s', prompt)
		return
	endif
	Dirvish %
endfunction
