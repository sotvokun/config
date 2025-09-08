-- fnlkit.lua
--
-- COMMANDS:
--   Fnlkit [make|clean]       - make: compiles all fennel files in the user configuration
--                               directory to lua and writing them to the site directory
--                               of runtimepath.
--                               clean: removes all compiled lua files in the site directory
--                               of runtimepath.
--   [range]Fnl[=] {chunk}     - executes fennel script from the {chunk} or the range.
--                               `:Fnl=` are equaivalent to `:Fnl (print (fennel.view chunk))`
--
-- AUTOCMD:
--   BufWritePost              - compiles the fennel file under the possible user configuration
--                               directories.
--   SourceCmd                 - sources fennel file.
--

if vim.fn.has('nvim-0.10.0') == 0 then
	error('fnlkit.lua only works on neovim 0.10 and later versions')
	return
end
if vim.g.loaded_fnlkit and (vim.g.loaded_fnlkit == 1 or vim.g.loaded_fnlkit == true) then
	return
end
vim.g.loaded_fnlkit = 1


-- Constant

local FENNEL_VERSION = '1.5.3'
local FENNEL_DOWNLOAD_URL = string.format(
	'https://fennel-lang.org/downloads/fennel-%s.lua',
	FENNEL_VERSION
)
local FENNEL_INSTALL_PATH = vim.fs.normalize(string.format(
	'%s/site/pack/fnlkit/start/fnlkit/lua/fennel.lua',
	vim.fn.stdpath('data')
))

local PATH_SITE = vim.fs.normalize(vim.fs.joinpath(vim.fn.stdpath('data'), 'site'))


-- Variables

local fennel_macros = {}


-- Function

--- universal print function
-- @param msg           the message to print
-- @param is_error      display the message as an error
local function print_(msg, is_error)
	local is_executable = arg[0] ~= nil
	msg = string.format('[fnlkit.lua] %s', msg)
	if is_executable then
		if is_error then msg = string.format('\27[1;31m%s\27[0m\n', msg)
		else msg = string.format('%s\n', msg)
		end
		io.write(msg)
	else
		local level = vim.log.levels.INFO
		if is_error then level = vim.log.levels.ERROR end
		vim.notify(msg, level)
	end
end

--- io.open wrapper for displaying error message when failed
-- @param path          path to open the file
-- @param mode          which mode to open the file
-- @return              file handler userdata
local function openfile(path, mode)
	local f, errmsg = io.open(path, mode)
	if errmsg ~= nil then
		print_(errmsg, 1)
	end
	return f
end

--- update/install fennel.lua into FENNEL_INSTALL_PATH
-- @return              0 for success, otherwise failed
local function update_fennel()
	local ok, fennel = pcall(require, 'fennel')
	if ok and fennel.version == FENNEL_VERSION then
		print_('fennel is already the latest version')
		return 0
	end

	local curl_exepath = vim.fn.exepath('curl')
	if #(curl_exepath) == 0 then
		print_('updating fennel needs curl', 1)
		return 1
	end

	vim.fn.mkdir(vim.fs.dirname(FENNEL_INSTALL_PATH), 'p')
	print_(string.format('downloading fennel %s', FENNEL_VERSION))
	do
		local job = vim.system({
			curl_exepath, '-sS', '-o', FENNEL_INSTALL_PATH, FENNEL_DOWNLOAD_URL
		}):wait(10000)
		assert(job.code == 0, job.stderr)
	end
	print_('complete')
	return 0
end

--- write content into the file at the specific path
-- @param path          the file path
-- @param content       the content of the file to writting
-- @return              0 for success, otherwise failed
local function writefile(path, content)
	local dir = vim.fs.dirname(path)
	vim.fn.mkdir(dir, 'p')

	local f = openfile(path, 'w')
	if f == nil then
		return 1
	end
	f:write(content)
	f:close()
	return 0
end

