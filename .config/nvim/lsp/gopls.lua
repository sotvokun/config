-- lsp/gopls.lua
--

return vim.lsp.define_config('gopls', {
	cmd = { 'gopls' },
	root_dir = function(buf, on_dir)
		local root = vim.fs.root(buf, { 'go.mod' })
		if not root then
			return
		end

		local workspace = vim.fs.root(root, { 'go.work' })
		on_dir(workspace or root)
	end,
	filetypes = { 'go', 'gomod', 'gowork', 'gosum' },
	settings = {
		autoformat = true,
		gopls = {
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				nilness = true
			},
			gofumpt = true,
			semanticTokens = true,
			staticcheck = true
		}
	}
})

-- vim: ts=4
