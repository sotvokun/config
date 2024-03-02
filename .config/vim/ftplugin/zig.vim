if exists('b:did_zig_ftplugin')
	finish
endif
let b:did_zig_ftplugin = 1


call LspRegister({
	\    'name': 'zls',
	\    'cmd': ['zls'],
	\    'filetypes': ['zig']
	\ })
