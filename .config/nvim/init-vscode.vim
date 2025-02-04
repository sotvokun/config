" init-vscode.vim - setup for vscode-neovim
"
" COMMAND:
"   :Load                       - Load a file in config home
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

"    Part: editor
"        - The bug of vscode-neovim output message is not fixed yet
"          set up the command line height to an enough value to
"          avoid too many messages that popup the output message
"          panel.
"          REF: https://stackoverflow.com/questions/78611905/turn-off-neovim-messages-in-vscode
set cmdheight=4

"    Part: clipboard
set clipboard=unnamedplus


" Section: Mapping
"    Part: foldding
nnoremap zc <cmd>call VSCodeNotify('editor.fold')<cr>
nnoremap zo <cmd>call VSCodeNotify('editor.unfold')<cr>

"    Part: window
nnoremap <c-j> <cmd>call VSCodeNotify('workbench.action.navigateDown')<cr>
nnoremap <c-k> <cmd>call VSCodeNotify('workbench.action.navigateUp')<cr>
nnoremap <c-h> <cmd>call VSCodeNotify('workbench.action.navigateLeft')<cr>
nnoremap <c-l> <cmd>call VSCodeNotify('workbench.action.navigateRight')<cr>

"    Part: tabpage
nnoremap ]t <cmd>call VSCodeNotify('workbench.action.nextEditorInGroup')<cr>
nnoremap [t <cmd>call VSCodeNotify('workbench.action.previousEditorInGroup')<cr>

"    Part: comment (same map as vim-commentary)
xmap gc <Plug>VSCodeCommentary
nmap gc <Plug>VSCodeCommentary
omap gc <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

"    Part: misc
nnoremap <silent> <esc> <cmd>nohlsearch<cr>
inoremap <c-s> <cmd>call VSCodeNotify('workbench.action.files.save')<cr>
nnoremap Q @q

"    Part: editting
nmap ]g <cmd>call VSCodeNotify('workbench.action.editor.nextChange')<cr>
nmap [g <cmd>call VSCodeNotify('workbench.action.editor.previousChange')<cr>


" COMMAND: Load
command! -nargs=1 Load execute printf('source %s/<args>', stdpath('config'))


" Section: Plugin Declaration
call plug#begin()

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-lion'
Plug 'hrsh7th/vim-vsnip'
Plug 'justinmk/vim-sneak'

if (has('mac') || has('win32')) && executable('im-select')
	Plug 'brglng/vim-im-select'
endif

call plug#end()


" Section: Plugins Setup
"    Part: vim-sneak
let g:sneak#label = 1
nnoremap f <Plug>Sneak_f
nnoremap F <Plug>Sneak_F
nnoremap t <Plug>Sneak_t
nnoremap T <Plug>Sneak_T
