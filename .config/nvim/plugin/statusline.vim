" plugin/statusline.vim - customizing statusline as plugin
"
"
" PATTERN:
" FILEPATH [+/-][RO][Preview] [Git(BRANCH)]     [LSP-CLIENTS][filetype][fileformat][fileencoding] LN:COL


if exists('g:loaded_plugin_statusline')
	finish
endif
let g:loaded_plugin_statusline = 1

if exists('g:vscode')
	set statusline=
	set statusline=\ 
	finish
endif


set statusline=
set statusline+=\ 
set statusline+=%{%statusline#filename()%}
set statusline+=\ 
set statusline+=%m%r%w
set statusline+=\ %{statusline#fugitive()}%{%statusline#gitgutter()%}
set statusline+=%=
set statusline+=%{statusline#lsp_clients()}
set statusline+=%y
set statusline+=%{&fileformat=='dos'?'[CRLF]':(&fileformat=='mac'?'[CR]':'')}
set statusline+=%{&fileencoding=='utf-8'?'':(&fileencoding==''?'':'['.toupper(&fileencoding).']')}
set statusline+=%10{line('.').':'.virtcol('.')}
set statusline+=\ 
