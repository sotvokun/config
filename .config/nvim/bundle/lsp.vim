" bundle/lsp.vim
"

" Section: mason-org/mason
"
Plug 'mason-org/mason.nvim', { 'on': 'Mason' }
lua << EOF
local mason_options = {}
local mason_setup_augroup =
	vim.api.nvim_create_augroup('mason_setup', { clear = true })
vim.api.nvim_create_autocmd('User', {
	pattern = 'PlugEnd',
	callback = function ()
		require('mason').setup(mason_options)
	end
})
EOF
