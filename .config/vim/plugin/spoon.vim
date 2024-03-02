" spoon.vim
"
" spoon.vim is a util plugin to manage recent used buffers and positions.
"
" VARIABLES:
"   g:spoon_data                    - The data of saved buf and position.
"   g:spoon_onbufdelete             - Disable spoon#delete_by_bufnr() when 0.
"                                     (DEFAULT: 1)
"   g:spoon_singlebuf               - No multiple position in the same buffer when 1.
"                                     (DEFAULT: 1)
"   g:spoon_update_bufpos           - Update the position of the saved buffer when BufLeave.
"                                     It will be disabled when g:spoon_singlebuf is 0.
"                                     (DEFAULT: 1)
"
" COMMANDS:
"   SpoonSave [mark]                - Save the buffer and position.
"                                     If [mark] is given, it will be used as the mark.
"   SpoonSelect <number>            - Switch to the saved buffer and position
"                                     by the index of g:spoon_data.
"   SpoonNext                       - Switch to the next saved buffer and position.
"   SpoonPrev                       - Switch to the previous saved buffer and position.
"   SpoonClear                      - Clear the saved buffer and position.
"   SpoonDelete                     - Delete the saved buffer and position by the current position.


if exists('g:loaded_spoon')
	finish
endif
let g:loaded_spoon = 1


" Section: Variables

let g:spoon_data = {}
let g:spoon_onbufdelete = get(g:, 'spoon_onbufdelete', 1)
let g:spoon_singlebuf = get(g:, 'spoon_singlebuf', 1)
let g:spoon_update_bufpos = get(g:, 'spoon_update_bufpos', 1)


" Section: Functions
function! s:list()
	let l:bufs = ''
	let l:keys = keys(g:spoon_data)
	for l:key in l:keys
		let l:index = index(l:keys, l:key) + 1
		let l:bufitem = g:spoon_data[l:key]
		let l:bufs .= printf("%d\t[%d]\t%s\t%d:%d\n",
			\ l:index,
			\ l:bufitem['bufnr'],
			\ l:bufitem['bufname'],
			\ l:bufitem['lnum'], l:bufitem['col'])
	endfor
	echo l:bufs
endfunction


" Section: Commands

command! -nargs=? SpoonSave call spoon#save(<f-args>)
command! -nargs=1 SpoonSelect call spoon#select(str2nr(<f-args>))
command! -nargs=1 SpoonDelete call spoon#delete_by_index(str2nr(<f-args>))
command! -nargs=0 SpoonNext call spoon#next()
command! -nargs=0 SpoonPrev call spoon#prev()
command! -nargs=0 SpoonList call s:list()
command! -nargs=0 SpoonClear call spoon#clear()


" Section: Autocmds

augroup spoon
	autocmd!
	autocmd BufDelete * if g:spoon_onbufdelete
		\ | call spoon#delete_by_bufnr(expand('<abuf>'))
		\ | endif
	autocmd BufLeave * if g:spoon_singlebuf == 0 && g:spoon_update_bufpos
		\ | call spoon#update_pos()
		\ | endif
augroup END
