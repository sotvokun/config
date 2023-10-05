" ------------------------------------------------ 
"  init.vim
"  Created:  2023-05-18
"  Modified: 2023-10-04
" ------------------------------------------------


" Commands
" -----------------------
command! -nargs=1 -complete=file
        \ RequireSource
        \ execute 'source ' . fnameescape(stdpath('config') . '/<args>')


" Load configurations
" -----------------------
if exists('g:vscode')
        RequireSource vscode/init.vim
        finish
end

RequireSource init.start.vim
augroup init#
        autocmd VimEnter * PaqPackAdd * !copilot.vim 
        autocmd InsertEnter * 
                \ if exists(":Copilot") == 0 && exists("g:vscode") != 1
                \ | packadd copilot.vim 
                \ | endif
augroup END
