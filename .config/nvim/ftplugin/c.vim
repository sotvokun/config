if exists('b:did_ftplugin')
    finish
endif

let clangd_cmd = ['clangd', '--compile-commands-dir=build']

call LspRegister({
    \ 'name': 'clangd',
    \ 'filetypes': ['c', 'cpp'],
    \ 'cmd': clangd_cmd
    \ })
