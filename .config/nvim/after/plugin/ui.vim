" after/plugin/ui.vim - vim-quickui and vim-navigator configuration
"

if exists('g:loaded_ui_after')
	finish
endif
let g:loaded_ui_after = 1

" QuickUI

let g:quickui_show_tip = 1
let g:quickui_border_style = 3


" Navigator

let g:navigator = {'prefix': '<leader>?'}

" Part: Git
let g:navigator.g = {
	\ 'name': '+git',
	\ 'S': [':Git stage %', 'stage-whole-file'],
	\ 'g': [':Git', 'fugitive'],
	\ 'p': [':Git push', 'push'],
	\ 'P': [':Git pull', 'pull'],
	\ 'v': [':GV', 'gv'],
	\ }

let g:navigator.g.c = {
	\ 'name': '+commit',
	\ 'c': [':Git commit', 'commit'],
	\ 'a': [':Git commit --amend', 'amend'],
	\ 'A': [':Git commit --amend --no-edit', 'amend-no-edit']
	\ }

let g:navigator.g.s = {
	\ 'name': '+stage',
	\ 's': [':GitGutterStageHunk', 'stage-hunk'],
	\ 'x': [':GitGutterUndoHunk', 'undo-hunk'],
	\ 'p': [':GitGutterPreviewHunk', 'preview-hunk'],
	\ }

" Part: FZF
let g:navigator['f'] = [':Files', 'fzf-files']
let g:navigator['o'] = [':History', 'fzf-history']
let g:navigator['b'] = [':Buffers', 'fzf-buffers']
let g:navigator['%'] = [':RG', 'fzf-rg']

let g:navigator['s'] = [':lua vim.lsp.buf.document_symbol()', 'lsp-document-symbol']
let g:navigator['S'] = [':lua vim.lsp.buf.workspace_symbol()', 'lsp-workspace-symbol']
let g:navigator['d'] = [':LspDiagnostics', 'lsp-diagnostics']
let g:navigator['D'] = [':LspDiagnosticsAll', 'lsp-diagnostics-all']


let g:navigator['<cr>'] = ['call quickui#menu#open()', 'quickui-menu']

nnoremap <silent><leader>? :Navigator g:navigator<CR>