--- compile one fennel file to lua code and write it to specific path
-- @param input         input fennel file path
-- @param out           compiled lua file output path
-- @return              0 for success, otherwise failed
local function compile(input, out)
	local ok, fennel = pcall(require, 'fennel')
	if not ok then
		print_('no \'fennel\' can be required; ' .. fennel, 1)
		return 1
	end

	if input:match('.*macros%.fnl') ~= nil then
		return
	end

	input = vim.fs.normalize(input)
	local src_string = nil
	do
		local f = openfile(input, 'r')
		if f == nil then
			return 1
		end
		src_string = f:read('*a')
		f:close()
	end
	if not src_string then
		print_(string.format('failed to read content in the file \'%s\'', input), 1)
		return 1
	end

	local compiled = fennel.compileString(src_string, {
		correlate = true,
		filename = input
	})

	return writefile(out, compiled)
end

--- walk all files matched with pattern
-- @param dir           directory to start walk downward
-- @param pattern       path pattern to match
-- @param fn            the function to do with the matched files path
local function walk(dir, pattern, fn)
	local pred = function(name, path)
		return string.match(vim.fs.joinpath(path, name), pattern)
	end
	local srcpaths = vim.fs.find(pred, { limit = math.huge, type = 'file', path = dir })
	for i, path in ipairs(srcpaths) do
		fn(path)
	end
end

--- get the relative path of the file in the user configuration directory.
--- the path will be automatically replace file extension and the folder `fnl` to `lua`.
-- @param path          the path under the user configuration directory
-- @param config_dir    [string, array<string>] the configuration directory to trim
-- @return              the relative path
-- @example             input: /home/username/.config/nvim/fnl/foobar.fnl
--                      output: /lua/foobar.lua
local function config_relpath(path, config_dir)
	if config_dir == nil then
		config_dir = vim.fs.normalize(vim.fn.stdpath('config'))
	end
	if type(config_dir) == 'string' then
		config_dir = { config_dir }
	end
	for _, dir in ipairs(config_dir) do
		path = path:gsub(dir, '')
	end
	local relpath = path:gsub('^/fnl/', '/lua/'):gsub('.fnl$', '.lua')
	return relpath
end


-- Component

local Macro = {paths={}}
function Macro:collect()
	local config_fnl_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'fnl')
	local pattern = vim.fs.normalize(vim.fs.joinpath(config_fnl_dir, '.+%.fnl$'))
	walk(config_fnl_dir, pattern, function(path)
		local lines = vim.fn.readfile(path)
		if #lines == 0 then
			return
		end
		if string.match(lines[1], '^;;*%s*%!%[macro%]$') ~= nil then
			table.insert(Macro.paths, path)
		end
	end)
end

function Macro:inject()
	local fennel = require('fennel')
	local macroPathTable = vim.deepcopy(Macro.paths)
	table.insert(macroPathTable, fennel.macroPath)
	local macroPath = vim.iter(macroPathTable):join(';')
	fennel['macroPath'] = macroPath
	fennel['macro-path'] = macroPath
end


-- User command
-- :Fnlkit [make|clean]
local COMMAND_ARGS_FNLKIT = {'make', 'clean'}
vim.api.nvim_create_user_command('Fnlkit', function(args)
	local ok, fennel = pcall(require, 'fennel')
	if not ok then
		print_('no \'fennel\' can be required; ' .. fennel)
		return
	end

	local cmdarg = #(args.fargs) == 0 and COMMAND_ARGS_FNLKIT[1] or args.fargs[1]
	if not vim.tbl_contains(COMMAND_ARGS_FNLKIT, cmdarg) then
		vim.notify('Unknown command argument: ' .. cmdarg, vim.log.levels.ERROR)
		return
	end

	local config_dir = vim.fs.normalize(vim.fn.stdpath('config'))
	local pattern = vim.fs.normalize(vim.fs.joinpath(config_dir, '.+%.fnl$'))
	local sitepathelize = function(path)
		return vim.fs.joinpath(PATH_SITE, config_relpath(path, config_dir))
	end

	if cmdarg == 'make' then
		walk(config_dir, pattern, function(path)
			local file_sitepath = sitepathelize(path)
			compile(path, file_sitepath)
		end)
		return
	end
	if cmdarg == 'clean' then
		walk(config_dir, pattern, function(path)
			local file_sitepath = sitepathelize(path)
			if vim.uv.fs_stat(file_sitepath) == nil then
				return
			end
			vim.fs.rm(file_sitepath)
		end)
		return
	end
end, {
	desc = 'fnlkit.lua main command',
	nargs = '?',
	complete = function(arg_lead, cmd_line, cursor_pos)
		return COMMAND_ARGS_FNLKIT
	end
})

