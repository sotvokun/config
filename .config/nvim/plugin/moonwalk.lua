-- moonwalk.lua
--
-- a fennel wrapper to make neovim support fennel language
--
-- USAGE:
--   moonwalk.lua {help|version|update}
--
--   subcommands:
--     help                    - print the help message
--                               (DEFAULT)
--     version                 - print the current fennel version
--     update                  - install or update fennel to the latest version.
--                               it will be installed at
--                               "stdpath('data')/site/pack/moonwalk/start/moonwalk/lua/fennel.lua"
--
-- VARIABLES:
--   g:moonwalk_dir            - the directory for search fennel code
--                               (DEFAULT: stdpath('config'))
--   g:moonwalk_subdirs        - the fennel code in this directories that under
--                               `g:moonwalk_dir` will compiled to lua code.
--                               (DEFAULT: ['plugin', 'indent', 'ftplugin', 'colors', 'lsp'])
--   g:moonwalk_compiled_dir   - the directory that stored compiled lua files.
--                               the path is in runtimepath or packpath usually.
--                               (DEFAULT: "stdconfig('data')/site")
--   g:moonwalk_dir_alias      - the alias for `g:moonwalk_dir` is used for handle symlink
--                               (DEFAULT: [stdpath('config'), '~/.config/nvim'])
--   g:moonwalk_hook_precompile
--                             - the function will be called before compiling;
--                               handling with fennel code
--                               (TYPE: str -> str)
--                               (DEFAULT: { src -> src })
--                               NOTE: This variable only can be assigned with `lua` command.
--   g:moonwalk_hook_postcompile
--                             - the function will be called after compiling;
--                               handling with lua code
--                               (TYPE: str -> str)
--                               (DEFAULT: { src -> src })
--                               NOTE: This variable only can be assigned with `lua` command.
--   g:moonwalk_hook_ignorecompile
--                             - the function will be called while compiling;
--                               handling to ignore specific files
--                               (TYPE: nil -> str[])
--                               (DEFAULT: { -> [] })
--                               NOTE: This variable only can be assigned with `lua` command.
--   g:moonwalk_macro_path     - the macro path for fennel compiler
--                               (DEFAULT: [])
--
-- COMMANDS:
--   Moonwalk                  - compile all fennel files to lua
--   MoonwalkClean             - clean all compiled lua files
--
-- AUTOCMDS:
--   BufWritePost               compile written fennel file in config path
--   SourceCmd                  execute the fennel with source command
--
-- REFERENCE:
--   https://github.com/gpanders/nvim-moonwalk
--   https://github.com/gpanders/dotfiles/blob/master/.config/nvim/lua/moonwalk.lua
--

if vim.g.loaded_moonwalk then
	return
end
vim.g.loaded_moonwalk = true


-- Constant

local FENNEL_VERSION = '1.5.1'
local FENNEL_URL = string.format('https://fennel-lang.org/downloads/fennel-%s.lua', FENNEL_VERSION)
local FENNEL_PATH = vim.fs.normalize(string.format(
	'%s/site/pack/moonwalk/start/moonwalk/lua/fennel.lua',
	vim.fn.stdpath('data')
))

local STATE_MARK = vim.fs.normalize(vim.fn.stdpath('state') .. '/moonwalked')


-- Variables

--- g:moonwalk_dir
if type(vim.g.moonwalk_dir) ~= 'string' then
	vim.g.moonwalk_dir = vim.fn.stdpath('config')
end
local _dir = vim.g.moonwalk_dir

--- g:moonwalk_subdirs
if type(vim.g.moonwalk_subdirs) ~= 'table' then
	vim.g.moonwalk_subdirs = {
		'plugin',
		'indent',
		'ftplugin',
		'colors',
		'lsp',
	}
end
local _subdirs = vim.g.moonwalk_subdirs

