" ------------------------------------------------ 
"  init.vim
"  Created:  2023-05-18
"  Modified: 2023-05-27
" ------------------------------------------------

command! -nargs=1 -complete=file
	\ RequireSource
	\ execute 'source ' . fnameescape(stdpath('config') . '/<args>')

if exists('g:vscode')
    RequireSource init-vscode.vim
else
    RequireSource init-tiny.vim
endif


" Load moonwalk
" -----------------------
lua (function ()
    \ local fennel = require('fennel')
    \ fennel['macro-path'] = 
    \     fennel['macro-path'] .. ';' .. vim.fn.stdpath('config') .. '/fnl/?.fnl'
    \ require('moonwalk').add_loader('fnl', function (src)
    \     return fennel.compileString(src)
    \ end)
    \ end)()


" Load modules
" -----------------------
if !exists('g:vscode')
    " lua require 'lsp'
    " lua require 'completion'
endif
