if exists('g:loaded_dissession_after')
	finish
endif
let g:loaded_dissession_after = 1

nnoremap <expr> <leader>$
	\ dissession#check()
	\ ? "<cmd>call dissession#load()<cr>"
	\ : "<cmd>call dissession#save()<cr>"
