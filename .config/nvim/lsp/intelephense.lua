-- lsp/intelephense.lua
--

local EXEC = 'intelephense'

local function licence_key()
	local user_home = vim.env.HOME
	if vim.fn.has('win32') == 1 then
		user_home = vim.env.USERPROFILE
	end

	local licence_key_path = vim.fs.joinpath(
		user_home, '.config', EXEC, 'licence.key'
	)
	if vim.uv.fs_stat(licence_key_path) then
		local lines = vim.fn.readfile(licence_key_path)
		if #lines >= 1 then
			return lines[1]
		end
	end
	return ''
end

return vim.lsp.define_config(EXEC, {
	cmd = { 'intelephense', '--stdio' },
	filetypes = { 'php' },
	root_markers = { 'composer.json' },
	settings = vim.fn['json#expand']({
		['intelephense.licenceKey'] = licence_key()
	})
})

-- vim: ts=4
