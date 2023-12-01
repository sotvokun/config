" asession.vim
"
" asession.vim is a util plugin to make session management easier
"
" VARIABLES:
"   g:asession_ready            - 0 if no session file found, 1 otherwise
"   g:asession_session_file     - path to session file
"   g:asession_save_on_exit     - 1 to save session on exit, 0 otherwise
"
" USER COMMAND:
"   :ASessionLoad               - load session file only if session file found
"
" LIFETIME:
"   VimEnter                    - check if session file exists
"                                 if exists, set g:asession_ready to 1
"                                 and set g:asession_session_file to session
"                                 file path.
"   :ASessionLoad               - load session file, if g:asession_save_on_exit
"                                 is 1, set VimLeavePre autocmd to save session
"   VimLeavePre                 - save session file if g:asession_save_on_exit
"                                 is 1 and autocmd is set.

if exists('g:loaded_asession')
    finish
endif
let g:loaded_asession = 1

" Section: Variables
let g:asession_ready = 0
let g:asession_session_file = ''
let g:asession_save_on_exit = 1


" Section: User Commands

command! -nargs=0 ASessionLoad call s:load_session()


" Section: Auto Commands

augroup asession
    autocmd!
    autocmd VimEnter * call s:session_status()
augroup END


" Section: Functions

function! s:session_status()
    let cwd = getcwd()
    let session_file_name = 'Session.vim'
    let session_file_path = fnameescape(cwd . '/' . session_file_name)
    if !filereadable(session_file_path)
        return
    endif

    let g:asession_ready = 1
    let g:asession_session_file = session_file_path

    if g:asession_save_on_exit
        autocmd VimLeavePre * call s:save_session()
    endif
endfunction

function! s:save_session()
    if !g:asession_ready
        return
    endif

    execute 'mksession! ' . g:asession_session_file
endfunction

function! s:load_session()
    if !g:asession_ready
        echohl WarningMsg
        echomsg 'No session file found'
        echohl None
    endif

    execute 'source ' . g:asession_session_file
endfunction
