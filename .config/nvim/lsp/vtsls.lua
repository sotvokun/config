-- lsp/vtsls.lua
--

local EXEC = 'vtsls'

return vim.lsp.define_config(EXEC, {
	cmd = { 'vtsls', '--stdio' },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx"
	},
	root_markers = {
		"tsconfig.json",
		"jsonconfig.json",
		"package.json"
	},
	settings = {
		typescript = {
			updateImportsOnFileMove = "always",
		},
		javascript = {
			updateImportsOnFileMove = "always",
		},
		vtsls = {
			enableMoveToFileCodeAction = true,
		},
	},
})

-- vim: ts=4
