" bundle/integration.vim
"


" Section: tpope/vim-fugitive
"
Plug 'tpope/vim-fugitive'

nnoremap <leader>gg <cmd>G<cr>

augroup fugitive_setup
	au!
	autocmd FileType fugitive
		\ setlocal nowrap
		\ | nnoremap <buffer> q <cmd>quit<cr>
augroup END


" Section: diffview-plus
"
Plug 'dlyongemallo/diffview-plus.nvim',
	\ { 'on': ['DiffviewOpen', 'DiffviewToggle', 'DiffviewFileHistory', 'DiffviewDiffFiles', 'DiffviewLog' ] }

nnoremap <leader>gd <cmd>DiffviewToggle<cr>


" Section: airblade/vim-gitgutter
"
Plug 'airblade/vim-gitgutter'

nnoremap <silent> ]h <plug>(GitGutterNextHunk)
nnoremap <silent> [h <plug>(GitGutterPrevHunk)


" Section: voldikss/vim-floaterm
"
Plug 'voldikss/vim-floaterm'

highlight link Floaterm FloatermBorder

"    Part: lf wrapper
nnoremap <silent> <c-g>n <cmd>FloatermNew --title=lf --width=0.8 --height=0.8 --opener=edit lf<cr>
nnoremap <silent> <c-g>N <cmd>FloatermNew --title=lf --width=0.8 --height=0.8 --opener=edit lf -command='set hidden!' .<cr>

"    Part: lazygit wrapper
nnoremap <silent> <c-g>g <cmd>FloatermNew --title=lazygit --width=0.9 --height=0.9 lazygit<cr>


" Section: ibhagwan/fzf-lua
"
Plug 'ibhagwan/fzf-lua', { 'on': 'FzfLua' }

highlight link FzfLuaNormal NormalFloat
highlight link FzfLuaBorder NormalFloat
highlight link FzfLuaTitle NormalFloat

nnoremap <silent> <leader><c-p> <cmd>FzfLua<cr>
nnoremap <silent> <leader><leader> <cmd>FzfLua global<cr>
nnoremap <silent> <leader>f <cmd>FzfLua files<cr>
nnoremap <silent> <leader>b <cmd>FzfLua buffers<cr>
nnoremap <silent> <leader>% <cmd>FzfLua live_grep resume=true<cr>
nnoremap <silent> <leader>@ <cmd>FzfLua lsp_document_symbols<cr>
nnoremap <silent> <leader># <cmd>FzfLua lsp_workspace_symbols<cr>

lua << EOF
local fzf_lua_options = {
	winopts = {
		border = 'single',
		backdrop = 100,
		title_pos = 'left',
		title_flags = false,
		preview = {
			border = 'solid',
			layout = 'horizontal',
			title = false,
		}
	},
	fzf_colors = {
		true,
		['fg+'] = { 'fg', 'Normal' },
		['bg+'] = { 'bg', 'CursorLine' },
	},
}

local fzf_lua_setup_augroup =
	vim.api.nvim_create_augroup('fzf_lua_setup', { clear = true })
vim.api.nvim_create_autocmd('User', {
	pattern = 'fzf-lua',
	group = fzf_lua_setup_augroup,
	callback = function(ev)
		local fzflua = require('fzf-lua')
		fzflua.setup(fzf_lua_options)
		fzflua.register_ui_select()
	end
})
EOF
