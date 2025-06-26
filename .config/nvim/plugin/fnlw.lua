-- fnlw.lua
--
-- a fennel wrapper to make neovim support fennel language
--
-- USAGE:
--   fnlw.lua {help|version|update|repl}
--
--   subcommands:
--     help                    - print the help message
--                               (DEFAULT)
--     version                 - print the current fennel version
--     update                  - install or update fennel to the latest version.
--                               it will be installed at
--                               "stdpath('data')/site/pack/fnlw/start/fnlw/lua/fennel.lua"
--     repl                    - start fennel as REPL
--
-- VARIABLES:
--   g:fnlw_rtpdirs            - the directories under user configuration directory will
--                               be handled by fennel compiler
--                               (DEFAULT: ['plugin', 'indent', 'ftplugin', 'colors', 'lsp'])
--   g:fnlw_hook_precompile
--                             - the function will be called before compiling;
--                               handling with fennel code
--                               (TYPE: str -> str)
--                               (DEFAULT: { src -> src })
--                               NOTE: This variable only can be assigned with `lua` command.
--   g:fnlw_hook_postcompile
--                             - the function will be called after compiling;
--                               handling with lua code
--                               (TYPE: str -> str)
--                               (DEFAULT: { src -> src })
--                               NOTE: This variable only can be assigned with `lua` command.
--   g:fnlw_hook_ignorecompile
--                             - the function will be called while compiling;
--                               handling to ignore specific files
--                               (TYPE: nil -> str[])
--                               (DEFAULT: { -> [] })
--                               NOTE: This variable only can be assigned with `lua` command.
--
-- COMMANDS:
--   FnlCompile                - compile all fennel files to lua
--   FnlClean                  - clean all compiled lua files
--   [range]Fnl[=] {chunk}     - executes fennel script from the {chunk} or the range.
--                               `:Fnl=` are equaivalent to `:Fnl (print (fennel.view chunk))`
--
-- AUTOCMDS:
--   BufWritePost                compile written fennel file in config path
--   SourceCmd                   execute the fennel with source command
--
-- REFERENCE:
--   https://github.com/gpanders/nvim-moonwalk
--   https://github.com/gpanders/dotfiles/blob/master/.config/nvim/lua/moonwalk.lua
--

if vim.fn.has('nvim-0.10.0') == 0 then
	print('[fnlw.lua] works on neovim 0.10 and later versions')
	return
end

if vim.g.loaded_fnlw then
	return
end
vim.g.loaded_fnlw = true


-- Constant

local FENNEL_VERSION = '1.5.3'
local FENNEL_URL = string.format('https://fennel-lang.org/downloads/fennel-%s.lua', FENNEL_VERSION)
local FENNEL_INSTALL_PATH = vim.fs.normalize(string.format(
	'%s/site/pack/fnlw/start/fnlw/lua/fennel.lua',
	vim.fn.stdpath('data')
))

local STATE_MARK = vim.fs.normalize(vim.fn.stdpath('state') .. '/fnlwed')


-- Main Functions
-- __main__ for lua
if arg[0] ~= nil then
	local cmd = 'help'
	if #arg >= 1 then
		cmd = arg[1]
	end
	if cmd == 'help' then
		local msg = [[%s {help|version|update|repl}]]
		print(string.format(msg, arg[0]))
		return 0
	end
	if cmd == 'version' then
		local ok, fennel = pcall(require, 'fennel')
		if not ok then
			print("[fnlw.lua] no installed fennel")
			return 0
		end
		print(string.format("[fnlw.lua] fennel version %s", fennel.version))
		return 0
	end
	if cmd == 'update' then
		local ok, fennel = pcall(require, 'fennel')
		if ok and fennel.version == FENNEL_VERSION then
			print(string.format('[fnlw.lua] fennel version latest'))
			return 0
		end

		if vim.system == nil then
			print(string.format('[fnlw.lua] fnlw.lua needs 0.10 for update'))
		end

		vim.fn.mkdir(vim.fn.fnamemodify(FENNEL_INSTALL_PATH, ':h'), 'p')
		print(string.format('Downloading fennel %s', FENNEL_VERSION))
		do
			local job = vim.system({
				'curl', '-sS', '-o', FENNEL_INSTALL_PATH, FENNEL_URL
			}):wait(10000)
			assert(job.code == 0, job.stderr)
		end
		print(string.format('complete'))
		return 0
	end
	if cmd == 'repl' then
		local ok, fennel = pcall(require, 'fennel')
		if not ok then
			print("[fnlw.lua] no installed fennel")
		end
		fennel.repl()
		return 0
	end
end


-- Library Functions

-- Variables

--- g:fnlw_rtpdirs
if type(vim.g.fnlw_rtpdirs) ~= 'table' then
	vim.g.fnlw_rtpdirs = {
		'plugin',
		'indent',
		'ftplugin',
		'colors',
		'lsp',
	}
end
local rtp_dirs = vim.g.fnlw_rtpdirs

