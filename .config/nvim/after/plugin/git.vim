" git.vim
"
" - vim-fugitive
" - gitsigns.nvim

if exists('g:vscode')
    finish
endif

let g:gitgutter_map_keys = 0

nnoremap ]g <Plug>(GitGutterNextHunk)
nnoremap [g <Plug>(GitGutterPrevHunk)

nnoremap <leader>gs <Plug>(GitGutterStageHunk)
nnoremap <leader>gu <Plug>(GitGutterUndoHunk)
nnoremap <leader>gS <cmd>Git stage %<cr>

nnoremap <leader>gg <cmd>Git<cr>
nnoremap <leader>gcc <cmd>Git commit<cr>
nnoremap <leader>gca <cmd>Git commit --amend<cr>
nnoremap <leader>gce <cmd>Git commit --amend --no-edit<cr>

augroup git#
    au!
    autocmd FileType fugitive*,git
            \ nnoremap <buffer> q <cmd>quit<cr>
            \ | setlocal nonumber
augroup END

" vim: et sw=4
