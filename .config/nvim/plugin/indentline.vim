" indentline.vim
"
" indentline.vim is a simple plugin to display the indention levels with
" builtin listchars feature.
"
" REFERENCE:
"   https://www.reddit.com/r/neovim/comments/18d6yb6/use_the_builtin_listchars_option_to_implement/
"
" VARIABLES:
"   g:indentline_ignore_ft            a list of filetypes that do not show
"                                     indentline.
"                                     (default:
"                                        ['diff', 'gitcommit', 'qf', 'help'])
"   g:indentline_char                 the character used to display the
"                                     indention levels.
"                                     (default: '┆')
"
"   g:indentline_space_char           the character used to display the
"                                     indention levels when 'expandtab' is
"                                     not set.
"                                     (default: '·')
"

if exists('g:loaded_indentline')
	finish
endif
let g:loaded_indentline = 1


" Section: variables

if !exists('g:indentline_char')
	let g:indentline_char = '┆'
endif

if !exists('g:indentline_space_char')
	let g:indentline_space_char = '·'
endif

if !exists('g:indentline_ignore_ft')
	let g:indentline_ignore_ft = ['diff', 'gitcommit', 'qf', 'help']
endif


" Section: functions

function! s:escape_string(value)
	let escaped_value = ''
	for char in split(a:value, '\zs')
		if char =~ '\s'
			let escaped_value .= '\ '
		elseif len(char) > 1
			let escaped_value .= '\' . char
		else
			let escaped_value .= char
		endif
	endfor
	return escaped_value
endfunction

function! s:update_listchars(items)
	let listchars = &listchars
	for [item, val] in items(a:items)
		let item_pattern = escape(item, '\')
		if match(listchars, item_pattern . ':') != -1
			let listchars = substitute(listchars, '\('.item_pattern.':\)[^,]*', '\1'.val, '')
		else
			let listchars .= ',' . item . ':' . val
		endif
	endfor
	return s:escape_string(listchars)
endfunction

function! s:update(is_local)
	if index(g:indentline_ignore_ft, &ft) != -1
		return
	endif
	let new_listchars = ''
	if &expandtab
		let spaces = &shiftwidth
		if spaces == 0
			let spaces = &tabstop
		endif
		let new_listchars = s:update_listchars({
			\ 'leadmultispace': g:indentline_char . repeat(' ', spaces - 1)
			\ })
	else
		let new_listchars = s:update_listchars({
			\ 'leadmultispace': g:indentline_space_char
			\ })
	endif
	execute printf('set%s! listchars=%s', a:is_local ? 'local' : '', new_listchars)
endfunction


" Section: autocmd

augroup indentline
	autocmd!
	autocmd OptionSet shiftwidth,tabstop,expandtab
		\ call <SID>update(v:option_type == 'local')
augroup END
