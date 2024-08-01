" module/neovide.vim - the neovide setup
"

set guifont=Sarasa\ Mono\ SC:h16
let g:neovide_floating_shadow = v:false

if g:colors_name ==# 'mercury'
	" set background by current hour
	if strftime('%H') < 6 || strftime('%H') >= 18
		set background=dark
	else
		set background=light
	endif
endif

let g:neovide_cursor_animation_length = 0.05
let g:neovide_cursor_trail_size = 0.2
let g:neovide_scroll_animation_length = 0.1
