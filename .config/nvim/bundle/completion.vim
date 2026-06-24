" bundle/completion.vim
"

" Section: saghen/blink.cmp
"
Plug 'saghen/blink.cmp', { 'tag': 'v1.*', 'on': [] }
Plug 'https://codeberg.org/FelipeLema/bink-cmp-vsnip.git'

lua << EOF
local blink_options = {
	keymap = {
		preset = 'super-tab',

		-- Unset some keymaps of preset
		['<c-b>'] = { 'fallback' },
		['<c-f>'] = { 'fallback' },

		['<c-k>'] = { 'show_documentation', 'hide_documentation' },
		['<c-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
		['<c-u>'] = { 'scroll_documentation_up', 'fallback' },
		['<c-d>'] = { 'scroll_documentation_down', 'fallback' },
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
