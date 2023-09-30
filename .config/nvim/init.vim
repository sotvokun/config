" ------------------------------------------------ 
"  init.vim
"  Created:  2023-05-18
"  Modified: 2023-09-30
" ------------------------------------------------


" Commands
" -----------------------
command! -nargs=1 -complete=file
    \ RequireSource
    \ execute 'source ' . fnameescape(stdpath('config') . '/<args>')


" Initialize moonwalk
"   - Inject macros
" -----------------------
lua (function ()
    \ local fennel = require('fennel')
    \ fennel['macro-path'] = 
    \     fennel['macro-path'] .. ';' .. vim.fn.stdpath('config') .. '/fnl/?.fnl'
    \ require('moonwalk').add_loader('fnl', function (src)
    \     src = "(require-macros :macros)\n" .. src
    \     return fennel.compileString(src)
    \ end)
    \ end)()


" Load configurations
" -----------------------
if exists('g:vscode')
    RequireSource vscode/init.vim
    finish
end

RequireSource init-tiny.vim
