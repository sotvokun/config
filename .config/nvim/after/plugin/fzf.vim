" after/plugin/fzf.vim - fzf.vim configuration
"

if exists('g:loaded_fzf_after')
	finish
endif
let g:loaded_fzf_after = 1


let s:rg_command = 'rg --column --line-number --no-heading --color=always --smart-case --hidden --no-ignore-vcs --glob=!.git/ -- '

" Section: Mappings

nnoremap <leader>f <cmd>Files<cr>
nnoremap <leader>o <cmd>History<cr>
nnoremap <leader>b <cmd>Buffers<cr>
nnoremap <leader>% <cmd>RG<cr>


" Section: Commands

command! -nargs=0 Vsnip call fzf#ext#vsnip()
command! -bang -nargs=* RG call fzf#vim#grep2(s:rg_command, <q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* Rg call fzf#vim#grep(s:rg_command.fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)

" Section: Functions

function! s:build_quickfix_list(lines)
	call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
	copen
	cc
endfunction


" Section: Settings

" FIX THE COLORSCHEME MATCHING ON WINDOWS
" REFERENCE: https://github.com/junegunn/fzf.vim/issues/1152#issuecomment-1295758951
if has('win32')
	let g:fzf_force_termguicolors = 1
	let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(green)%cr"'
endif

if executable('rg')
	let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden --glob=!.git/'
	let $FZF_DEFAULT_OPTS = '--layout=reverse --preview-window=border-sharp --bind ctrl-a:select-all,ctrl-d:deselect-all'
endif

let g:fzf_layout = { 'down': '45%' }
let g:fzf_action = {
	\ 'ctrl-q': function('s:build_quickfix_list'),
	\ 'ctrl-t': 'tab split',
	\ 'ctrl-s': 'split',
	\ 'ctrl-v': 'vsplit',
	\ }

let g:fzf_colors = {
	\ 'fg':      ['fg', 'Normal'],
	\ 'bg':      ['bg', 'Normal'],
	\ 'hl':      ['fg', 'Comment'],
	\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
	\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
	\ 'hl+':     ['fg', 'Todo'],
	\ 'info':    ['fg', 'PreProc'],
	\ 'border':  ['fg', 'Ignore'],
	\ 'prompt':  ['fg', 'Conditional'],
	\ 'pointer': ['fg', 'Exception'],
	\ 'marker':  ['fg', 'Keyword'],
	\ 'spinner': ['fg', 'Label'],
	\ 'header':  ['fg', 'Comment'] }


" Section: Auto commands
"    NOTE: Disable statusline
autocmd! FileType fzf set laststatus=0 noshowmode noruler
	\ | autocmd BufLeave <buffer> set laststatus=2 showmode ruler


" Section: LSP integration

lua (function()
	\ local to_qflist_item = function(str)
	\	local filename, lnum, col, text = str:match('([^:]+):(%d+):(%d+):(.+)')
	\	if filename and lnum and col and text then
	\		return {
	\			filename = filename,
	\			lnum = tonumber(lnum),
	\			col = tonumber(col),
	\			text = text
	\		}
	\	end
	\ end
	\ local build_quickfix_list = function(lines)
	\	vim.fn.setqflist(vim.tbl_map(function(line)
	\		return to_qflist_item(line)
	\	end, lines))
	\	vim.cmd('copen')
	\ end
	\ local ok, lspfuzzy = pcall(require, 'lspfuzzy')
	\ if not ok then
	\	return
	\ end
	\ lspfuzzy.setup({
	\	fzf_action = {
	\		['ctrl-q'] = build_quickfix_list,
	\		['ctrl-t'] = 'tab split',
	\		['ctrl-s'] = 'split',
	\		['ctrl-v'] = 'vsplit'
	\	}
	\ })
	\ end)()
