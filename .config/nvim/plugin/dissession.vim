" dissession.vim
"
" dissession.vim is a util plugin to make session management easier
"
" VARIABLES:
"   g:dissession_dir            - path to session file directory
"   g:dissession_ready          - 0 if no session file found, 1 otherwise
"   g:dissession_session_file   - path to current session file
"   g:dissession_save_on_exit   - 1 to save session on exit, 0 otherwise
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

let g:dissession_ready = 0
let g:dissession_session_file = ''
let g:dissession_save_on_exit = 1
if !exists('g:dissession_dir')
	let g:dissession_dir = has('nvim')
		\ ? stdpath('state') . '/sessions'
		\ : $HOME . '/.vim/sessions'
endif


" Section: User Commands

command! -nargs=0 DissessionSave call dissession#save()
command! -nargs=0 DissessionLoad call dissession#load()
command! -nargs=0 DissessionPrune call dissession#prune()


" Section: Auto Commands

augroup dissession
	autocmd!
	autocmd VimEnter * call dissession#check()
	autocmd VimLeavePre * 
		\ if dissession#check() && g:dissession_save_on_exit
		\ | call dissession#save()
		\ | endif
augroup END