-- hooks
if type(vim.g.fnlw_hook_precompile) ~= 'function' then
	vim.g.fnlw_hook_precompile = function(src) return src end
end
if type(vim.g.fnlw_hook_postcompile) ~= 'function' then
	vim.g.fnlw_hook_postcompile = function(src) return src end
end
if type(vim.g.fnlw_hook_ignorecompile) ~= 'function' then
	vim.g.fnlw_hook_ignorecompile = function() return {} end
end
local compiler_hooks = {
	precompile = vim.g.fnlw_hook_precompile,
	postcompile = vim.g.fnlw_hook_postcompile,
	ignorecompile = vim.g.fnlw_hook_ignorecompile
}


-- Calculated Variables

local config_dir = vim.fn.stdpath('config')
local site_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site')

--- compie one fennel content to lua
-- @param path        fennel file path
-- @param out         compiled lua file path
--                    (DEFAULT: `{stdpath('data')}/lua/{path_without_ext}.lua`)
-- @return            compiled lua file path
local function compile(path, out)
	local ok, fennel = pcall(require, 'fennel')
	if not ok then
		error('[fnlw.lua] no `fennel\' can be required; ' .. fennel)
		return
	end
	path = vim.fs.normalize(path)

	local base = string.gsub(path, vim.fs.normalize(config_dir) .. '/', '')
	local ignore_list = compiler_hooks['ignorecompile']()
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
	fennel['macro-path'] = string.format('%s;%s',
		macro_path,
		vim.fs.joinpath(config_dir, 'fnl', '?.fnl')
	)

	src = compiler_hooks['precompile'](src)
	local compiled = fennel.compileString(src, { filename = path })
	src = compiler_hooks['postcompile'](src)

	if not out then
		folder_and_ext = base:gsub('^fnl/', 'lua/'):gsub('%.fnl$', '.lua')
		out = vim.fs.normalize(site_dir .. '/' .. folder_and_ext)
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
	local subdirs = vim.list_extend(rtp_dirs, {ext})
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
	walk(vim.fs.normalize(site_dir), 'lua', function(path)
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
--- :FnlCompile
vim.api.nvim_create_user_command('FnlCompile', function()
	-- disable loader to avoid some weird issue may occured
	loader_disable()

	clear()
	walk(config_dir, 'fnl', compile)

	local f = assert(io.open(STATE_MARK, 'w'))
	f:write('')
	f:close()

	-- reset runtimepath cache so new Lua files are discovered
	vim.o.runtimepath = vim.o.runtimepath

	vim.schedule(vim.loader.enable)
end, {
	desc = 'Compile all fennel files to lua'
})

--- :FnlClean
vim.api.nvim_create_user_command('FnlClean', function()
	loader_disable()
	clear()
	vim.schedule(vim.loader.enable)
end, {
	desc = 'Clean all compiled lua files'
})

--- :Fnl
vim.api.nvim_create_user_command('Fnl', function(args)
	local ok, fennel = pcall(require, 'fennel')
	if not ok then
		error('[fnlw.lua] no `fennel` can required; ' .. fennel)
		return
	end

	local script = args.args

	local do_print_result = string.sub(args.args, 1, 1) == '='
	if do_print_result then
		script = string.gsub(args.args, '^=%s*(.*)$', '%1')
	end

	if args.range > 0 then
		local lines = vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, false)
		script = table.concat(lines, '\n')
	end
	local result = fennel.eval(script)
	if do_print_result then
		print(fennel.view(result))
	end
	return result
end, {
	desc = 'Execute fennel string',
	nargs = '*',
	range = '%'
})


-- Autocmd

vim.api.nvim_create_augroup('fnlw', { clear = true })

-- compile fennel files in rtpdirs under the user configuration folder
local possible_config_dirs = {
	config_dir,
}
if vim.uv.fs_lstat(config_dir).type == 'link' then
	table.insert(possible_config_dirs, vim.uv.fs_realpath(config_dir))
end
vim.api.nvim_create_autocmd('BufWritePost', {
	group = 'fnlw',
	pattern = vim.tbl_map(function(p)
		return vim.fs.normalize(p .. '/*.fnl')
	end, possible_config_dirs),
	callback = function(args)
		local path = args.match
		for _, cfgpath in ipairs(vim.tbl_map(vim.fs.normalize, possible_config_dirs)) do
			if vim.startswith(path, cfgpath) then
				path = string.gsub(path, cfgpath, vim.fn.stdpath('config'))
			end
		end
		compile(path)
	end,
})

-- source fennel
vim.api.nvim_create_autocmd('SourceCmd', {
	group = 'fnlw',
	pattern = '*.fnl',
	callback = function(args)
		local ok, fennel = pcall(require, 'fennel')
		if not ok then
			error('[fnlw.lua] no `fennel` can required; ' .. fennel)
			return
		end
		fennel.dofile(vim.fs.normalize(args.file))
	end,
})

-- As a plugin beahviour
if not vim.uv.fs_stat(STATE_MARK) then
	vim.cmd.FnlCompile()
end
