" vlsp.vim
"
" Neovim/Vim universal LSP manager
"
" Use vlsp like vim-plug:
"   call vlsp#begin()
"   LspAdd tsserver typescript-language-server 
"   LspAdd pyright pyright
"   call vlsp#end()
"
" When you called `vlsp#begin()`, actually the whole LSP features are enabled.
" You can start/stop LSP servers by `LspStart` and `LspStop` commands.
" Also you can load LSP configurations from `vlsp.json` with `LspLoadConfig`.
"
" The `vlsp.json` should be like:
"   {
"     "languageserver": {
"       "tsserver": {
"         "command": "typescript-language-server",
"         "args": ["--stdio"],
"         "rootPatterns": ["package.json"],
"         "filetypes": ["typescript", "typescriptreact"],
"         "enable": 1
"      }
"   }
"
" The fields of LSP configuration are:
"  - command: The command to start the LSP server
"  - args: The arguments to start the LSP server
"  - detached: Whether the LSP server is detached or not
"  - trace: The trace level of the LSP server
"  - initializationOptions: The initialization options of the LSP server
"  - settings: The settings of the LSP server
"  - enable: Whether the LSP server is enabled or not
"  - rootPatterns: The root patterns of the LSP server
"  - filetypes: The filetypes of the LSP server
"
" When you called `vlsp#end()` without `g:vscode`, the LSP servers will be
" started automatically by the filetypes.

if exists('g:loaded_vlsp')
	finish
endif
let g:loaded_vlsp = 1


let s:template_config = {
	\ 'command': '',
	\ 'args': [],
	\ 'detached': 1,
	\ 'trace': 'off',
	\ 'initializationOptions': {},
	\ 'settings': {},
	\ 'enable': 1,
	\ 'rootPatterns': [],
	\ 'filetypes': [],
	\ }
let s:cfg_home = has('nvim') ? stdpath('config') : split(&rtp, ',')[0]
let s:base_config = {
	\ 'config_home': s:cfg_home,
	\ 'local_config': 'vlsp.json',
	\ 'lsp_engine': has('nvim') ? 'nvim' : '',
	\ }


function! vlsp#begin(...)
	let config = copy(s:base_config)
	if a:0 > 0 && type(a:1) == type({})
		let config = extend(config, a:1)
	endif

	let g:vlsp_config_home = get(g:, 'vlsp_config_home', config['config_home'])
	let g:vlsp_local_config = get(g:, 'vlsp_local_config', config['local_config'])
	let g:vlsp_lsp_engine = get(g:, 'vlsp_lsp_engine', config['lsp_engine'])
	let g:vlsps = {}

	call s:define_commands()
	return 1
endfunction


function! s:define_commands()
	command! -nargs=+ LspAdd call vlsp#add(<f-args>)
	command! -nargs=0 LspLoadConfig call vlsp#load_config()
	command! -nargs=1
		\ -complete=customlist,s:complete_vlsps
		\ LspStart call vlsp#start_by_name(<f-args>)
	command! -nargs=?
		\ -complete=customlist,s:complete_activated_clients
		\ LspStop call vlsp#stop_by_name(<f-args>)
endfunction


function! vlsp#add(name, cmd, ...)
	let config = has_key(g:vlsps, a:name)
		\ ? g:vlsps[a:name]
		\ : copy(s:template_config)
	if len(trim(a:cmd)) > 0
		let cmd = a:cmd
		if has('win32')
			for ext in ['.exe', '.cmd']
				if executable(cmd . ext)
					let cmd = cmd . ext
					break
				endif
			endfor
		endif
		let config['command'] = cmd
	endif
	if a:0 > 0 && type(a:1) == type({})
		let config = extend(config, a:1)
	endif
	let g:vlsps[a:name] = config
endfunction


function! vlsp#load_config()
	let config_paths = [
		\ fnameescape(g:vlsp_config_home . '/vlsp.json'),
		\ fnameescape(getcwd() . '/' . g:vlsp_local_config),
		\ ]
	for path in config_paths
		if !filereadable(path)
			continue
		endif
		let contents = join(readfile(path), "\n")
		let config = json_decode(contents)
		for [name, cfg] in items(get(config, 'languageserver', {}))
			call vlsp#add(name, '', cfg)
		endfor
	endfor
endfunction


function! s:complete_vlsps(A, L, P)
	return keys(g:vlsps)
endfunction


function! vlsp#start_by_name(name)
	if !has_key(g:vlsps, a:name)
		echoerr printf('LSP config "%s" not found', a:name)
		return
	endif
	if g:vlsp_lsp_engine == 'nvim'
		let cfg = s:to_nvim_lsp(a:name, g:vlsps[a:name])
		call v:lua.vim.lsp.start(cfg)
	endif
