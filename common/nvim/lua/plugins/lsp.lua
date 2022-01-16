local lsp_installer = require('nvim-lsp-installer')
local lsp_config = require('lspconfig')

lsp_config.racket_langserver.setup{}

lsp_installer.on_server_ready(function(server)
    local opts = {}

    local server_opts = {
        ["sumneko_lua"] = function()
            opts.settings = {
                diagnostics = {
                    globals = {"vim"}
                }
            }
        end
    }

    local server_option = server_opts[server.name] and
                            server_opts[server.name]() or
                            opts
    server:setup(server_option)
end)
