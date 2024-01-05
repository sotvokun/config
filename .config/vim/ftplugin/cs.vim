if exists('b:did_cs_ftplugin')
	finish
endif
let b:did_cs_ftplugin = 1


if has('nvim')
	call LspRegister({
		\ 'name': 'csharp-ls',
		\ 'filetypes': ['cs', 'razor', 'csproj', 'fs', 'fsproj'],
		\ 'cmd': ['csharp-ls'],
		\ 'root_pattern': ['.git']
		\ })
endif
