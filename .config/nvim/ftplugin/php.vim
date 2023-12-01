if exists('b:did_ftplugin')
    finish
endif

call LspRegister({
    \ 'name': 'intelephense',
    \ 'filetypes': ['php'],
    \ 'cmd': ['intelephense', '--stdio'],
    \ 'root_pattern': ['composer.json']
    \ })
