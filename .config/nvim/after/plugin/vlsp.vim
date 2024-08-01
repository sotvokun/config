" after/plugin/vlsp.vim - vlsp and lsp configurations
"

if exists('g:loaded_vlsp_after')
	finish
endif
let g:loaded_vlsp_after = 1

if exists('g:vscode')
	finish
endif

if g:vlsp_lsp_engine == 'nvim'
	function! s:has_diagnostic()
		let l:diagnostics = v:lua.vim.diagnostic.get()
		let l:ln = line('.') - 1
		let l:col = col('.') - 1
		let l:diagnostics = filter(l:diagnostics,
			\ {_, v ->
			\	(l:ln >= v.lnum && l:ln <= v.end_lnum) &&
			\	(l:col >= v.col && l:col <= v.end_col)})
		return !empty(l:diagnostics)
	endfunction

	function! s:setup_mappings()
		nnoremap <buffer><expr> K <SID>has_diagnostic()
					\ ? '<cmd>lua vim.diagnostic.open_float()<cr>'
					\ : '<cmd>lua vim.lsp.buf.hover()<cr>'
		nnoremap <buffer> gK <cmd>lua vim.lsp.buf.hover()<cr>
		nnoremap <buffer> gd <cmd>lua vim.lsp.buf.definition()<cr>
		nnoremap <buffer> gD <cmd>lua vim.lsp.buf.declaration()<cr>
		nnoremap <buffer> cR <cmd>lua vim.lsp.buf.rename()<cr>
		nnoremap <buffer> cA <cmd>lua vim.lsp.buf.code_action()<cr>
		nnoremap <buffer> gr <cmd>lua vim.lsp.buf.references()<cr>
		inoremap <buffer> <c-h> <cmd>lua vim.lsp.buf.signature_help()<cr>

		nnoremap <buffer> <leader>s <cmd>lua vim.lsp.buf.document_symbol()<cr>
		nnoremap <buffer> <leader>S <cmd>lua vim.lsp.buf.workspace_symbol()<cr>
		nnoremap <buffer> <leader>d <cmd>LspDiagnostics<cr>
		nnoremap <buffer> <leader>D <cmd>LspDiagnosticsAll<cr>
	endfunction

	augroup vlsp_after
		autocmd!
		autocmd LspAttach * call s:setup_mappings()
	augroup END

	lua vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
		\ vim.lsp.handlers.hover, {
		\	focusable = true,
		\ })

	lua vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
		\ vim.lsp.handlers.signature_help, {
		\	focusable = false,
		\ })

	lua vim.diagnostic.config((function()
		\ return {
		\	update_in_insert = true,
		\	signs = {
		\		severity = { min = vim.diagnostic.severity.INFO }
		\	},
		\	virtual_text = {
		\		severity = {
		\			min = vim.diagnostic.severity.WARN
		\		},
		\		format = function(diagnostic)
		\			if diagnostic.severity == vim.diagnostic.severity.ERROR then
		\				return diagnostic.message
		\			end
		\			return ''
		\		end
		\	}
		\ }
		\ end)())
endif
