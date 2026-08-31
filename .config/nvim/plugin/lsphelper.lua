-- lsphelper.lua
--
-- Resolve LSP executables from Mason or the system PATH before defining a
-- configuration. Mason executables take precedence when available.

if vim.g.loaded_lsphelper then
	return
end
vim.g.loaded_lsphelper = true

local default_options = {
	name_as_executable = true,
}

local function mason_root()
	if vim.env.MASON and vim.env.MASON ~= '' then
		return vim.env.MASON
	end

	local ok, settings = pcall(require, 'mason.settings')
	if ok and settings.current then
		return settings.current.install_root_dir
	end
	return nil
end

local function existing_executable(path)
	if not path or path == '' then
		return nil
	end

	local resolved_path = vim.fn.exepath(path)
	if resolved_path ~= '' then
		return resolved_path
	end
	if vim.uv.fs_stat(path) then
		return path
	end
	return nil
end

function vim.lsp.exepath(command)
	local root = mason_root()
	if root then
		local mason_command = existing_executable(vim.fs.joinpath(root, 'bin', command))
		if mason_command then
			return mason_command
		end
	end

	return existing_executable(command)
end

function vim.lsp.define_config(command, config, options)
	local opts = vim.tbl_extend('force', default_options, options or {})
	local command_path = vim.lsp.exepath(command)
	if not command_path then
		return {}
	end

	local resolved_config = vim.deepcopy(config)
	if opts.name_as_executable then
		if type(resolved_config.cmd) ~= 'table' then
			resolved_config.cmd = {}
		end
		resolved_config.cmd[1] = command_path
	end
	return resolved_config
end

-- vim: ts=4
