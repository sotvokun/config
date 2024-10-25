" init-vscode.vim
"

if exists('g:loaded_vscode_init')
	finish
endif
let g:loaded_vscode_init = 1

command! -nargs=1 Load execute printf('source %s/<args>', stdpath('config'))

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

"    Part: Editting
nnoremap ]g <cmd>call VSCodeNotify('workbench.action.editor.nextChange')<cr>
nnoremap [g <cmd>call VSCodeNotify('workbench.action.editor.previousChange')<cr>


" Section: Plugins
"    Part: sneak

let g:sneak#label = 1
nnoremap f <Plug>Sneak_f
nnoremap F <Plug>Sneak_F
nnoremap t <Plug>Sneak_t
nnoremap T <Plug>Sneak_T

let g:pkg_manifest = stdpath('config') . '/pkg.code'

silent! Load module/pkg.vim

runtime after/plugin/vsnip.vim
