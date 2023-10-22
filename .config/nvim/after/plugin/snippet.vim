" snippet.vim
"
" - vsnip

let g:vsnip_snippet_dir = stdpath('config') . '/snippets'

inoremap <expr> <c-]> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-]>'
snoremap <expr> <c-]> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<c-]>'
inoremap <expr> <c-}> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-}>'
snoremap <expr> <c-}> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<c-}>'
