local home = vim.fn.has('win32') == 1 and vim.env.USERPROFILE or vim.env.HOME
local xdg_config = vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(home, '.config')
local intelephense_config_dir = vim.fs.joinpath(xdg_config, 'intelephense')
local intelephense_license_key = vim.fs.joinpath(intelephense_config_dir, 'license.key')


-- vscode settings loading
local cwd = vim.uv.cwd()
local vscode_settings = vim.fs.joinpath(cwd, '.vscode', 'settings.json')
local intelephense_settings = {}
if vim.fn.filereadable(vscode_settings) == 1 then
	local settings = vim.fn.json_decode(vim.fn.readfile(vscode_settings))
	for key, value in pairs(settings) do
		if key:sub(1, 13) == 'intelephense.' then
			local sub_keys = vim.split(key, '%.')
			local current = intelephense_settings
			for i = 1, #sub_keys - 1 do
				local sub_key = sub_keys[i]
				current[sub_key] = current[sub_key] or {}
				current = current[sub_key]
			end
			current[sub_keys[#sub_keys]] = value
		end
	end
end


return {
	cmd = { 'intelephense', '--stdio' },
	filetype = { 'php' },
	root_dir = { 'composer.json', '.git' },
	init_options = {
		licenceKey = intelephense_license_key,
	},
	settings = vim.tbl_isempty(intelephense_settings) and nil or intelephense_settings,
}
