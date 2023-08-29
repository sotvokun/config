" ------------------------------------------------
"  init-vscode.vim
"  Created:  2023-07-25
"  Modified: 2023-07-25
" ------------------------------------------------

" - Editing
" -- Better indenting
vnoremap < <gv
vnoremap > >gv

" -- Move selected line and block
xnoremap <a-j> <cmd>m '>+1<cr>gv-gv
xnoremap <a-k> <cmd>m '<-2<cr>gv-gv

" - Sensible
nnoremap ]b <cmd>bn<cr>
nnoremap [b <cmd>bp<cr>
nnoremap ]t <cmd>tabnext<cr>
nnoremap [t <cmd>tabprev<cr>
