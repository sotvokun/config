" init-vscode.vim - setup for vscode-neovim
"

if exists('g:loaded_vscode_init')
	finish
endif
let g:loaded_vscode_init = 1


" Section: Options
"    Part: general
syntax clear
syntax off
set syntax=OFF

"    Part: clipboard
set clipboard=unnamedplus


" Section: Mapping
"    Part: Leader
nnoremap <space> <nop>
let g:mapleader = ' '

"    Part: release some keybindings
"          make <c-x> as the secondary leader
"          fallback setup
nnoremap <c-g> <nop>
nnoremap <c-x> <nop>
nnoremap <c-x><c-g> <cmd>:file<cr>
nnoremap <c-x><c-a> <c-a>
nnoremap <c-x><c-x> <c-x>

"    Part: window
nnoremap <c-j> <cmd>call VSCodeNotify('workbench.action.navigateDown')<cr>
nnoremap <c-k> <cmd>call VSCodeNotify('workbench.action.navigateUp')<cr>
nnoremap <c-h> <cmd>call VSCodeNotify('workbench.action.navigateLeft')<cr>
nnoremap <c-l> <cmd>call VSCodeNotify('workbench.action.navigateRight')<cr>

"    Part: comment (same map as vim-commentary)
xmap gc <Plug>VSCodeCommentary
nmap gc <Plug>VSCodeCommentary
omap gc <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

"    Part: vscode
"
nnoremap <leader><leader> <cmd>call VSCodeNotify('workbench.action.quickOpen')<cr>
nnoremap <leader>f <cmd>call VSCodeNotify('workbench.action.quickOpen')<cr>
nnoremap <leader>b <cmd>call VSCodeNotify('workbench.action.showAllEditors')<cr>
nnoremap <leader>% <cmd>call VSCodeNotify('workbench.action.quickTextSearch')<cr>
nnoremap <leader>@ <cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>
nnoremap <leader># <cmd>call VSCodeNotify('workbench.action.showAllSymbols')<cr>
nnoremap <leader>1 <cmd>call VSCodeNotify('workbench.action.openView')<cr>

"    Part: misc
"  unimpaired
nnoremap ]t <cmd>call VSCodeNotify('workbench.action.nextEditorInGroup')<cr>
nnoremap [t <cmd>call VSCodeNotify('workbench.action.previousEditorInGroup')<cr>

"  better indenting
vnoremap < <gv
vnoremap > >gv

" replay @q macro
nnoremap Q @q

" <esc> disable highlight and redraw
nnoremap <silent> <esc> <cmd>nohlsearch<bar>diffupdate<bar>redraw<cr>

" mark search position
nnoremap / ms/
nnoremap ? ms?

" git related
nnoremap ]c <cmd>call VSCodeNotify('workbench.action.editor.nextChange')<cr>
nnoremap [c <cmd>call VSCodeNotify('workbench.action.editor.previousChange')<cr>


" Section: Plugin Declaration
"
call bundle#begin()
Import bundle/edit.vim
call bundle#end()
