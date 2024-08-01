" ftplugin/go.vim
"

if exists('b:did_go_ftplugin')
	finish
endif
let b:did_go_ftplugin = 1


set tabstop=4
set shiftwidth=4

if has('nvim') && !exists('g:vscode')
	TSBufToggle highlight
endif
