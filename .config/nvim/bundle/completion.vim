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

		['<c-e>'] = {
			function(cmp)
				if not pcall(require, 'minuet.virtualtext') then
					return false
				end
				if require('minuet.virtualtext').action.is_visible() then
					vim.defer_fn(require('minuet.virtualtext').action.dismiss, 30)
					return true
				else
					return false
				end
			end,
			'hide',
			'fallback'
		},
		['<Tab>'] = {
			function(_)
				if not pcall(require, 'minuet.virtualtext') then
					return false
				end
				if require('minuet.virtualtext').action.is_visible() then
					vim.defer_fn(require('minuet.virtualtext').action.accept, 30)
					return true
				else
					return false
				end
			end,
			function(cmp)
				if cmp.snippet_active() then
					return cmp.accept()
				else
					return cmp.select_and_accept()
				end
			end,
			'snippet_forward',
			'fallback'
		},

		-- Unset some keymaps of preset
		['<c-space>'] = { 'fallback' },
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



" Section: milanglacier/minuet-ai.nvim
"
Plug 'milanglacier/minuet-ai.nvim', { 'on': [] }

lua << EOF
local minuet_options = {
	n_completions = 1,
	provider = 'openai_fim_compatible',
	provider_options = {
		provider_options = {
			openai_fim_compatible = {
				api_key = 'DEEPSEEK_API_KEY',
				name = 'deepseek',
				optional = {
					max_tokens = 256,
					top_p = 0.9,
				},
			},
		},
	},
}

local minuet_setup_augroup =
	vim.api.nvim_create_augroup('minuet_setup', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
	group = minuet_setup_augroup,
	callback = function()
		vim.fn['plug#load']('minuet-ai.nvim')
		require('minuet').setup(minuet_options)
	end,
})
EOF
