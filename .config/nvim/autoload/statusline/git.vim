function! statusline#git#fugitive()
	return exists(':G') ? FugitiveStatusline() : ''
endfunction
