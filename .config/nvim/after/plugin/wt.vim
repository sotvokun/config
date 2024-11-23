" after\plugin\wt.vim
"


if exists('g:wt_after_loaded')
	finish
endif
let g:wt_after_loaded = 1

if !exists(':Wt')
	finish
endif


nnoremap <c-a><c-a> <c-a>

nnoremap <c-a>c <cmd>Wt new-tab<cr>
nnoremap <c-a>[ <cmd>Wt focus-tab -p<cr>
nnoremap <c-a>] <cmd>Wt focus-tab -n<cr>

nnoremap <c-a><bar> <cmd>Wt split-pane -V<cr>
nnoremap <c-a>- <cmd>Wt split-pane -H<cr>
nnoremap <c-a>h <cmd>Wt move-focus left<cr>
nnoremap <c-a>l <cmd>Wt move-focus right<cr>
nnoremap <c-a>k <cmd>Wt move-focus up<cr>
nnoremap <c-a>j <cmd>Wt move-focus down<cr>

for i in range(0, 9)
	execute printf('nnoremap <c-a>%d <cmd>Wt focus-tab -t %d<cr>', i, i)
endfor
