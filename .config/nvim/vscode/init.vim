" ------------------------------------------------
"  init-vscode.vim
"  Created:  2023-07-25
"  Modified: 2023-07-25
" ------------------------------------------------

" - Editing
" -- Better indenting
vnoremap < <gv
vnoremap > >gv

" -- VsCodeCommentary Instead vim-commentary
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" - Sensible

nnoremap ]q <cmd>call VSCodeCall("editor.action.marker.nextInFiles")<cr>
nnoremap [q <cmd>call VSCodeCall("editor.action.marker.prevInFiles")<cr>
nnoremap ]b <cmd>call VSCodeCall("workbench.action.nextEditor")<cr>
nnoremap [b <cmd>call VSCodeCall("workbench.action.previousEditor")<cr>
nnoremap ]t <cmd>call VSCodeCall("workbench.action.focusNextGroup")<cr>
nnoremap [t <cmd>call VSCodeCall("workbench.action.focusPreviousGroup")<cr>

" - Git
nnoremap ]g <cmd>call VSCodeCall("workbench.action.editor.nextChange")<cr>
nnoremap [g <cmd>call VSCodeCall("workbench.action.editor.previousChange")<cr>

" - Misc
nnoremap <esc> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:redraw<cr>


" - LSP supports
nnoremap gR <cmd>call VSCodeCall("editor.action.rename")<cr>

" - Workbench
nnoremap <c-g><c-g> <cmd>call VSCodeCall("workbench.view.explorer")<cr>

" - Settings
" -- Clipboard
set clipboard+=unnamedplus
if has('win32') || has('wsl')
    let s:win32yank = 'win32yank'
    if has('wsl')
        let s:win32yank_winpath = system('/mnt/c/Windows/System32/where.exe win32yank')
        let s:win32yank = 
            \ '/mnt/c' . trim(substitute(s:win32yank_winpath[2:], '\\', '/', 'g'))
    endif
    let g:clipboard = {
        \ 'name': 'win32yank',
        \ 'copy': { '+': s:win32yank .' -i --crlf', '*': s:win32yank .' -i --crlf' },
        \ 'paste': { '+': s:win32yank .' -o --lf', '*': s:win32yank .' -o --lf' },
        \ 'cache_enabled': 0
        \ }
endif
