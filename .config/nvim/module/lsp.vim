" module/lsp.vim - the LSP setup
"

if if exists('g:loaded_module_lsp')
	finish
endif
let g:loaded_module_lsp = 1

let g:vlsp_local_config = '.vscode/vlsp.json'

silent! call vlsp#begin()
silent! LspLoadConfig
silent! call vlsp#end()