-- :[range]Fnl[=] {chunk}
vim.api.nvim_create_user_command('Fnl', function(args)
	local ok, fennel = pcall(require, 'fennel')
	if not ok then
		print_('no \'fennel\' can be required; ' .. fennel)
		return
	end

	local script = args.args

	local do_print = string.sub(args.args, 1, 1) == '='
	if do_print then
		script = string.gsub(args.args, '^=%s*(.*)$', '%1')
	end
	if args.range > 0 then
		local lines = vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, false)
		script = table.concat(lines, '\n')
	end
	local result = fennel.eval(script)
	if do_print then
		print(fennel.view(result))
	end
	return result
end, {
	desc = 'Execute fennel string',
	nargs = '*',
	range = '%'
})


-- Autocmd

local AUGROUP_FNLKIT = 'fnlkit'
local USER_CONFIG_DIR = vim.fs.normalize(vim.fn.stdpath('config'))
vim.api.nvim_create_augroup(AUGROUP_FNLKIT, { clear = true })

-- BufWritePost
do 
	local possible_config_dirs = {
		USER_CONFIG_DIR
	}
	if vim.uv.fs_lstat(USER_CONFIG_DIR).type == 'link' then
		table.insert(possible_config_dirs, vim.uv.fs_realpath(USER_CONFIG_DIR))
	end
	vim.api.nvim_create_autocmd('BufWritePost', {
		group = AUGROUP_FNLKIT,
		pattern = vim.tbl_map(function(path)
			return vim.fs.normalize(vim.fs.joinpath(path, '*.fnl'))
		end, possible_config_dirs),
		callback = function(args)
			local srcpath = args.match
			local sitepathelize = function(path)
				return vim.fs.joinpath(
					PATH_SITE,
					config_relpath(path, possible_config_dirs)
				)
			end
			compile(srcpath, sitepathelize(srcpath))
		end
	})
end

-- SourceCmd
vim.api.nvim_create_autocmd('SourceCmd', {
	group = AUGROUP_FNLKIT,
	pattern = '*.fnl',
	callback = function(args)
		local ok, fennel = pcall(require, 'fennel')
		if not ok then
			print_('no \'fennel\' can be required; ' .. fennel)
			return
		end
		fennel.dofile(vim.fs.normalize(args.file))
	end
})

-- Script As Plugin

do
	Macro:collect()
	Macro:inject()
end


-- Script As Executable

if arg[0] ~= nil then
	local subcmd = 'help'
	if #arg >= 1 then
		subcmd = arg[1]
	end
	if subcmd == 'help' then
		local msg = '%s {help|version|update|compile <input> [<out>]}'
		print(string.format(msg, arg[0]))
		return 0
	end
	if subcmd == 'version' then
		local ok, fennel = pcall(require, 'fennel')
		if not ok then
			print_('fennel not installed')
			return 0
		end
		print_(string.format('fennel version %s', fennel.version))
		return 0
	end
	if subcmd == 'update' then
		return update_fennel()
	end
	if subcmd == 'compile' then
		local input = arg[2]
		if input == nil then
			print_('no input file specified', 1)
			return 1
		end
		local out = arg[3]
		if out == nil then
			out = input:gsub('%.fnl$', '.lua')
		end
		return compile(input, out)
	end
end
