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
unmap gc
xunmap gc
ounmap gc
unmap gcc

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine


" - Settings
" -- Clipboard
set clipboard+=unnamedplus
