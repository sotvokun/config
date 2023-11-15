" lsp.vim
"
" - lsp.vim

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
endfunction