-- g:moonwalk_compiled_dir
if type(vim.g.moonwalk_compiled_dir) ~= 'string' then
	vim.g.moonwalk_compiled_dir = vim.fs.normalize(vim.fn.stdpath('data') .. '/site')
end
local _compiled_dir = vim.g.moonwalk_compiled_dir

-- g:moonwalk_dir_alias
if type(vim.g.moonwalk_dir_alias) ~= 'table' then
	vim.g.moonwalk_dir_alias = { vim.fn.stdpath('config'), '~/.config/nvim' }
end
local _dir_alias = vim.g.moonwalk_dir_alias

-- hooks
if type(vim.g.moonwalk_hook_precompile) ~= 'function' then
	vim.g.moonwalk_hook_precompile = function(src) return src end
end
if type(vim.g.moonwalk_hook_postcompile) ~= 'function' then
	vim.g.moonwalk_hook_postcompile = function(src) return src end
end
if type(vim.g.moonwalk_hook_ignorecompile) ~= 'function' then
	vim.g.moonwalk_hook_ignorecompile = function() return {} end
end
local _hooks = {
	precompile = vim.g.moonwalk_hook_precompile,
	postcompile = vim.g.moonwalk_hook_postcompile,
	ignorecompile = vim.g.moonwalk_hook_ignorecompile
}

-- g:moonwalk_macro_path
if type(vim.g.moonwalk_macro_path) ~= 'table' then
	vim.g.moonwalk_macro_path = {}
end


-- Main Functions
-- __main__ for lua
if arg[0] ~= nil then
	local cmd = 'help'
	if #arg >= 1 then
		cmd = arg[1]
	end
	if cmd == 'help' then
		local msg = [[%s {help|version|update}]]
		print(string.format(msg, arg[0]))
		return 0
	end
	if cmd == 'version' then
		local ok, fennel = pcall(require, 'fennel')
		if not ok then
			print("[moonwalk.lua] no installed fennel")
			return 0
		end
		print(string.format("[moonwalk.lua] fennel version %s", fennel.version))
		return 0
	end
	if cmd == 'update' then
		local ok, fennel = pcall(require, 'fennel')
		if ok and fennel.version == FENNEL_VERSION then
			print(string.format('[moonwalk.lua] fennel version latest'))
			return 0
		end

		if vim.system == nil then
			print(string.format('[moonwalk.lua] moonwalk.lua needs 0.10 for update'))
		end

		vim.fn.mkdir(vim.fn.fnamemodify(FENNEL_PATH, ':h'), 'p')
		print(string.format('Downloading fennel %s', FENNEL_VERSION))
		do
			local job = vim.system({
				'curl', '-sS', '-o', FENNEL_PATH, FENNEL_URL
			}):wait(10000)
			assert(job.code == 0, job.stderr)
		end
		print(string.format('complete'))
		return 0
	end
end


-- Library Functions

--- compie one fennel content to lua
-- @param path        fennel file path
-- @param out         compiled lua file path
--                    (DEFAULT: `{stdpath('data')}/lua/{path_without_ext}.lua`)
-- @return            compiled lua file path
local function compile(path, out)
	local ok, fennel = pcall(require, 'fennel')
	if not ok then
		error('[moonwalk.lua] no `fennel\' can be required; ' .. fennel)
		return
	end
	path = vim.fs.normalize(path)

	local base = string.gsub(path, vim.fs.normalize(_dir) .. '/', '')
	local ignore_list = _hooks['ignorecompile']()
	for _, v in ipairs(ignore_list) do
		if base == v then
			return
		end
	end

	local src = (function()
		local f = assert(io.open(path))
		local content = f:read('*a')
		f:close()
		return content or nil
	end)()
	if not src then
		return
	end

	local macro_path = fennel['macro-path']
	local custom_macro_path = vim.tbl_extend('force',
		{'./fnl/?.fnl', './fnl/init.fnl', './fnl/init-macros.fnl'},
		vim.g.moonwalk_macro_path
	)
	fennel['macro-path'] = vim.iter(custom_macro_path):join(';')

	src = _hooks['precompile'](src)
	local compiled = fennel.compileString(src, { filename = path })
	src = _hooks['postcompile'](src)

	if not out then
		folder_and_ext = base:gsub('^fnl/', 'lua/'):gsub('%.fnl$', '.lua')
		out = vim.fs.normalize(_compiled_dir .. '/' .. folder_and_ext)
	end
	vim.fn.mkdir(vim.fn.fnamemodify(out, ':h'), 'p')

	local f = assert(io.open(out, 'w'))
	f:write(compiled)
	f:close()

	return out
