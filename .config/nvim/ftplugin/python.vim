call LspRegister({
    \ 'name': 'pyright',
    \ 'filetypes': ['python'],
    \ 'cmd': ['pyright-langserver', '--stdio'],
    \ 'root_pattern': ['.git', 'setup.py', 'setup.cfg', 'requirements.txt'],
    \ 'settings': {
    \   'python': {
    \       'analysis': {
    \           'autoSearchPaths': v:true,
    \           'useLibraryCodeForTypes': v:true,
    \           'diagnosticMode': 'openFilesOnly',
    \       },
    \   },
    \ },
    \ })
