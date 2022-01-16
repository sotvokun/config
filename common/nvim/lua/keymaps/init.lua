local keymapping = {
    -- Telescope
    {"<leader><space>f", "<cmd>Telescope file_browser<cr>", "File browser"},
    {"<leader><space>b", "<cmd>Telescope buffers<cr>", "Buffers"},

    -- LSP
    {"gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration"},
    {"gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition"},
    {"gi", "<cmd>lua vim.lsp.buf.implementation<CR>", "Go to implementation"},
    {"gr", "<cmd>lua vim.lsp.buf.references()<CR>", "Go to references"},
    {"gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to type definitions"},
    {"K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover"},
    {"<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Get signature"},
    {"cr", "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename"}
}

return keymapping
