if exists('b:did_php_ftplugin')
	finish
endif
let b:did_php_ftplugin = 1


" Section: LSP

let s:user_home = ''
if has('win32')
	let s:user_home = $USERPROFILE
else
	let s:user_home = $HOME
endif
let s:intelephense_license_file = s:user_home . '/.intelephense_license.key'
let s:intelephense_license_key = ''
if filereadable(s:intelephense_license_file)
	let s:intelephense_license_key = readfile(s:intelephense_license_file)[0]
endif
call LspRegister({
	 \ 'name': 'intelephense',
	 \ 'filetypes': ['php'],
	 \ 'cmd': ['intelephense', '--stdio'],
	 \ 'root_pattern': ['composer.json'],
	 \ 'init_options': {
	 \   'licenceKey': s:intelephense_license_key,
	 \ }
	 \ })