end


--- apply a function to all files that matched extension name with its path 
--- in a specific directory and its children
-- @param dir        directory start to walk
-- @param ext        extension name without dots
--                   (EXAMPLE: fnl, lua)
-- @param fn         function to do action
local function walk(dir, ext, fn)
	local subdirs = vim.list_extend(_subdirs, {ext})
	local pred = function(name)
		return string.match(name, string.format('.*%%.%s', ext))
	end
	for _, path in ipairs({ dir, vim.fs.normalize(dir .. '/after') }) do
		for _, subpath in ipairs(subdirs) do
			local file_paths = vim.fs.find(pred, {
				limit = math.huge,
				path = vim.fs.normalize(path .. '/' .. subpath)
			})
			for _, file_path in ipairs(file_paths) do
				fn(file_path)
			end
		end
	end
end


--- clear all compiled lua files
local function clear()
	walk(vim.fs.normalize(_compiled_dir), 'lua', function(path)
		os.remove(path)
	end)
end


--- disable vim loader
local function loader_disable()
	if vim.fn.has('nvim-0.11.0') == 1 then
		vim.loader.enable(false)
	else
		vim.loader.disable()
	end
end


-- Commands
--- :Moonwalk
vim.api.nvim_create_user_command('Moonwalk', function()
	-- disable loader to avoid some weird issue may occured
	loader_disable()

	clear()
	walk(_dir, 'fnl', compile)

	local f = assert(io.open(STATE_MARK, 'w'))
	f:write('')
	f:close()

	-- reset runtimepath cache so new Lua files are discovered
	vim.o.runtimepath = vim.o.runtimepath

	vim.schedule(vim.loader.enable)
end, {
	desc = 'Compile all fennel files to lua'
})

--- :MoonwalkClean
vim.api.nvim_create_user_command('MoonwalkClean', function()
	loader_disable()
	clear()
	vim.schedule(vim.loader.enable)
end, {
	desc = 'Clean all compiled lua files'
})


-- Autocmd

vim.api.nvim_create_augroup('moonwalk', { clear = true })

-- compile fennel files in `g:moonwalk_dir`
vim.api.nvim_create_autocmd('BufWritePost', {
	group = 'moonwalk',
	pattern = vim.tbl_map(function(p)
		return vim.fs.normalize(p .. '/*.fnl')
	end, _dir_alias),
	callback = function(args)
		local path = args.match
		for _, cfgpath in ipairs(vim.tbl_map(vim.fs.normalize, _dir_alias)) do
			if vim.startswith(path, cfgpath) then
				path = string.gsub(path, cfgpath, vim.fn.stdpath('config'))
			end
		end
		compile(path)
	end,
})

-- source fennel
vim.api.nvim_create_autocmd('SourceCmd', {
	group = 'moonwalk',
	pattern = '*.fnl',
	callback = function(args)
		local src_path = vim.fs.normalize(args.file)
		-- handle Windows driver mark colon
		if vim.fn.has('win32') then
			src_path = src_path:gsub(':', '')
		end
	end,
})

-- As a plugin beahviour
if not (vim.uv or vim.loop).fs_stat(STATE_MARK) then
	vim.cmd.Moonwalk()
end
