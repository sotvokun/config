"===========================================================
"
" Svim Initialization
"
" Created: 2022-11-22
" Modified: 2022-11-22
"
"===========================================================

" Home
" -----------------------------
let g:svim_data = stdpath('data') . '/svim'
if !isdirectory(g:svim_data)
    call mkdir(g:svim_data, 'p')
endif


" Tiny mode
" -----------------------------
let g:svim_tinymode_token = g:svim_data . '/tinymode'
if filereadable(g:svim_tinymode_token)
    let g:svim_tinymode = v:true
endif


" Plugin manager
" -----------------------------
let g:svim_plugman_name = 'paqs'
let g:svim_plugman_path =
    \ stdpath('data')
    \ . printf('/site/pack/%s', g:svim_plugman_name)
let g:svim_has_plugman = v:false
if isdirectory(g:svim_plugman_path)
    let g:svim_has_plugman = v:true
endif

