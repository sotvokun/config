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
	},
	on_attach = function(client, bufnr)
		local lsp_gopls_augroup = vim.api.nvim_create_augroup('lsp#gopls', {})
		if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = lsp_gopls_augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

-- vim: ts=4
