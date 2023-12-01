if exists('g:vscode') | finish | endif


" Section: Mappings

nnoremap <leader>f <cmd>Files<cr>
nnoremap <leader>o <cmd>History<cr>
nnoremap <leader>b <cmd>Buffers<cr>
nnoremap <leader>% <cmd>RG<cr>


" Section: Commands

command! -nargs=0 Vsnip call fzf#ext#vsnip()


" Section: Functions
function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction


" Section: Settings

if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden --glob "!.git/*"'
    let $FZF_DEFAULT_OPTS = '--layout=reverse --preview-window=border-sharp --bind ctrl-a:select-all,ctrl-d:deselect-all'
endif

let g:fzf_layout = { 'down': '45%' }
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit',
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ }

let g:fzf_colors = { 
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }


" Section: Auto commands
autocmd! FileType fzf set laststatus=0 noshowmode noruler
    \ | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
