" Section: Common

function! s:warn(msg)
	echohl WarningMsg
	echomsg a:msg
	echohl None
endfunction


" Section: vsnip

function! s:vsnip_inject_snippet(trigger_word)
	execute 'normal! a' . a:trigger_word . "\<c-o>:call vsnip#expand()\<cr>\<bs> | startinsert"
endfunction

function! fzf#ext#vsnip(...)
	if !exists(':VsnipOpenEdit')
		return s:warn('vsnip not found')
	endif
	let l:snippets = flatten(vsnip#source#find(bufnr('%')))
	if empty(l:snippets)
		return s:warn('no snippets available here')
	endif
	let lists = map(l:snippets, {i, val -> printf('%s', val['label'])})
	return fzf#run(fzf#wrap({
			\ 'source': lists,
			\ 'options': '+m --ansi --prompt="vsnip> " --preview="echo {1}"',
			\ 'sink': function('s:vsnip_inject_snippet'),
			\ }))
endfunction
