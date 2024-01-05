if exists('b:did_php_ftplugin')
	finish
endif
let b:did_php_ftplugin = 1


if has('nvim')
	call LspRegister({
		 \ 'name': 'intelephense',
		 \ 'filetypes': ['php'],
		 \ 'cmd': ['intelephense', '--stdio'],
		 \ 'root_pattern': ['composer.json']
		 \ })
endif
