if exists('b:did_go_ftplugin')
	finish
endif
let b:did_go_ftplugin = 1


call LspRegister({
	\     'name': 'gopls',
	\     'cmd': ['gopls'],
	\     'filetypes': ['go', 'gomod', 'gowork', 'gotmpl'],
	\     'root_pattern': ['go.work', 'go.mod', '.git'],
	\ })
