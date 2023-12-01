-- web.lua
--
-- A quickly setup for to start lsp server

-- Definitions

--- Javascript
local WEB_FILETYPE_SCRIPT = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
}
if not vim.g.web_filetype_script then
    vim.g.web_filetype_script = WEB_FILETYPE_SCRIPT
end

--- Template
local WEB_FILETYPE_TEMPLATE = {
    'html'
}
if not vim.g.web_filetype_template then
    vim.g.web_filetype_template = WEB_FILETYPE_TEMPLATE
end

--- Style
local WEB_FILETYPE_STYLE = {
    'css',
    'sass',
    'scss',
    'less'
}
if not vim.g.web_filetype_style then
    vim.g.web_filetype_style = WEB_FILETYPE_STYLE
end


-- Language Server

local lsp = require('lsp')

--- Javascript and Typescript

lsp.register({
    name = 'tsserver',
    filetypes = vim.g.web_filetype_script,
    cmd = { 'typescript-language-server', '--stdio' },
    root_pattern = { 'package.json' }
})

lsp.register({
    name = 'cssls',
    filetypes = vim.g.web_filetype_style,
    cmd = { 'vscode-css-language-server', '--stdio' },
    root_pattern = { 'package.json' },
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true
                }
            }
        }
    }
})

-- vim: et sw=4 cc=80
