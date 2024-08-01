" pkg.vim
"
" pkg.vim is a minimal "frontend" for vim/neovim plugin managers,
" it defined a unified DSL to describe plugins version and type.
"
" SUPPORTS:
"
" SYNTAX:
"     <URL> [opt] [sync] [branch:xxx] [tag:xxxx] [commit:xxx] [name:xxx] [!vim]
"           [!nvim]
"
" ATTRIBUTES:
"     opt
"         installing plugin as optional, you should load it with `packadd`
"     sync
"         plugin should be synchronized with remote
"     branch:xxx | tag:xxx | commit:xxx
"         install plugin with specified branch/tag/commit
"         (not all plugin managers implemented)
"     name:xxx
"         plugin with be installed with the specified name as alias,
"         the default name is depended by plugin managers
"     !vim
"         installing plugin for vim only
"     !nvim
"         installing plugin for neovim only
"     *key:value
"         plugin manager specific attributes
"
" EXAMPLE:
"      github.com/tpope/vim-fugitive
"      github.com/williamboman/mason.nvim      sync
"
" USER COMMAND:
"      PkgAdd
"          `:PkgAdd`           packadd all optional packages
"          `:PkgAdd foo`       packadd specified packages by pass package name
"          `:PkgAdd foo bar`   also can add multiple packages
"          `:PkgAdd *`         add all packages with pass the asterisk
"          `:PkgAdd * !foo !bar`
"                              add all packages excluding specified packages
"
" FUNCTIONS:
"      pkg#initialize()
"          Notify the plugin manager to handle plugins that defined in manifest.
"          This function are usually put in user vimrc file. To make the
"          plugin loaded before sourcing `/after` directory.
"
"      pkg#add(...)
"          The implementation of `PkgAdd` usercommand.
"
" AUTOCMD:
"      User PkgAddPre:<pkgname>
"      User PkgAddPost:<pkgname>
"          If you use `PkgAdd` usercommand to load optional package, there are
"          two autocmd will be invoked before and after `packadd`. You could
"          use this mechanism to implement lazy loading.
"
"          <pkgname> is transformed from any string to camel-case.
"          The transformation looks like the following pipes:
"          ```
" pkgname | splitwith(['.', '-', '_']) | map(i -> upperfirst(i)) | join('')
"          ```
"          exmaple:
"              vim-fugitive -> VimFugitive
"              mason.nvim -> MasonNvim
"
" VARIABLES:
"      g:pkg_manifest
"          The path of the plugin manifest file.
"          default:
"              nvim: stdpath('config') . '/pkg'
"              vim: $HOME . '/.vim/pkg'
"
"      g:pkg_name_separator
"          The separator to split plugin name to parts.
"          (Default: [',', '-', '_', '.'])
"
"      g:pkg_allow_attributes
"          The attributes that pkg can offer to plugin manager.
"          (Default: ['branch', 'commit', 'name'])
"          The default value of this variable is minimalist, you could add
"          more supported attributes for your plugin manager.
"          NOTE: `opt` and `sync` are always useable
"
"      g:pkg_provider
"          (Default: plug)
"
"      g:pkg_provider_option
"          (Default: {})
"

if exists('g:loaded_pkg')
	finish
endif
let g:loaded_pkg = 1


" Section: variables

if !exists('g:pkg_manifest')
	let g:pkg_manifest = has('nvim')
		\ ? stdpath('config') . '/pkg'
		\ : $HOME . '/.vim/pkg'
endif

if !exists('g:pkg_name_separator')
	let g:pkg_name_separator = [',', '-', '_', '.']
endif

if !exists('g:pkg_allow_attributes')
	let g:pkg_allow_attributes = ['branch', 'commit', 'name']
endif

if !exists('g:pkg_provider')
	let g:pkg_provider = 'plug'
endif

if !exists('g:pkg_provider_option')
	let g:pkg_provider_option = {}
endif


" Section: functions

function! s:parse_line(str)
	let l:str = trim(a:str)
	if l:str[0] == '#' || len(l:str) == 0
		return v:null
	endif
	let l:parts = split(l:str, '\s\+', 1)
	let l:pkg = {
		\ 'name': '',
		\ 'opt': 0,
		\ 'sync': 0,
		\ 'branch': '',
		\ 'remote': '',
		\ 'commit': '',
		\ '_for': '',
		\ '_attr': {},
		\ }
	let l:name_parts = split(l:parts[0], '\/', 1)
	let l:pkg['name'] = l:name_parts[len(l:name_parts) - 1]
	let l:pkg['remote'] = 'https://' . l:parts[0]

	for attr in l:parts[1:]
		if attr[0] == '*'
			let parts = split(attr[1:], ':')
			let l:pkg['_attr'][parts[0]] = parts[1]
		elseif attr == 'opt'
			let l:pkg['opt'] = 1
		elseif attr == '!vim'
			let l:pkg['_for'] = 'vim'
		elseif attr == '!nvim'
			let l:pkg['_for'] = 'nvim'
		elseif attr == 'sync'
			let l:pkg['sync'] = 1
		else
			for var_attr in g:pkg_allow_attributes
				let l:pattern = printf('^%s:\zs.*\ze$', var_attr)
				let match = matchstr(attr, l:pattern)
				if match != ''
					let pkg[var_attr] = match
					continue
				endif
			endfor
		endif
	endfor
	return l:pkg
endfunction

function! s:parse_manifest()
	if !filereadable(g:pkg_manifest)
		return []
	endif
	let l:lines = readfile(g:pkg_manifest)
	let l:pkgs = []
	for line in l:lines
		let l:pkg = s:parse_line(line)
		if empty(l:pkg)
			continue
		endif
		let l:pkgs += [l:pkg]
	endfor
	return l:pkgs
endfunction


function! s:transform_pkg_name(name)
	let l:name = a:name
	for sep in g:pkg_name_separator
		let l:sep = sep == '-' || sep == '_'
			\ ? sep
			\ : printf('\\%s', sep)
		let l:name = substitute(l:name, l:sep, ' ', 'g')
	endfor
	let l:parts = split(l:name, '\s+', 1)
	let l:parts = map(parts, 'substitute(v:val, "^\\l", "\\u\\0", "")')
	return join(l:parts, '')
endfunction

function! s:do_add(...)
	let pkgs = s:parse_manifest()
	let fargs = a:000
	let optpkgs = filter(pkgs, {_, v -> v['opt'] == 1})
	let optpkg_names = map(pkgs, {_, p -> p['name']})

	let proc_pkgs = []
	if len(fargs) == 0
		let proc_pkgs = optpkg_names
	else
		for pkg in fargs
			if pkg == '*'
				let proc_pkgs += optpkg_names
			elseif pkg[0] == '!'
				let proc_pkgs = filter(
					\ proc_pkgs,
					\ {_, p -> p != p[1:]})
			else
				let proc_pkgs += [pkg]
			endif
		endfor
	endif

	for pkg_name in proc_pkgs
		let proc_pkg_name = s:transform_pkg_name(pkg_name)
		silent! execute 'doautocmd User PkgAddPre:' . proc_pkg_name
		execute 'packadd ' . pkg_name
		silent! execute 'doautocmd User PkgAddPost:' . proc_pkg_name
	endfor
endfunction


" Section: commands

command! -nargs=* PkgAdd call s:do_add(<f-args>)


" Section: setup

let s:Provider = function(printf('pkg#provider#%s', g:pkg_provider))
call s:Provider(s:parse_manifest(), g:pkg_provider_option)
