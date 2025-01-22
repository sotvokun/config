" after/plugin/vsnip.vim - vsnip configuration
"

if exists('g:loaded_vsnip_after')
	finish
endif
let g:loaded_vsnip_after = 1

if has('nvim')
	let g:vsnip_snippet_dir = stdpath('config') . '/snippet'
endif

inoremap <expr> <c-]> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-]>'
snoremap <expr> <c-]> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-]>'
inoremap <expr> <c-}> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-}>'
snoremap <expr> <c-}> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-}>'
