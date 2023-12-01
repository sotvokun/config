" Section: Basic keymap
"    Part: Leader-Key
nnoremap <space> <nop>
let g:mapleader=' '

"    Part: Fix keymap behavior
nnoremap zc <cmd>call VSCodeCall('editor.fold')<cr>
nnoremap zo <cmd>call VSCodeCall('editor.unfold')<cr>

"    Part: Git
noremap <leader>gs <cmd>call VSCodeCall('git.stageSelectedRanges')<cr>
noremap <leader>gu <cmd>call VSCodeCall('git.unstageSelectedRanges')<cr>
nnoremap ]g <cmd>call VSCodeCall("workbench.action.editor.nextChange")<cr>
nnoremap [g <cmd>call VSCodeCall("workbench.action.editor.previousChange")<cr>

"    Part: VsCodeCommentary Instead vim-commentary
xmap gc <Plug>VSCodeCommentary
nmap gc <Plug>VSCodeCommentary
omap gc <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

"    Part: Sensible
nnoremap ]t <cmd>call VSCodeCall('workbench.action.nextEditorInGroup')<cr>
nnoremap [t <cmd>call VSCodeCall('workbench.action.previousEditorInGroup')<cr>

"    Part: Window
nnoremap <c-j> :call VSCodeNotify('workbench.action.navigateDown')<cr>
nnoremap <c-k> :call VSCodeNotify('workbench.action.navigateUp')<cr>
nnoremap <c-h> :call VSCodeNotify('workbench.action.navigateLeft')<cr>
nnoremap <c-l> :call VSCodeNotify('workbench.action.navigateRight')<cr>

"    Part: Misc
" <esc> refresh, dsiable highlight
nnoremap <silent> <esc> <cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>syntax sync fromstart<cr><cmd>redraw<cr>

" save file with ctrl-s
inoremap <c-s> <cmd>call VSCodeCall('workbench.action.files.save')<cr>

" to make <c-g> more useful, to set <c-g> to <c-g><c-g>
nnoremap <c-g> <nop>
nnoremap <c-g><c-g> <cmd>file<cr>


" Section: Clipboard

set clipboard+=unnamedplus
if has('win32') || has('wsl')
    let s:win32yank = 'win32yank'
    if has('wsl')
        let s:win32yank_winpath = system('/mnt/c/Windows/System32/where.exe win32yank')
        let s:win32yank = 
            \ '/mnt/c' . trim(substitute(s:win32yank_winpath[2:], '\\', '/', 'g'))
    endif
    let g:clipboard = {
        \ 'name': 'win32yank',
        \ 'copy': { '+': s:win32yank .' -i --crlf', '*': s:win32yank .' -i --crlf' },
        \ 'paste': { '+': s:win32yank .' -o --lf', '*': s:win32yank .' -o --lf' },
        \ 'cache_enabled': 0
        \ }
endif


" Section: Autocmds

augroup vscode#
    au!
augroup END

" vim: expandtab shiftwidth=4
