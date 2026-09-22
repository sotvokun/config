if has('nvim')
	let g:vsnip_snippet_dir = stdpath('config') . '/snippets'
else
	let g:vsnip_snippet_dir = Stdpath('config') . '/snippets'
endif

inoremap <expr> <c-]> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-]>'
snoremap <expr> <c-]> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-]>'
inoremap <expr> <c-}> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-}>'
snoremap <expr> <c-}> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-}>'
