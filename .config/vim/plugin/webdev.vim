if exists('g:loaded_webdev')
	finish
endif
let g:loaded_webdev = 1


let g:webdev_filetype_template = get(g:, 'webdev_filetype_template', ['html'])
let g:webdev_filetype_javascript = get(g:, 'webdev_filetype_javascript', [
	\ 'javascript',
	\ 'javascriptreact',
	\ 'typescript',
	\ 'typescriptreact',
	\ ])
let g:webdev_filetype_style = get(g:, 'webdev_filetype_style', [
	\ 'css',
	\ 'scss',
	\ 'sass',
	\ 'less',
	\ ])


if exists('*LspRegister')
	augroup webdev
		autocmd!
		execute printf('autocmd FileType %s call LspRegister(%s)',
			\ join(g:webdev_filetype_javascript, ','),
			\ {
			\   'name': 'tsserver' ,
			\   'filetypes': g:webdev_filetype_javascript,
			\   'root_pattern': [ 'package.json' ],
			\   'cmd': [ 'typescript-language-server', '--stdio' ],
			\ })

		execute printf('autocmd FileType %s call LspRegister(%s)',
			\ join(g:webdev_filetype_style, ','),
			\ {
			\   'name': 'cssls' ,
			\   'filetypes': g:webdev_filetype_style,
			\   'root_pattern': [ 'package.json' ],
			\   'cmd': [ 'vscode-css-language-server', '--stdio' ],
			\   'capabilities': {
			\     'textDocument': {
			\       'completion': {
			\         'completionItem': {
			\           'snippetSupport': v:true,
			\         }
			\       }
			\     }
			\   },
			\ })
	augroup END
endif
