" early.vim
"
" early.vim provides a new scheme for executing script earlily.
"
if exists('g:loaded_early')
	finish
endif
let g:loaded_early = 1

runtime! early/plugin/**/*.{vim,lua}
