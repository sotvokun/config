let g:switch_mapping = ''
let g:switch_no_builtins = 1

nnoremap <c-x>s <cmd>call switch#Switch()<cr>
nnoremap <c-x>S <cmd>call switch#Switch({'reverse': 1})<cr>
