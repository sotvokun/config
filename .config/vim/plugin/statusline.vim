set statusline=
set statusline+=%{%statusline#dissession#component()%}
set statusline+=\ %{statusline#builtin#filename()}
set statusline+=\ %{statusline#builtin#modified()}%{statusline#builtin#readonly()}
set statusline+=%=
set statusline+=%{%statusline#builtin#mode()%}
set statusline+=%{statusline#lsp#component()}
set statusline+=\ %{statusline#builtin#filetype()}%{statusline#builtin#fileformat()}%{statusline#builtin#fileencoding()}
set statusline+=\ %10{statusline#builtin#location()}
set statusline+=\ 
