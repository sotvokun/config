function! statusline#git#homedir()
	if has('win32')
		return $USERPROFILE
	else
		return $HOME
	endif
endfunction


function! statusline#git#component()
	let l:pwd = getcwd()
	let l:git_dir = finddir('.git', ';' . statusline#git#homedir())
	if !isdirectory(l:git_dir) || !executable('git')
		return ""
	endif
	let l:head_name = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
	return '[' . trim(l:head_name) . ']'
endfunction
