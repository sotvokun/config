" after/plugin/floaterm.vim: floaterm configuration
"

if exists('g:loaded_floaterm_after')
	finish
endif
let g:loaded_floaterm_after = 1


" Section: Settings

let g:floaterm_wintype = 'split'
let g:floaterm_height = 0.35

if has('win32')
	let g:floaterm_shell = 'powershell'
endif

let s:default_terminal_name = 'default_terminal'
let s:default_terminal_title = 'Terminal'


" Section: Mappings

nnoremap <c-\> <cmd>call <SID>toggle_default_terminal()<cr>


" Section: Functions

function! s:toggle_default_terminal()
	let bufnr = floaterm#terminal#get_bufnr(s:default_terminal_name)
	if bufnr == -1
		execute printf('FloatermNew --name=%s --title=%s --autohide=0',
			\ s:default_terminal_name,
			\ s:default_terminal_title
			\ )
	else
		execute 'FloatermToggle ' . s:default_terminal_name
	endif
endfunction


" Section: ftplugin / autocmd

augroup floaterm_after
	autocmd!
	autocmd FileType floaterm
		\ setlocal nonumber
		\ | tnoremap <buffer> <c-\> <cmd>call <SID>toggle_default_terminal()<cr>
		\ | nnoremap <buffer> <c-w>d <cmd>FloatermKill<cr>
augroup END
