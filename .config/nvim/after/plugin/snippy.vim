imap <expr> <c-]> snippy#can_expand_or_advance() ? '<Plug>(snippy-expand-or-advance)' : '<c-]>'
imap <expr> <c-}> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<c-}>'
smap <expr> <c-]> snippy#can_jump(1) ? '<Plug>(snippy-next)' : '<c-]>'
smap <expr> <c-}> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<c-}>'
xmap <c-]> <Plug>(snippy-cut-text)
