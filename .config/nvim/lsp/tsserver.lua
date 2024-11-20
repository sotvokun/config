local filetypes = {
	'javascript',
	'javascriptreact',
	'javascript.jsx',
	'typescript',
	'typescriptreact',
	'typescript.tsx',
}

local init_options = {
	hostInfo = 'neovim',
	preferences = {
		quotePreference = 'single',
	},
}

-- VUE INTEGRATION
do
	local node_package_manager = 'npm'
	node_package_manager = vim.fn.has('win32') == 1 and 'npm.cmd' or 'npm'
	local local_node_modules = vim.trim(vim.system({node_package_manager, 'root'}, { text = true }):wait().stdout)
	local global_node_modules = vim.trim(vim.system({node_package_manager, 'root', '-g'}, { text = true }):wait().stdout)

	local vue_langserver = function(scope) return vim.fs.joinpath(scope, '@vue', 'language-server') end

	local tsserver_plugin = {
		name = '@vue/typescript-plugin',
		languages = { 'vue' },
		location = nil,
	}

	if vim.fn.isdirectory(vue_langserver(local_node_modules)) == 1 then
		tsserver_plugin.location = vue_langserver(local_node_modules)
	end
	if vim.fn.isdirectory(vue_langserver(global_node_modules)) == 1 then
		tsserver_plugin.location = vue_langserver(global_node_modules)
	end

	if type(tsserver_plugin.location) ~= 'nil' then
		init_options.plugins = { tsserver_plugin }
		table.insert(filetypes, 'vue')
	end
end

return {
	cmd = { 'typescript-language-server', '--stdio' },
	filetypes = filetypes,
	root_dir = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
	init_options = init_options,
}
