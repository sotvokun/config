" Section: Common

function! s:warn(message)
    echohl WarningMsg
    echomsg a:message
    echohl None
endfunction!

" Section: vsnip

function! s:inject_snippet(line)
    execute 'normal! a' . a:line . "\<c-r>=vsnip#expand()\<cr>\<bs>"
endfunction

function! fzf#ext#vsnip(...)
    if !exists(':VsnipOpenEdit')
        return s:warn('vsnip not found')
    endif
    let l:snippets = flatten(vsnip#source#find(bufnr('%')))
    if empty(l:snippets)
        return s:warn('no snippets available here')
    endif
    let lists = map(l:snippets, {i, val -> printf('%s', val['label'])})
    return fzf#run(fzf#wrap({
        \ 'source': lists,
        \ 'options': '+m --ansi --prompt="vsnip> " --preview="echo {1}"',
        \ 'sink': function('s:inject_snippet'),
        \ }))
endfunction

" vim: et sw=4
