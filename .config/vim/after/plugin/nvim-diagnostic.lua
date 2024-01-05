local severity = vim.diagnostic.severity

vim.diagnostic.config({
    underline = true,
    signs = {
        severity = {
            min = severity.WARN,
        }
    },
})

vim.fn.sign_define('DiagnosticSignError', {text = '!!', texthl = 'DiagnosticSignError'})
vim.fn.sign_define('DiagnosticSignWarn',  {text = '!',  texthl = 'DiagnosticSignWarn' })

vim.cmd([[
nnoremap <silent> <leader>d <cmd>lua vim.diagnostic.open_float()<cr>
]])
