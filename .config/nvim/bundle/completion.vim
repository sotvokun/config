" bundle/completion.vim
"

" Section: saghen/blink.cmp
"
Plug 'saghen/blink.cmp', { 'tag': '1.*', 'on': [] }
Plug 'https://codeberg.org/FelipeLema/bink-cmp-vsnip.git'

lua << EOF
local blink_options = {
	keymap = {
		preset = 'super-tab',
	},
	snippets = { preset = 'vsnip' },
	sources = {
		default = { 'buffer', 'path', 'snippets', 'lsp' },
	},
}
local blink_cmp_setup_augroup =
	vim.api.nvim_create_augroup('blink_cmp_setup', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
	group = blink_cmp_setup_augroup,
	callback = function ()
		vim.fn['plug#load']('blink.cmp')
		require('blink.cmp').setup(blink_options)
	end
})
EOF
