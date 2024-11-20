" dissession.vim
"
" dissession.vim is a util plugin to make session management easier
"
" VARIABLES:
"   g:dissession_dir            - path to session file directory
"                                          nvim: stdpath('state')/sessions,
"                                           vim: $HOME/.vim/sessions
"                                    vim(win32): $USERPROFILE/vimfiles/sessions
"   g:dissession_load_on_enter  - 1 to load session on enter, 0 otherwise
"                                   (default: 1)
"   g:dissession_save_on_exit   - 1 to save session on exit, 0 otherwise
"                                   (default: 1)
"
" COMMANDS:
"   DissessionSave              - save session file
"   DissessionLoad              - load session file only if session file found
"   DissessionPrune             - delete current session file
"

if exists('g:loaded_dissession')
	finish
endif
let g:loaded_dissession = 1


" Section: Variables

let g:dissession__ready = 0
let g:dissession__session_file = ''

if !exists('g:dissession_load_on_enter')
	let g:dissession_load_on_enter = 1
endif
if !exists('g:dissession_save_on_exit')
	let g:dissession_save_on_exit = 1
endif
if !exists('g:dissession_dir')
	let g:dissession_dir = has('nvim')
		\ ? stdpath('state') . '/sessions'
		\ : (has('win32') ? $USERPROFILE.'/vimfiles/sessions' : $HOME.'/.vim/sessions')
endif


" Section: User Commands

command! -nargs=0 DissessionSave call dissession#save()
command! -nargs=0 DissessionLoad call dissession#load()
command! -nargs=0 DissessionPrune call dissession#prune()


" Section: Auto Commands

augroup dissession
	autocmd!
	autocmd VimEnter *
		\ call dissession#check()
		\ | if g:dissession__ready && g:dissession_load_on_enter
		\ | call dissession#load()
		\ | endif
	autocmd VimLeavePre * 
		\ if dissession#check() && g:dissession_save_on_exit
		\ | call dissession#save()
		\ | endif
augroup END
