" Section: Mods
execute 'source ' . $VIM_USER_HOME . '/mod/clipboard.vim'


" Section: Mapping
"    Part: Foldding
nnoremap zc <cmd>call VSCodeNotify('editor.fold')<cr>
nnoremap zo <cmd>call VSCodeNotify('editor.unfold')<cr>

"    Part: Window
nnoremap <c-j> <cmd>call VSCodeNotify('workbench.action.navigateDown')<cr>
nnoremap <c-k> <cmd>call VSCodeNotify('workbench.action.navigateUp')<cr>
nnoremap <c-h> <cmd>call VSCodeNotify('workbench.action.navigateLeft')<cr>
nnoremap <c-l> <cmd>call VSCodeNotify('workbench.action.navigateRight')<cr>

"    Part: Tabpage
nnoremap ]t <cmd>call VSCodeNotify('workbench.action.nextEditorInGroup')<cr>
nnoremap [t <cmd>call VSCodeNotify('workbench.action.previousEditorInGroup')<cr>

"    Part: Comment (same map as vim-commentary)
xmap gc <Plug>VSCodeCommentary
nmap gc <Plug>VSCodeCommentary
omap gc <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

"    Part: Misc
nnoremap <silent> <esc> <cmd>nohlsearch<cr>
inoremap <c-s> <cmd>call VSCodeNotify('workbench.action.files.save')<cr>
nnoremap Q @q

"    Part: UI
nnoremap <c-g>n <cmd>call VSCodeNotify('workbench.view.explorer')<cr>


" Section: Plugins
if exists('g:loaded_vscode_init')
	finish
endif
let g:loaded_vscode_init = 1

call plug#begin()
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-lion'
Plug 'justinmk/vim-sneak'
Plug 'hrsh7th/vim-vsnip'
call plug#end()

runtime after/plugin/vsnip.vim
