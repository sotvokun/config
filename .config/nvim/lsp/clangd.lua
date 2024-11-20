return {
	cmd = { 'clangd' },
	filetypes = { 'c', 'cpp' },
	root_dir = {
		'.clangd', '.clang-tidy', '.clang-format',
		'compile_commands.json', 'compile_flags.txt',
		'.git'
	},
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { 'utf-8', 'utf-16' },
	},
}
