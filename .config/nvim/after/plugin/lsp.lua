-- after/plugin/lsp.lua
--

local keymap = {
	hover = {'n', 'K', vim.lsp.buf.hover},
	definition = {'n', 'gd', vim.lsp.buf.definition},
	rename = {'n', 'cR', vim.lsp.buf.rename},
	declaration = {'n', 'gD', vim.lsp.buf.declaration},
	code_action = {'n', 'cA', vim.lsp.buf.code_action},
	signature_help = {'i', '<c-l>', vim.lsp.buf.signature_help},
}

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local bufnr = args.buf
		local client_id = args.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)

		local fzf_lua_ok, _ = pcall(require, 'fzf-lua')

		for method, mapping in pairs(keymap) do
			if client.supports_method('textDocument/' .. method) then
				vim.keymap.set(mapping[1], mapping[2], mapping[3], { buffer = bufnr })
			end
		end

		if client.supports_method('textDocument/references') then
			if fzf_lua_ok then
				vim.keymap.set('n', 'gr', '<cmd>FzfLua lsp_references<cr>', { buffer = bufnr })
			else
				vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { buffer = bufnr })
			end
		end

		if client.supports_method('textDocument/documentSymbol') then
			if fzf_lua_ok then
				vim.keymap.set('n', '<leader>s', '<cmd>FzfLua lsp_document_symbols<cr>', { buffer = bufnr })
			else
				vim.keymap.set('n', '<leader>s', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', { buffer = bufnr })
			end
		end

		if client.supports_method('textDocument/inlayHint') then
			vim.keymap.set('n', 'zY', function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
			end, { buffer = bufnr })
		end

		-- if client.supports_method('textDocument/formatting') then
		-- 	vim.api.nvim_create_autocmd('BufWritePre', {
		-- 		buffer = bufnr,
		-- 		callback = function()
		-- 			vim.lsp.buf.format({ bufnr = bufnr, id = client_id })
		-- 		end
		-- 	})
		-- end

		if client.supports_method('textDocument/documentHighlight') then
			local group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
			vim.api.nvim_create_autocmd({'CursorHold', 'InsertLeave'}, {
				buffer = bufnr,
				callback = vim.lsp.buf.document_highlight,
				group = group
			})
			vim.api.nvim_create_autocmd({'CursorMoved', 'InsertEnter'}, {
				buffer = bufnr,
				callback = vim.lsp.buf.clear_references,
				group = group
			})
		end
	end
})
