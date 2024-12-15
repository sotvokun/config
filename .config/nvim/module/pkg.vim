" pkg.vim
"
" pkg.vim is a vim-plug wrapper for managing packages with a manifest file.
"
" SYNTAX:
"    <url> [branch:xxx|tag:xxx|commit:xxx] [as:xxx] [on:xxx] [for:xxx] [frozen]
"
" ATTRIBUTES:
"    branch:xxx | tag:xxx | commit:xxx
"       installing plugin with specific branch/tag/commit
"    as:xxx
"       installing plugin with the specified name as alias
"    on:xxx
"       on-demand loading plugin: commands or `<Plug>` mappings
"    for:xxx
"       on-demand loading plugin: filetypes
"    frozen
"       do not remove and do not update unless explicitly specified
"    do
"       run command after installing plugin
"
" EXAMPLE:
"    github.com/tpope/vim-fugitive
"    github.com/williamboman/mason.nvim frozen
"
" VARIABLES:
"    g:pkg_manifest
"       The path of the plugin manifest file.
"       default:
"           nvim: vim.fs.joinpath(stdpath('config'), 'pkg')
"           vim (Linux/macOS): '~/.vim/pkg'
"           vim (Windows): '~/vimfiles/pkg'
"
"    g:pkg_plug_directory
"       Directory path for installing plugin.
"       default:
"           nvim: stdpath('data') . '/plugged'
"           vim (Linux/macOS): '~/.vim/plugged'
"           vim (Windows): '~/vimfiles/plugged'
"
" REFERENCES:
"    https://vi.stackexchange.com/a/37541
"

if empty(globpath(&runtimepath, 'autoload/plug.vim'))
	echoerr '[pkg.vim] requires vim-plug'
	finish
endif


if exists('g:loaded_pkg')
	finish
endif
let g:loaded_pkg = 1


" Section: Variables
" 
if !exists('g:pkg_manifest')
	let g:pkg_manifest = ''
	if has('nvim')
		let g:pkg_manifest = stdpath('config') . '/pkg'
	elseif has('win32')
		let g:pkg_manifest = expand('~/vimfiles/pkg')
	else
		let g:pkg_manifest = expand('~/.vim/pkg')
	endif
endif

let s:allow_attributes = ['branch', 'commit', 'as', 'tag', 'on', 'for', 'do']


" Section: Functions
"
function s:parse_line(str)
	let str = trim(a:str)
	if len(str) == 0 || str[0] == '#'
		return v:null
	endif
	let parts = split(str, '\s\+', 1)

	let pkg = {
		\ 'as': '',
		\ 'remote': '',
		\ 'branch': '',
		\ 'commit': '',
		\ 'tag': '',
		\ 'on': '',
		\ 'for': '',
		\ 'frozen': 0,
		\ }
	let pkg['remote'] = (parts[0] =~ '^github\.com/')
				\ ? 'https://' . parts[0]
				\ : parts[0]

	for attr_pair in parts[1:]
		if attr_pair == 'fronze'
			let pkg['frozen'] = 1
			continue
		endif
		for attr in s:allow_attributes
			let pattern = printf('^%s:\zs.*\ze$', attr)
			let matched = trim(matchstr(attr_pair, pattern))
			if len(matched) == 0
				continue
			endif
			if stridx(matched, ',') > -1
				let pkg[attr] = map(split(matched, ','), {_, s -> trim(s)})
			else
				let pkg[attr] = matched
			endif
		endfor
	endfor
	return pkg
endfunction

function! s:parse_manifest(path)
	if !filereadable(a:path)
		return []
	endif
	let lines = readfile(a:path)
	let pkgs = []
	for line in lines
		let pkg = s:parse_line(line)
		if empty(pkg)
			continue
		endif
		let pkgs += [pkg]
	endfor
	return pkgs
endfunction

function! s:setup()
	let s:manifest = s:parse_manifest(g:pkg_manifest)
	if exists('g:pkg_plug_directory')
		call plug#begin(g:pkg_plug_directory)
	else
		call plug#begin()
	endif

	for pkg in s:manifest
		let opts = {}
		for attr in s:allow_attributes
			if len(get(pkg, attr, '')) > 0 || type(get(pkg, attr, '')) == type([])
				let opts[attr] = pkg[attr]
			endif
		endfor
		let cmd = empty(opts)
					\ ? printf('Plug ''%s''', pkg['remote'])
					\ : printf('Plug ''%s'', %s', pkg['remote'], opts)
		execute cmd
	endfor
	call plug#end()
endfunction


" Section: Setup
"
call s:setup()


" vim: ts=4 sw=4
