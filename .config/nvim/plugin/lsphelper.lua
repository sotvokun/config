-- lsphelper.lua
--
-- a plugin to make LSP expereience better on neovim
--

if vim.g.loaded_lsphelper == true then
	return
end
vim.g.loaded_lsphelper = true


-- defining the global lsp configurations

vim.lsp.config('*', {
	root_markers = { '.git' },
})


-- extending LSP module

function vim.lsp._has_mason()
	return pcall(require, 'mason-registry')
end

function vim.lsp.executable(name)
	has_mason, mason_registry = vim.lsp._has_mason()
	if has_mason then
		has_package, mason_package = pcall(mason_registry.get_package, name)
		if has_package then
			return true, true, mason_package
		end
	end
	return vim.fn.executable(name) == 1, false, nil
end

function vim.lsp.exepath(name)
	is_existsed, by_mason, mason_package = vim.lsp.executable(name)
	if not is_existsed then
		return nil
	end
	if not by_mason then
		return vim.fn.exepath(name)
	end

	local has_mason_settings, mason_settings = pcall(require, 'mason.settings')
	if not has_mason_settings then
		return nil
	end
	local bin_path = vim.fs.joinpath(
		mason_settings.current.install_root_dir,
		'bin',
		vim.tbl_keys(mason_package.spec.bin)[1]
	)
	local ok, fs_data = pcall(vim.uv.fs_stat, bin_path)
	if not ok then
		return nil
	end
	return bin_path
end

vim.lsp.default_define_config_options = {
	name_as_executable = true
}

function vim.lsp.define_config(name, config, options)
	if not vim.lsp.executable(name) then
		return {}
	end

	local options_value = vim.tbl_extend(
		'force',
		vim.lsp.default_define_config_options,
		options or {}
	)

	if options_value.name_as_executable then
		if type(config.cmd) == 'table' and #(config.cmd) >= 1 then
			config.cmd[1] = vim.lsp.exepath(name)
		end
		if type(config.cmd) == 'nil'
			or (type(config.cmd) == 'table' and #(config.cmd) == 0) then
			config.cmd = { vim.lsp.exepath(name) }
		end
	end

	return config
end

-- vim: ts=4
