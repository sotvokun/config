-- fnlkit.lua
--
-- Compile Fennel files in the Neovim configuration directory to Lua files in
-- stdpath('data')/site. Files below fnl/ are written below lua/; files in other
-- runtime directories keep their relative paths.
--
-- FILE ATTRIBUTES:
--   Attributes must be declared on the first line of a file:
--     ; fnlkit: macro, auto-require
--
--   macro          - use the file as a macro module and do not emit Lua.
--   auto-require   - inject a require before compiling other source files.
--                    Macro modules use require-macros instead.
--
-- COMMANDS:
--   Fnlkit             - clean and rebuild all Fennel configuration files.
--   Fnlkit make        - compile all Fennel configuration files.
--   Fnlkit clean       - remove their generated Lua files.
--   [range]Fnl[=] ...  - evaluate Fennel code; = displays the result.
--
-- AUTOCMD:
--   BufWritePost       - compile a saved Fennel configuration file.
--   SourceCmd          - source a Fennel file with fennel.dofile().
--
-- CLI:
--   nvim -l fnlkit.lua {help|version|update}

local IS_CLI = arg[0] ~= nil

if vim.fn.has('nvim-0.10') == 0 then
	error('fnlkit.lua only works on neovim 0.10 and later versions')
end
if not IS_CLI and vim.g.loaded_fnlkit then
	return
end
vim.g.loaded_fnlkit = true


-- [Utilities]

local function readfile(path, format)
	local file = assert(io.open(path, 'r'))
	local content = file:read(format or '*a')
	file:close()
	return content
end

local function writefile(path, content)
	vim.fn.mkdir(vim.fs.dirname(path), 'p')
	local file = assert(io.open(path, 'w'))
	file:write(content)
	file:close()
end

local function realpath(path)
	return vim.fs.normalize(vim.uv.fs_realpath(path) or path)
end

local function findfiles(dir, pattern)
	local paths = vim.fs.find(function(name)
		return name:match(pattern) ~= nil
	end, {
		path = dir,
		type = 'file',
		limit = math.huge,
	})
	table.sort(paths)
	return paths
end


-- [Manager]

local Manager = {
	target_version = '1.6.1',
	download_url_pattern = 'https://fennel-lang.org/downloads/fennel-%s.lua',
	install_path = vim.fs.joinpath(
		vim.fn.stdpath('data'),
		'site/pack/fnlkit/start/fennel/lua/fennel.lua'
	),
}

function Manager:current_version()
	local ok, fennel = pcall(require, 'fennel')
	return ok and fennel.version or nil
end

function Manager:download(path)
	local curl = vim.fn.exepath('curl')
	if curl == '' then
		return nil, 'downloading Fennel requires curl'
	end

	vim.fn.mkdir(vim.fs.dirname(path), 'p')
	local job = vim.system({
		curl,
		'-fLsS',
		'-o',
		path,
		string.format(self.download_url_pattern, self.target_version),
	}):wait(60000)
	if job.code ~= 0 then
		return nil, vim.trim(job.stderr or 'download failed')
	end
	return true
end

function Manager:install()
	if self:current_version() == self.target_version then
		return true
	end
	return self:download(self.install_path)
end


-- [Loader]

local Loader = {}
Loader.__index = Loader

local function loader_parse_attributes(path)
	local firstline = readfile(path, '*l') or ''
	local raw = firstline:match('^;%s*fnlkit:%s*(.-)%s*$')
	local attributes = {}
	if raw == nil then
		return attributes
	end
	if raw == '' then
		error('empty fnlkit annotation: ' .. path)
	end

	for _, attribute in ipairs(vim.split(raw, ',', { trimempty = false })) do
		attribute = vim.trim(attribute)
		if attribute ~= 'macro' and attribute ~= 'auto-require' then
			error(string.format("unknown fnlkit attribute '%s': %s", attribute, path))
		end
		attributes[attribute] = true
	end
	return attributes
end

local function loader_collect(loader)
	loader._files = {}
	loader._index = {}
	loader._auto_requires = {}

	for _, path in ipairs(findfiles(loader._config_dir, '%.fnl$')) do
		path = vim.fs.normalize(path)
		local relative = assert(vim.fs.relpath(loader._config_dir, path))
		local attributes = loader_parse_attributes(path)
		local in_fnl_dir = relative:match('^fnl[/\\]') ~= nil

		if next(attributes) ~= nil and not in_fnl_dir then
			error('fnlkit attributes are only allowed in ' .. loader._fnl_dir)
		end

		local output_relative = relative:gsub('^fnl[/\\]', 'lua/')
		output_relative = output_relative:gsub('%.fnl$', '.lua')
		local item = {
			path = path,
			output = vim.fs.joinpath(loader._site_dir, output_relative),
			module = in_fnl_dir
				and relative:sub(5):gsub('%.fnl$', ''):gsub('[/\\]', '.')
				or nil,
			macro = attributes.macro == true,
			auto_require = attributes['auto-require'] == true,
		}

		table.insert(loader._files, item)
		loader._index[item.path] = item
		if item.auto_require then
			table.insert(loader._auto_requires, item)
		end
	end
