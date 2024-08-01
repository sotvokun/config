" after/plugin/undotree.vim - undotree configuration
"

if exists('g:loaded_undotree_after')
	finish
endif

nnoremap <silent><f10> <cmd>UndotreeToggle<cr>
