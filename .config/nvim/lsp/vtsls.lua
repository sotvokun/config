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
		"jsconfig.json",
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
local function mason_package_path(executable)
	local executable_path = vim.lsp.exepath(executable)
	if not executable_path then
		return nil
	end

	local mason_root = vim.fs.dirname(vim.fs.dirname(executable_path))
	local package_path = vim.fs.joinpath(mason_root, 'packages', executable)
	return vim.uv.fs_stat(package_path) and package_path or nil
end

local vuels_package_path = mason_package_path(VUELS_EXEC)
if vuels_package_path then
	table.insert(exec_config.filetypes, 'vue')
	local vuels_module_path = vim.fs.joinpath(
		vuels_package_path,
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
