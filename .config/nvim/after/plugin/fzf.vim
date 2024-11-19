" after/plugin/fzf.vim
"

if exists('g:loaded_fzf_after')
	finish
endif
let g:loaded_fzf_after = 1


" Mappings
nnoremap <leader>f <cmd>FzfLua files<cr>
nnoremap <leader>o <cmd>FzfLua oldfiles<cr>
nnoremap <leader>b <cmd>FzfLua buffers<cr>
nnoremap <leader>% <cmd>FzfLua live_grep<cr>
nnoremap <leader><leader> <cmd>FzfLua resume<cr>


" Function
function s:setup()
	let l:rg_opts = '--no-heading --no-ignore-vcs --hidden --glob=!.git/'
	lua require('fzf-lua').setup({
		\ fzf_colors = true,
		\ winopts = {
		\	border = 'none',
		\	backdrop = 45,
		\ },
		\ files = {
		\	rg_opts = '--no-heading --no-ignore-vcs --hidden --glob=!.git/'
		\ },
		\ grep = {
		\	rg_opts = '--no-heading --no-ignore-vcs --hidden --glob=!.git/'
		\ }
		\ })
endfunction


" autocmd
augroup fzf-init
	au!
	autocmd User fzf-lua call s:setup()
augroup END
