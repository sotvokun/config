setlocal nonumber

nmap <buffer><silent> <Plug>(fern-action-open-and-close)
        \ <Plug>(fern-action-open)
        \ <Plug>(fern-close-drawer)

nnoremap <buffer> q <Plug>(fern-close-drawer)
nnoremap <buffer> h <Plug>(fern-action-collapse)
nnoremap <buffer> l <Plug>(fern-action-expand)
nnoremap <buffer> <cr> <Plug>(fern-action-open-and-close)
nnoremap <buffer> <c-e> <Plug>(fern-action-open:edit)
nnoremap <buffer> <c-s> <Plug>(fern-action-open:split)
nnoremap <buffer> <c-v> <Plug>(fern-action-open:vsplit)
nnoremap <buffer> <c-t> <Plug>(fern-action-open:tabedit)

nnoremap <buffer> g. <Plug>(fern-action-hidden:toggle)

nnoremap <buffer> r <Plug>(fern-action-rename)
nnoremap <buffer> d <Plug>(fern-action-remove=)
nnoremap <buffer> y <Plug>(fern-action-clipboard-copy)
nnoremap <buffer> x <Plug>(fern-action-clipboard-move)
nnoremap <buffer> p <Plug>(fern-action-clipboard-paste)
nnoremap <buffer> ! <Plug>(fern-action-clipboard-clear)

nnoremap <buffer> ga <Plug>(fern-action-new-file=)
nnoremap <buffer> gA <Plug>(fern-action-new-dir=)

nnoremap <buffer> Y <Plug>(fern-action-yank)
