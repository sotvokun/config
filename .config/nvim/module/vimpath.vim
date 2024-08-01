" module/vimpath.vim - the module to reset vim runtimepath and packpath with modern style
"
" FUNCTION:
"   VimPath()                    - Get the path that set by this module. It is
"                                  an implement of "stdpath" for vim.
"                                  SUPPORT: config, data
"

if exists('g:loaded_module_vimpath')
	finish
endif
let g:loaded_module_vimpath = 1

"   Part: not necessary for neovim
if has('nvim')
	function! VimPath(type)
		return stdpath(a:type)
	endfunction
	finish
endif


let s:userhome = has('win32') ? $USERPROFILE : $HOME
let s:nvim_cfg_path = s:userhome . '/.config/nvim'

"   Part: reset vim runtimepath
if has('win32')
	set runtimepath-=s:userhome/vimfiles
	set runtimepath-=s:userhome/vimfiles/after
	set packpath-=s:userhome/vimfiles
	set packpath-=s:userhome/vimfiles/after

	let s:vim_data_path = $LOCALAPPDATA . '/vim-data'
	execute printf('setglobal runtimepath^=%s/site', s:vim_data_path)
	execute printf('setglobal runtimepath+=%s/site/after', s:vim_data_path)
	execute printf('setglobal packpath^=%s/site', s:vim_data_path)
	execute printf('setglobal packpath+=%s/site/after', s:vim_data_path)
endif
if has('unix')
	set runtimepath-=s:userhome/.vim | set runtimepath-=~/.vim
	set runtimepath-=s:userhome/.vim/after | set runtimepath-=~/.vim/after
	set packpath-=s:userhome/.vim | set packpath-=~/.vim
	set packpath-=s:userhome/.vim/after | set packpath-=~/.vim/after

	let s:vim_data_path = s:userhome . '/.local/share/vim'
	execute printf('setglobal runtimepath^=%s/site', s:vim_data_path)
	execute printf('setglobal runtimepath+=%s/site/after', s:vim_data_path)
	execute printf('setglobal packpath^=%s/site', s:vim_data_path)
	execute printf('setglobal packpath+=%s/site/after', s:vim_data_path)
endif
if !isdirectory(s:vim_data_path)
	call mkdir(s:vim_data_path, 'p')
endif

execute printf('setglobal runtimepath^=%s', s:nvim_cfg_path)
execute printf('setglobal runtimepath+=%s/after', s:nvim_cfg_path)
execute printf('setglobal packpath^=%s', s:nvim_cfg_path)
execute printf('setglobal packpath+=%s/after', s:nvim_cfg_path)

"   Part: set viminfofile
execute printf('setglobal viminfofile=%s/viminfo', s:vim_data_path)

"   Part: set vim functional directories
for s:dir in ['view', 'undo', 'backup']
	let s:dir_path = printf('%s/%s', s:vim_data_path, s:dir)
	if !isdirectory(s:dir_path)
		call mkdir(s:dir_path, 'p')
	endif
	execute printf('setglobal %sdir=%s', s:dir, s:dir_path)
endfor

"   FUNCTION: VimPath
function! VimPath(type)
	if a:type == 'config'
		return s:nvim_cfg_path
	endif
	if a:type == 'data'
		return s:vim_data_path
	endif
	throw printf('unknown type for VimPath: %s', a:type)
endfunction


"   Part: netrw
let g:netrw_home = VimPath('data')
