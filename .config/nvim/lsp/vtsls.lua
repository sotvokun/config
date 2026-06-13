-- lsp/vtsls.lua
--

local EXEC = 'vtsls'
local exec_config = {
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
}

-- for vue-language-server typescript-plugin
-- REFERENCE: https://github.com/vuejs/language-tools/wiki/Neovim
local VUELS_EXEC = 'vue-language-server'
local vuels_exists, from_mason, mason_package = vim.lsp.executable(VUELS_EXEC)
if vuels_exists and from_mason then
	table.insert(exec_config.filetypes, 'vue')
	local vuels_module_path = vim.fs.joinpath(
		mason_package:get_install_path(),
		'node_modules',
		'@vue',
		'language-server'
	)
	exec_config.settings.vtsls.tsserver = {
		globalPlugins = {
			{
				name = '@vue/typescript-plugin',
				location = vuels_module_path,
				languages = { 'vue' },
				configNamespace = 'typescript'
			}
		}
	}
end

return vim.lsp.define_config(EXEC, exec_config)

-- vim: ts=4
