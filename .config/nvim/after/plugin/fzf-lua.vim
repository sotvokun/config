highlight link FzfLuaNormal NormalFloat
highlight link FzfLuaBorder NormalFloat
highlight link FzfLuaTitle NormalFloat

nnoremap <silent> <leader><leader> <cmd>FzfLua global<cr>
nnoremap <silent> <leader>f <cmd>FzfLua files<cr>
nnoremap <silent> <leader>b <cmd>FzfLua buffers<cr>
nnoremap <silent> <leader>t <cmd>FzfLua tabs<cr>
nnoremap <silent> <leader>% <cmd>FzfLua live_grep<cr>
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

local ok, fzflua = pcall(require, 'fzf-lua')
if not ok then
	return
end
fzflua.setup(fzf_lua_options)
fzflua.register_ui_select()
EOF
