" flashyanked.vim
"
" flashyanked.vim is a plugin that highlight the yanked text
"
" VARIABLES:
"   g:flashyanked_higroup       - the highligh group to show the yanked
"   g:flashyanked_timeout       - the timeout millseconds to show highlight
"
" NOTE:
"   For neovim, this plugin will register TextYankPost event to neovim
"   builtin solution.
"
" REFERENCE:
" https://www.statox.fr/posts/2020/07/vim_flash_yanked_text/
"

if exists('g:loaded_flashyanked')
	finish
endif
let g:loaded_flashyanked = 1

let g:flashyanked_higroup = 'Visual'
let g:flashyanked_timeout = 150

let s:yanked_text_matches = []

function! s:DeleteTemporaryMatch(timer_id)
	while !empty(s:yanked_text_matches)
		let match = remove(s:yanked_text_matches, 0)
		let window_id = match[0]
		let match_id = match[1]
		try
			call matchdelete(match_id, window_id)
		endtry
	endwhile
endfunction

function! FlashYankedText()
	let match_id = matchadd(g:flashyanked_higroup, ".\\%>'\\[\\_.*\\%<']..")
	let window_id = winnr()
	call add(s:yanked_text_matches, [window_id, match_id])
	call timer_start(
		\ g:flashyanked_timeout, 
		\ function('s:DeleteTemporaryMatch'))
endfunction

augroup flashyanked
	au!
	if has('nvim')
		autocmd TextYankPost * 
			\ silent! lua vim.highlight.on_yank({
			\ higroup=vim.g.flashyanked_higroup,
			\ timeout=vim.g.flashyanked_timeout,
			\ on_visual=true
			\ })
	else
		autocmd TextYankPost * silent! call FlashYankedText()
	endif
augroup END
