-- lsp/gopls.lua
--

local function organize_imports(client, bufnr)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { 'source.organizeImports' } }
	local result = client:request_sync(
		'textDocument/codeAction',
		params,
		3000,
		bufnr
	)
	for _, action in ipairs(result and result.result or {}) do
		if action.edit then
			vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
		end
	end
end

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
		gopls = {
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				nilness = true
			},
			gofumpt = true,
			semanticTokens = true,
			staticcheck = false,
		}
	},
	on_attach = function(client, bufnr)
		local lsp_gopls_augroup = vim.api.nvim_create_augroup('lsp#gopls', {
			clear = false,
		})
		if client:supports_method('textDocument/formatting') then
			vim.api.nvim_clear_autocmds({
				group = lsp_gopls_augroup,
				buffer = bufnr,
				event = 'BufWritePre',
			})
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = lsp_gopls_augroup,
				buffer = bufnr,
				callback = function()
					organize_imports(client, bufnr)
					vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 3000 })
				end,
			})
		end
	end,
})

-- vim: ts=4