endfunction


function! s:to_nvim_lsp(name, cfg)
	let cmd = [get(a:cfg, 'command', '')] + get(a:cfg, 'args', [])
	let root_pattern = get(a:cfg, 'rootPatterns', [])
	let lspcfg = {
		\ 'name': a:name,
		\ 'cmd': cmd,
		\ 'detached': get(a:cfg, 'detached', 1) ? v:true : v:false,
		\ 'trace': get(a:cfg, 'trace', 'off'),
		\ 'settings': get(a:cfg, 'settings', {}),
		\ 'init_options': get(a:cfg, 'initializationOptions', {}),
		\ }
	if len(root_pattern) != 0
		let dirs = v:lua.vim.fs.find(root_pattern, {
			\ 'upward': v:true,
			\ })
		if len(dirs) > 0
			let lspcfg['root_dir'] = v:lua.vim.fs.dirname(dirs[0])
		endif
	endif
	for lspopt in [
		\ 'workspace_folders', 'capabilities', 'offset_encoding',
		\ 'on_error', 'before_init', 'on_init', 'on_exit', 'on_attach']
		if !has_key(a:cfg, lspopt)
			continue
		endif
		if lspopt == 'capabilities'
			call s:luafunc_begin()
			let lspcfg[lspopt] =
				\ v:lua.lsp_setup_capabilities(get(a:cfg, lspopt))
			call s:luafunc_end()
		else
			let lspcfg[lspopt] = get(a:cfg, lspopt)
		endif
	endfor
	return lspcfg
endfunction


function! s:complete_activated_clients(A, L, P)
	if g:vlsp_lsp_engine == 'nvim'
		call s:luafunc_begin()
		let clients = v:lua.lsp_get_clients({'bufnr': bufnr('%')})
		let vlsps = keys(g:vlsps)
		call s:luafunc_end()
		return filter(clients, {_, v -> index(vlsps, v) > -1})
	endif
	return []
endfunction


function! vlsp#stop_by_name(...)
	if g:vlsp_lsp_engine == 'nvim'
		call s:luafunc_begin()
		if a:0 > 0 && a:1 !~# '*'
			let opts = {'name': a:1}
		else
			let opts = {}
		endif
		let clients = v:lua.lsp_get_clients(opts, 'id')
		call v:lua.vim.lsp.stop_client(clients, v:true)
		call s:luafunc_end()
		return
	endif
endfunction


function! s:luafunc_begin()
	lua _G.lsp_get_clients = function(opts, field)
		\ local opts = opts and opts or {}
		\ local field = field and field or 'name'
		\ return vim.tbl_map(
		\	function(m) return m[field] end,
		\	vim.lsp.get_clients(opts)
		\ )
		\ end
	lua _G.lsp_setup_capabilities = function(user_cap)
		\ local capabilities = vim.lsp.protocol.make_client_capabilities()
		\ local cmp_lsp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
		\ if cmp_lsp_ok then
		\	capablities = vim.tbl_deep_extend(
		\		'keep',
		\		capabilities,
		\		cmp_lsp.default_capabilities()
		\	)
		\ end
		\ capabilities = vim.tbl_deep_extend(
		\		'keep',
		\		capabilities,
		\		user_cap
		\	)
		\ return capabilities
		\ end
endfunction


function! s:luafunc_end()
	lua _G.lsp_get_clients = nil
	lua _G.lsp_setup_capabilities = nil
endfunction


function! vlsp#end()
	if exists('g:vscode')
		return
	endif
	augroup vlsp
		autocmd!
		autocmd FileType * call vlsp#start_by_ft(expand('<amatch>'))
	augroup END
endfunction


function! vlsp#start_by_ft(ft)
	if g:vlsp_lsp_engine == 'nvim'
		let clients = filter(
			\ items(g:vlsps),
			\ {_, v -> index(get(v[1], 'filetypes', []), a:ft) > -1})
		let clients = filter(
			\ clients,
			\ {_, v -> get(v[1], 'enable', 1)})
		for [name, cfg] in clients
			let lspcfg = s:to_nvim_lsp(name, cfg)
			call v:lua.vim.lsp.start(lspcfg)
		endfor
	endif
endfunction


function! vlsp#get_clients()
	if g:vlsp_lsp_engine == 'nvim'
		call s:luafunc_begin()
		let clients = v:lua.lsp_get_clients({'bufnr': bufnr('%')})
		call s:luafunc_end()
		return clients
	endif
	return []
endfunction

" vim: set ts=4 sw=4
