" lsp.vim
"
" A plugin that setup LSP related mappings quickly.

function! s:setup_mapping()
    nnoremap <buffer> K <cmd>lua vim.lsp.buf.hover()<cr>
    nnoremap <buffer> gd <cmd>lua vim.lsp.buf.definition()<cr>
    nnoremap <buffer> gD <cmd>lua vim.lsp.buf.declaration()<cr>
    nnoremap <buffer> <c-x>gR gR
    nnoremap <buffer> gR <cmd>lua vim.lsp.buf.rename()<cr>
endfunction

augroup LspConfig
    au!
    autocmd LspAttach * call s:setup_mapping()
augroup END

" vim: et sw=4 cc=80