end

function Loader:new(config_dir, site_dir)
	config_dir = realpath(config_dir or vim.fn.stdpath('config'))
	local instance = setmetatable({
		_config_dir = config_dir,
		_fnl_dir = vim.fs.joinpath(config_dir, 'fnl'),
		_site_dir = vim.fs.normalize(site_dir or vim.fs.joinpath(
			vim.fn.stdpath('data'),
			'site'
		)),
	}, self)
	loader_collect(instance)
	return instance
end

function Loader:find(path)
	path = vim.fs.normalize(path)
	return self._index[path] or self._index[realpath(path)]
end

function Loader:each()
	return ipairs(self._files)
end


-- [Compiler]

local Compiler = {}
Compiler.__index = Compiler

local function compiler_setup_macro_path(compiler)
	local fennel = compiler._fennel
	local pattern = vim.fs.joinpath(compiler._loader._fnl_dir, '?.fnl')
	local current = fennel['macro-path'] or fennel.macroPath or ''
	if not vim.tbl_contains(vim.split(current, ';'), pattern) then
		current = pattern .. ';' .. current
	end
	fennel.macroPath = current
	fennel['macro-path'] = current
end

function Compiler:new(loader)
	local instance = setmetatable({
		_loader = loader,
		_fennel = require('fennel'),
	}, self)
	compiler_setup_macro_path(instance)
	return instance
end

function Compiler:preprocess(path)
	local item = self._loader:find(path)
	if item == nil then
		return nil, 'source not found: ' .. path
	end

	local source = readfile(item.path)
	if item.macro then
		return source
	end

	local requires = {}
	for _, dependency in ipairs(self._loader._auto_requires) do
		local should_inject = (
			dependency.path ~= item.path
			and (dependency.macro or not item.auto_require)
		)
		if should_inject then
			local form = dependency.macro and 'require-macros' or 'require'
			table.insert(requires, string.format('(%s %q)', form, dependency.module))
		end
	end
	if #requires == 0 then
		return source
	end
	return table.concat(requires, ' ') .. ' ' .. source
end

function Compiler:compile(path)
	local item = self._loader:find(path)
	if item == nil then
		return nil, 'source not found: ' .. path
	end
	if item.macro then
		return true
	end

	local source = self:preprocess(path)
	local compiled = self._fennel.compileString(source, {
		correlate = true,
		filename = item.path,
	})
	writefile(item.output, compiled)
	return true
end


-- [CLI]

if IS_CLI then
	local action = arg[1] or 'help'
	if action == 'help' then
		print(string.format('usage: %s {help|version|update}', arg[0]))
	elseif action == 'version' then
		print(string.format('Fennel %s', Manager:current_version() or 'not installed'))
	elseif action == 'update' then
		local ok, err = Manager:install()
		assert(ok, err)
		print(string.format('Fennel %s is installed', Manager.target_version))
	else
		error('unknown action: ' .. action)
	end
	return
end


-- [User Commands]

local fnlkit_actions = { 'make', 'clean' }
vim.api.nvim_create_user_command('Fnlkit', function(args)
	local action = args.fargs[1]
	local do_clean = action == nil or action == 'clean'
	local do_make = action == nil or action == 'make'
	if not do_clean and not do_make then
		error('unknown action: ' .. action)
	end

	local loader = Loader:new()
	if do_clean then
		for _, item in loader:each() do
			if vim.uv.fs_stat(item.output) ~= nil then
				vim.fs.rm(item.output)
			end
		end
	end
	if do_make then
		local compiler = Compiler:new(loader)
		for _, item in loader:each() do
			assert(compiler:compile(item.path))
		end
		vim.o.runtimepath = vim.o.runtimepath
	end
end, {
	desc = 'Rebuild, compile, or clean Fennel configuration files',
	nargs = '?',
	complete = function()
		return fnlkit_actions
	end,
})

vim.api.nvim_create_user_command('Fnl', function(args)
	local fennel = require('fennel')
	local source = args.args
	local display = source:sub(1, 1) == '='

	if display then
		source = source:gsub('^=%s*', '', 1)
	end
	if args.range > 0 then
		local lines = vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, false)
		source = table.concat(lines, '\n')
	end

	local result = fennel.eval(source)
	if display then
		print(fennel.view(result))
	end
end, {
	desc = 'Evaluate Fennel code',
	nargs = '*',
	range = true,
})


-- [Autocmd]

local group = vim.api.nvim_create_augroup('fnlkit', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
	group = group,
	pattern = '*.fnl',
	callback = function(args)
		local loader = Loader:new()
		local item = loader:find(args.file)
		if item ~= nil then
			assert(Compiler:new(loader):compile(args.file))
			if not item.macro then
				vim.loader.reset(item.output)
			end
		end
	end,
})

vim.api.nvim_create_autocmd('SourceCmd', {
	group = group,
	pattern = '*.fnl',
	callback = function(args)
		require('fennel').dofile(vim.fs.normalize(args.file))
	end,
})


-- vim: tabstop=4 shiftwidth=4
