" Pairs
augroup surround#
    au!
augroup END


" Sandwich Keymap
let g:sandwich_no_default_key_mappings = 1

nmap ys <Plug>(sandwich-add)
xmap ys <Plug>(sandwich-add)
omap ys <Plug>(sandwich-add)

nmap ds <Plug>(sandwich-delete)
xmap ds <Plug>(sandwich-delete)
nmap dsa <Plug>(sandwich-delete-auto)

nmap cs <Plug>(sandwich-replace)
xmap cs <Plug>(sandwich-replace)
nmap csa <Plug>(sandwich-replace-auto)
