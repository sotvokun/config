if exists('b:did_c_ftplugin')
	finish
endif
let b:did_c_ftplugin = 1


let clangd_cmd = ['clangd', '--compile-commands-dir=build']
call LspRegister({
	\ 'name': 'clangd',
	\ 'filetypes': ['c', 'cpp', 'objc'],
	\ 'cmd': clangd_cmd
	\ })
