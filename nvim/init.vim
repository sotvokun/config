"===========================================================
"
" Svim
"
" Created: 2022-11-22
" Modified: 2022-11-23
"
"===========================================================

command! -nargs=1 -complete=file
    \ RequireSource
    \ execute 'source ' . fnameescape(stdpath('config') . '/<args>')

" Tiny mode
" -----------------------------
RequireSource init-tiny.vim
RequireSource init/svim.vim

" Enhanced mode
" -----------------------------
let g:svim_bundles = [
    \ 'core',
    \ 'coc',
    \ 'telescope',
    \ 'lualine',
    \ 'intelligent',
    \ 'treesitter',
    \ 'util',
    \ 'web',
    \ 'lisp',
    \ 'colors'
    \ ]
if !exists('g:svim_tinymode') || !g:svim_tinymode
    RequireSource init/bootstrap.vim
endif

delcommand RequireSource
