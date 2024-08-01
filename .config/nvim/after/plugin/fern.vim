" after/plugin/fern.vim - fern.vim configuration
"

if exists('g:loaded_fern_after')
	finish
endif
let g:loaded_fern_after = 1


" Section: Settings

let g:fern#renderer#default#root_symbol = '~ '
let g:fern#renderer#default#leaf_symbol = '│ '
let g:fern#renderer#default#leading = '  '
let g:fern#renderer#default#collapsed_symbol = '+ '
let g:fern#renderer#default#expanded_symbol = '- '

let g:fern#disable_default_mappings = 1


" Section: Mappings
" References:
" - https://github.com/lambdalisue/fern.vim/wiki/Tips#close-fern-after-open

nnoremap <c-g>n <cmd>Fern . -drawer -toggle<cr>
nnoremap <Plug>(fern-close-drawer) <cmd>FernDo close -drawer -stay<cr>
