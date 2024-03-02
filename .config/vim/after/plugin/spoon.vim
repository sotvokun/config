if exists('g:loaded_spoon_after')
	finish
endif
let g:loaded_spoon_after = 1


" Section: Key mappings

nnoremap <leader>s <cmd>SpoonSave<cr>
nnoremap ]1 <cmd>SpoonNext<cr>
nnoremap [1 <cmd>SpoonPrev<cr>
nnoremap <leader>1 <cmd>SpoonSelect 1<cr>
nnoremap <leader>2 <cmd>SpoonSelect 2<cr>
nnoremap <leader>3 <cmd>SpoonSelect 3<cr>
nnoremap <leader>4 <cmd>SpoonSelect 4<cr>
nnoremap <leader>5 <cmd>SpoonSelect 5<cr>
nnoremap <leader>0 <cmd>SpoonClear<cr>
