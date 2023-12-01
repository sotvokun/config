if exists('g:vscode') | finish | endif

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
