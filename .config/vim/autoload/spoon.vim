function! s:buflisted()
	return filter(
		\ range(1, bufnr('$')),
		\ 'buflisted(v:val) && getbufvar(v:val, "&filetype") != "qf"')
endfunction


function! s:hash(buf, lnum, col)
	if g:spoon_singlebuf == 1
		return a:buf
	else
		return a:buf . ':' . a:lnum . ':' . a:col
	endif
endfunction


function! spoon#save(...)
	if !exists('g:spoon_data')
		let g:spoon_data = {}
	endif
	let l:pos = getcurpos()
	let l:lnum = l:pos[1]
	let l:col = l:pos[2]
	let l:bufnr = bufnr('%')
	let l:hash = s:hash(l:bufnr, l:lnum, l:col)
	let g:spoon_data[empty(a:0) ? l:hash : a:0] = {
		\ 'bufnr': l:bufnr,
		\ 'lnum': l:pos[1],
		\ 'col': l:pos[2],
		\ 'bufname': bufname('%'),
		\ 'filename': expand('%:p'),
		\ }
endfunction


function! spoon#update_pos()
	if !exists('g:spoon_data')
		return
	endif
	if g:spoon_singlebuf == 0
		echo '[spoon] cannot update position in non-singlebuf mode'
	endif
	let l:bufnr = bufnr('%')
	let l:pos = getcurpos()
	let l:lnum = l:pos[1]
	let l:col = l:pos[2]
	if !has_key(g:spoon_data, s:hash(l:bufnr, l:lnum, l:col))
		return
	endif
	let g:spoon_data[s:hash(l:bufnr, l:lnum, l:col)]['lnum'] = l:lnum
	let g:spoon_data[s:hash(l:bufnr, l:lnum, l:col)]['col'] = l:col
endfunction


function! spoon#delete_by_mark(mark)
	if !exists('g:spoon_data') || !has_key(g:spoon_data, a:mark)
		return
	endif
	unlet g:spoon_data[a:mark]
endfunction


function! spoon#delete_by_bufnr(bufnr)
	if !exists('g:spoon_data')
		return
	endif
	for [key, value] in items(g:spoon_data)
		if value['bufnr'] == a:bufnr
			unlet g:spoon_data[key]
		endif
	endfor
endfunction


function! spoon#delete_by_curpos()
	if !exists('g:spoon_data')
		return
	endif
	let l:bufnr = bufnr('%')
	let l:pos = getcurpos()
	let l:lnum = l:pos[1]
	let l:col = l:pos[2]
	for [key, value] in items(g:spoon_data)
		if value['bufnr'] == l:bufnr && value['lnum'] == l:lnum && value['col'] == l:col
			unlet g:spoon_data[key]
			break
		endif
	endfor
endfunction


function! spoon#delete_by_index(n)
	if !exists('g:spoon_data') || empty(g:spoon_data)
		return
	endif
	let keys = keys(g:spoon_data)
	if a:n < 0 || a:n > len(keys)
		return
	endif
	unlet g:spoon_data[keys[a:n - 1]]
endfunction


function! spoon#clear()
	let g:spoon_data = {}
endfunction


function! spoon#switch(mark)
	if !exists('g:spoon_data') || !has_key(g:spoon_data, a:mark)
		echo printf('[spoon] mark %s not found', a:mark)
		return
	endif
	let spoon_item = g:spoon_data[a:mark]
	if spoon_item['bufnr'] == bufnr('%')
		execute printf('call cursor(%d, %d)',
			\ spoon_item['lnum'], spoon_item['col'])
		return
	endif
	if index(s:buflisted(), spoon_item['bufnr']) == -1
		" if the buffer is not exist, open it
		execute printf('edit %s | call cursor(%d, %d)',
			\ spoon_item['filename'],
			\ spoon_item['lnum'], spoon_item['col'])
	else
		" if the buffer is exist, switch to it
		execute printf('buffer %d | call cursor(%d, %d)',
			\ spoon_item['bufnr'],
			\ spoon_item['lnum'], spoon_item['col'])
	endif
endfunction


function! spoon#select(n)
	if !exists('g:spoon_data') || empty(g:spoon_data)
		echo '[spoon] no saved buffer and position found'
		return
	endif
	let keys = keys(g:spoon_data)
	if a:n < 0 || a:n > len(keys)
		echo '[spoon] invalid number'
		return
	endif
	call spoon#switch(keys[a:n - 1])
endfunction


let s:current_index = 0

function! spoon#next()
	if !exists('g:spoon_data') || empty(g:spoon_data)
		echo '[spoon] no saved buffer and position'
		return
	endif
	let keys = keys(g:spoon_data)
	let l:next_index = s:current_index + 1
	if l:next_index >= len(keys)
		let l:next_index = 0
	endif
	call spoon#switch(keys[l:next_index])
	let s:current_index = l:next_index
endfunction

function! spoon#prev()
	if !exists('g:spoon_data') || empty(g:spoon_data)
		echo '[spoon] no saved buffer and position'
		return
	endif
	let keys = keys(g:spoon_data)
	let l:prev_index = s:current_index - 1
	if l:prev_index < 0
		let l:prev_index = len(keys) - 1
	endif
	call spoon#switch(keys[l:prev_index])
	let s:current_index = l:prev_index
endfunction
