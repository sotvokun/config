-- lsp.lua
--
-- lsp.lua is a simple plugin to control neovim lsp feature and quickly setup lsp clients
--
-- VARIABLES:
--    g:lsp_runtime_dir
--       The path of lsp configuration files in the runtime path.
--       (DEFAULT: lsp)
--    g:lsp
--       The global option for lsp clients. Supported options:
--       - `before_init`: A function to be called before the client is initialized.
--       - `on_init`: A function to be called after the client is initialized.
--       - `capabilities`: The capabilities of the client.
--       - `handlers`: The handlers of the client.
--       (DEFAULT: {})
--    g:lsp_servers
--       The list of lsp servers to be setup.
--
-- REFERENCES:
--  - https://github.com/gpanders/dotfiles/blob/72b01b962a42d6b836dc8695fa6cf1950ec4d9df/.config/nvim/lua/lsp.lua


if vim.fn.has('nvim') == 0 then
	vim.notify('[lsp.lua] only neovim support this module', vim.log.levels.WARN)
end

local nvim_version = vim.version()
if nvim_version.major == 0 and nvim_version.minor < 10 then
	vim.notify('[lsp.lua] needs neovim version >= 0.10.0', vim.log.levels.WARN)
end

if vim.g.loaded_lsp then
	return
end
vim.g.loaded_lsp = 1


-- Section: Variables
--

if type(vim.g.lsp_runtime_dir) ~= 'string' then
	vim.g.lsp_runtime_dir = 'lsp'
end

if type(vim.g.lsp) ~= 'table' then
	vim.g.lsp = {}
end

local autocmds = {}


-- Section: Functions
--

local function runtime_files(name)
	local str = name and '%s/%s.lua' or '%s/*.lua'
	return vim.api.nvim_get_runtime_file(
		string.format(str, vim.g.lsp_runtime_dir, name),
		true
	)
end

local function load(name)
	local paths = runtime_files(name)
	if #paths == 0 then
		return nil
	end

	local config = {}
	for _, path in ipairs(paths) do
		local f = assert(loadfile(path))
		config = vim.tbl_deep_extend('force', config, f())
	end

	return config
end

local function config(server, opts)
	opts = opts or {}
	local cfg = load(server)
	if not cfg then
		return false, string.format('No LSP configuration found for %s', server)
	end

	local ft = cfg.filetype
	if not ft then
		return false, string.format('Invalid LSP configuration for %s: field "filetype" is required', server)
	end
	if type(ft) == 'string' then
		ft = { ft }
	end
	if type(ft) ~= 'table' then
		return false, string.format('Invalid LSP configuration for %s: field "filetype" only can be string or table', server)
	end

	if type(cfg.root_dir) == 'table' then
		cfg.root_dir = vim.fs.root(0, cfg.root_dir)
	end

	if autocmds[server] then
		vim.api.nvim_del_autocmd(autocmds[server])
	end

	local group = vim.api.nvim_create_augroup('nvim_lsp', {
		clear = false,
	})

	local id = vim.api.nvim_create_autocmd('FileType', {
		pattern = ft,
		group = group,
		callback = function()
			local capabilities = vim.tbl_deep_extend(
				'force',
				vim.lsp.protocol.make_client_capabilities(),
				opts.capabilities or {}
			)

			local client_cfg = vim.tbl_deep_extend('keep', cfg, {
				name = server,
				root_dir = vim.uv.cwd(),
				before_init = opts.before_init,
				on_init = opts.on_init,
				capabilities = capabilities,
				handlers = opts.handlers,
			})

			vim.lsp.start(client_cfg, {
				silent = true,
			})
		end,
	})
	autocmds[server] = id

	return true, nil
end

local function setup()
	local servers = vim.iter(runtime_files()):map(function(path)
		return vim.fn.fnamemodify(path, ':t:r')
	end):totable()
	vim.g.lsp_servers = servers
	for _, server in ipairs(servers) do
		local ok, errmsg = config(server, vim.g.lsp)
		if not ok then
			local msg = errmsg or 'Failed to setup LSP client'
			vim.notify(string.format('[lsp.lua] %s', msg), vim.log.levels.WARN)
		end
	end
end

setup()
