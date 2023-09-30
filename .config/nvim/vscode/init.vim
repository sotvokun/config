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
" -- Git Changes
nnoremap ]c <cmd>call VSCodeCall("workbench.action.editor.nextChange")<cr>
nnoremap [c <cmd>call VSCodeCall("workbench.action.editor.previousChange")<cr>

nnoremap ]q <cmd>call VSCodeCall("editor.action.marker.nextInFiles")<cr>
nnoremap ]q <cmd>call VSCodeCall("editor.action.marker.prevInFiles")<cr>
nnoremap ]b <cmd>call VSCodeCall("workbench.action.nextEditor")<cr>
nnoremap [b <cmd>call VSCodeCall("workbench.action.previousEditor")<cr>
nnoremap ]t <cmd>call VSCodeCall("workbench.action.focusNextGroup")<cr>
nnoremap [t <cmd>call VSCodeCall("workbench.action.focusPreviousGroup")<cr>

" - Misc
nnoremap <esc> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:redraw<cr>


" - LSP supports
nnoremap gR <cmd>call VSCodeCall("editor.action.rename")<cr>

" - Settings
" -- Clipboard
set clipboard+=unnamedplus
