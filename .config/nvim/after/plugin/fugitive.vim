" after/plugin/fugitive.vim - fugitive.vim configuration
"

if exists('g:loaded_fugitive_after')
	finish
endif
let g:loaded_fugitive_after = 1

nnoremap gs <nop>
nnoremap gS <cmd>Git stage %<cr>
nnoremap <leader>gg <cmd>Git<cr>
nnoremap <leader>gcc <cmd>Git commit<cr>
nnoremap <leader>gca <cmd>Git commit --amend<cr>
nnoremap <leader>gce <cmd>Git commit --amend --no-edit<cr>

augroup git#
	au!
	autocmd FileType fugitive*,git nnoremap <buffer> q <cmd>quit<cr>
	autocmd FileType fugitive*,git setlocal nonumber
augroup END
