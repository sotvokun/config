" bundle/lsp.vim
"

" Section: mason-org/mason
"
Plug 'mason-org/mason.nvim'
lua << EOF
local mason_options = {}
local mason_setup_augroup =
	vim.api.nvim_create_augroup('mason_setup', { clear = true })
vim.api.nvim_create_autocmd('User', {
	pattern = 'PlugEnd',
	group = 'mason_setup',
	callback = function ()
		local ok, mason = pcall(require, 'mason')
		if ok then
			mason.setup(mason_options)
		end
	end
})
EOF
