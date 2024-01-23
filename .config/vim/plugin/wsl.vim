" wsl.vim
"
" wsl.vim provides some useful functions and commands for wsl environments
"


" Get the Windows executable path and convert it to mounted posix path.
"
" EXAMPLE:
"   WslWhere('clip')  ->  /mnt/c/Windows/System32/clip.exe
"
" PARAMS:
"   exec [string]         The name of executable that on Windows System
"
" RETURNS:
"   The string of the executable path if executable is found.
"   0 if the executable do not exist.
"
function WslWhere(exec)
	let l:cmd = printf('/mnt/c/Windows/System32/where.exe %s', a:exec)
	let l:winpath = system(l:cmd)
	let l:posixpath = '/mnt/' . tolower(l:winpath[0]) . trim(substitute(l:winpath[2:], '\\', '/', 'g'))
	if executable(l:posixpath)
		return l:posixpath
	else
		return 0
	endif
endfunction
