if exists('b:did_go_ftplugin')
	finish
endif
let b:did_go_ftplugin = 1


call LspRegister({
	\     'name': 'gopls',
	\     'cmd': ['gopls'],
	\     'filetypes': ['go', 'gomod', 'gowork', 'gotmpl'],
	\     'root_pattern': ['go.work', 'go.mod', '.git'],
	\ })

function! s:go_fmt()
	if executable('gofmt') != 1
		return
	endif
	let l:curspos = getpos('.')
	silent execute ':%!gofmt'
	call setpos('.', l:curspos)
endfunction

augroup ftplugin_go
	au!
	autocmd BufWritePre <buffer> :call s:go_fmt()
augroup END
