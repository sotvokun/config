" Options:
"  - path: plug path
function! pkg#provider#plug(pkgs, opts)
	if get(a:opts, 'path', v:null) != v:null
		call plug#begin(a:opts['path'])
	else
		call plug#begin()
	endif
	for pkg in a:pkgs
		let opts = {}
		if len(pkg['branch']) != 0
			let opts['branch'] = pkg['branch']
		endif
		if len(pkg['commit']) != 0
			let opts['commit'] = pkg['commit']
		endif
		if len(pkg['name']) != 0
			let opts['as'] = pkg['name']
		endif
		if pkg['sync'] != 1
			let opts['frozen'] = 1
		endif

		let l:pkg_for = get(pkg, '_for', '')
		if len(l:pkg_for) != 0 && ((has('nvim') && l:pkg_for != 'nvim') || (!has('nvim') && l:pkg_for != 'vim'))
			continue
		endif
		let cmd = printf('Plug ''%s'', %s', pkg['remote'], opts)
		execute cmd
	endfor
	call plug#end()
endfunction


function! pkg#provider#jetpack(pkgs, opts)
	if get(a:opts, 'path', v:null) != v:null
		call jetpack#begin(a:opts['path'])
	else
		call jetpack#begin()
	endif
	for pkg in a:pkgs
		let opts = {}
		if len(pkg['branch']) != 0
			let opts['branch'] = pkg['branch']
		endif
		if len(pkg['commit']) != 0
			let opts['commit'] = pkg['commit']
		endif
		if len(pkg['name']) != 0
			let opts['as'] = pkg['name']
		endif

		let l:pkg_for = get(pkg, '_for', '')
		if len(l:pkg_for) != 0 && ((has('nvim') && l:pkg_for != 'nvim') || (!has('nvim') && l:pkg_for != 'vim'))
			continue
		endif
		let cmd = printf('Jetpack ''%s'', %s', pkg['remote'], opts)
		execute cmd
	endfor
	call jetpack#end()
endfunction
