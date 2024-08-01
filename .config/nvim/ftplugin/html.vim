if exists('b:did_html_ftplugin')
	finish
endif
let b:did_html_ftplugin = 1

if has('nvim') && !exists('g:vscode')
	TSBufToggle highlight
endif
