let $VIMBUILD = has('nvim') ? 'nvim' : 'vim'
let $VIM_USER_HOME = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let $VIM_DATA_HOME = has('nvim')
	\ ? stdpath('data')
	\ : has('win32')
		\ ? $LOCALAPPDATA . '/vim'
		\ : $HOME . '/.local/share/vim'


" Section: Setup universal rtp for vim/neovim before VimEnter

if !get(v:, 'vim_did_enter', !has('vim_starting'))
	filetype off
	
	let s:old_config_dir = has('nvim')
		\ ? stdpath('config')
		\ : (has('win32') ? '~/vimfiles' : '~/.vim')
	let s:old_config_after_dir = s:old_config_dir . '/after'
	execute printf(
		\ 'setglobal rtp-=%s rtp-=%s pp-=%s pp-=%s',
		\ s:old_config_dir, s:old_config_after_dir,
		\ s:old_config_dir, s:old_config_after_dir)

	let s:new_config_after_dir = $VIM_USER_HOME . '/after'
	execute printf(
		\ 'setglobal rtp^=%s rtp+=%s pp^=%s pp+=%s',
		\ $VIM_USER_HOME, s:new_config_after_dir,
		\ $VIM_USER_HOME, s:new_config_after_dir)

	if $VIMBUILD == 'vim'
		let s:vim_data_site_dir = $VIM_DATA_HOME . '/site'
		let s:vim_data_site_after_dir = s:vim_data_site_dir . '/after'
		execute printf(
			\ 'setglobal rtp^=%s rtp+=%s pp^=%s pp+=%s',
			\ s:vim_data_site_dir, s:vim_data_site_after_dir,
			\ s:vim_data_site_dir, s:vim_data_site_after_dir)

		for s:dir in ['view', 'undo', 'backup']
			let s:path = $VIM_DATA_HOME . '/' . s:dir . '/'
			call mkdir(s:path, 'p')
			execute printf(
				\ 'setglobal %sdir=%s',
				\ s:dir,
				\ s:path)
		endfor
	endif
endif


" Section: Special initialization

if exists('g:vscode')
	execute 'source ' . $VIM_USER_HOME . '/init-vscode.vim'
	finish
endif


" Section: Mods

command! -nargs=1 LoadMod
	\ execute 'source ' . fnameescape($VIM_USER_HOME . '/mod/<args>.vim')
LoadMod nvim-compatible
LoadMod clipboard
LoadMod preference

let g:pkg_manifest = $VIM_USER_HOME . '/pkg'
let g:pkg_provider = 'plug'
let g:pkg_provider_option = { 'path': $VIM_DATA_HOME . '/plugged' }
LoadMod pkg

delcommand LoadMod
