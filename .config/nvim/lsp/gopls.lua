return {
	cmd = { 'gopls' },
	filetypes = { 'go' },
	root_dir = { 'go.mod' },
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
	},
}
