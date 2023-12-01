if exists('b:did_ftplugin')
    finish
endif

if !exists('g:python_venv_bin') || empty(g:python_venv_bin) || !filereadable(g:python_venv_bin)
    let cwd = getcwd()
    for path in ['venv', '.venv', 'env', '.env']
        let venv_path = fnameescape(cwd . '/' . path)
        if !isdirectory(venv_path)
            continue
        endif
        let result = v:lua.vim.fs.find('python', { 'path': venv_path })
        if empty(result)
            continue
        endif

        let g:python_venv_path = venv_path
        let g:python_venv_bin = result[0]
        let python_venv_bin_dir = fnamemodify(g:python_venv_bin, ':p:h')

        let $VIRTUAL_ENV = g:python_venv_path
        if has('win32')
            let $PATH = python_venv_bin_dir . ';' . $PATH
        else
            let $PATH = python_venv_bin_dir . ':' . $PATH
        endif
        break
    endfor
endif

let python_settings = {
    \       'analysis': {
    \           'autoSearchPaths': v:true,
    \           'useLibraryCodeForTypes': v:true,
    \           'diagnosticMode': 'openFilesOnly',
    \       }
    \ }

if exists('g:python_venv_bin') && !empty(g:python_venv_bin) && filereadable(g:python_venv_bin)
    let python_settings['pythonPath'] = g:python_venv_bin
    let python_settings['venvPath'] = g:python_venv_path
endif

call LspRegister({
    \ 'name': 'pyright',
    \ 'filetypes': ['python'],
    \ 'cmd': ['pyright-langserver', '--stdio'],
    \ 'root_pattern': ['.git', '.venv', 'setup.py', 'setup.cfg', 'requirements.txt', 'pyrightconfig.json', 'pyproject.toml'],
    \ 'settings': {
    \   'python': python_settings,
    \ },
    \ })
