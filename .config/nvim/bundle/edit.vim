" bundle/edit.vim
"

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-sleuth'


" Section: vim-sneak
"
Plug 'justinmk/vim-sneak'

let g:sneak#label = 1
nnoremap f <Plug>Sneak_f
nnoremap F <Plug>Sneak_F
nnoremap t <Plug>Sneak_t
nnoremap T <Plug>Sneak_T


" Section: vim-vsnip
"
Plug 'hrsh7th/vim-vsnip'

if has('nvim')
	let g:vsnip_snippet_dir = stdpath('config') . '/snippets'
else
	let g:vsnip_snippet_dir = Stdpath('config') . '/snippets'
endif

inoremap <expr> <c-]> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-]>'
snoremap <expr> <c-]> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-]>'
inoremap <expr> <c-}> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-}>'
snoremap <expr> <c-}> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-}>'


" Section: switch.vim
"
Plug 'AndrewRadev/switch.vim'

let g:switch_mapping = ''
let g:switch_no_builtins = 1

nnoremap <c-x>s <cmd>call switch#Switch()<cr>
nnoremap <c-x>S <cmd>call switch#Switch({'reverse': 1})<cr>
