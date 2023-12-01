" lsp.vim
"
" - lsp.vim
" - vim.lsp

if exists('g:vscode')
    finish
endif

augroup LspMapping
    au!
    autocmd LspAttach * call s:setup_mappings()
augroup END

function! s:setup_mappings()
    nnoremap <buffer> K <cmd>lua vim.lsp.buf.hover()<cr>
    nnoremap <buffer> gd <cmd>lua vim.lsp.buf.definition()<cr>
    nnoremap <buffer> gD <cmd>lua vim.lsp.buf.declaration()<cr>
    nnoremap <buffer> <c-x>gR gR
    nnoremap <buffer> gR <cmd>lua vim.lsp.buf.rename()<cr>
    inoremap <buffer> <c-h> <cmd>lua vim.lsp.buf.signature_help()<cr>
    nnoremap <buffer> <leader>ca <cmd>lua vim.lsp.buf.code_action()<cr>
endfunction

lua vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    \ vim.lsp.handlers.hover, {
    \   focusable = false,
    \ })

lua vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    \ vim.lsp.handlers.signature_help, {
    \   focusable = false,
    \ })
