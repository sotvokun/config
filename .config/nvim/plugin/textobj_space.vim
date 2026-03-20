" textobj_space.vim
"
" textobj_space.vim is a plugin provides some text object for spaces
"

if exists('g:loaded_textobj_space')
	finish
endif
let g:loaded_textobj_space = 1

function! s:SelectSpace(inner)
	let l:char = getline('.')[col('.') - 1]
	if l:char !~ '[ \t]'
		return
	endif

	" Search continous spaces' start position and end position
	let l:start = searchpos('[ \t]\+', 'bcWn')
	let l:end = searchpos('[ \t]\+', 'ceWn')

	if l:start[0] == 0 || l:end[0] == 0
		return
	endif

	" if `i<space>` (inner), keeping one space
	if a:inner
		if l:end[1] > l:start[1]
			let l:end[1] -= 1
		else
			" only one space, selecting nothing
			return
		endif
	endif

	" executing selection
	call setpos("'<", [0, l:start[0], l:start[1], 0])
	call setpos("'>", [0, l:end[0], l:end[1], 0])
	normal! gv
endfunction

" defining visual mode mapping
xnoremap <silent> i<space> <cmd>call <SID>SelectSpace(0)<cr>
xnoremap <silent> a<space> <cmd>call <SID>SelectSpace(0)<cr>

" defining operator-pending mode
onoremap <silent> i<space> <cmd>call <SID>SelectSpace(1)<cr>
onoremap <silent> a<space> <cmd>call <SID>SelectSpace(0)<cr>
