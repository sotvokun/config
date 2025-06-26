(exit-if-vscode!)

(exit-if! vim.g.loaded_plugin_lsp)
(set vim.g.loaded_plugin_lsp true)

(augroup lsp)
(autocmd :LspAttach "*"
         #(let [bufnr (. $1 "buf")
                client-id (. (. $1 "data") "client_id")
                client (vim.lsp.get_client_by_id client-id)
                keymap-opts {:buffer bufnr}]
            (do
              (when (client.supports_method "textDocument/formatting")
                (autocmd :BufWritePre "*"
                         #(when (and client.settings.autoformat (= 0 (length (. (. vim.bo bufnr) :formatprg))))
                            (vim.lsp.buf.format {: bufnr :id client-id}))))
              (when (client.supports_method "textDocument/hover")
                (keymap n :K vim.lsp.buf.hover keymap-opts))
              (when (client.supports_method "textDocument/definition")
                (keymap n :gd vim.lsp.buf.definition keymap-opts))
              (when (client.supports_method "textDocument/references")
                (keymap n :gr vim.lsp.buf.references keymap-opts))
              (when (client.supports_method "textDocument/rename")
                (keymap n :cR vim.lsp.buf.rename keymap-opts))
              (when (client.supports_method "textDocument/declaration")
                (keymap n :gD vim.lsp.buf.declaration keymap-opts))
              (when (client.supports_method "textDocument/codeAction")
                (keymap n :cA vim.lsp.buf.code_action keymap-opts))
              (when (client.supports_method "textDocument/signatureHelp")
                (keymap i :<c-l> vim.lsp.buf.signature_help keymap-opts))))
            {:group "lsp"})


(fn get-clients []
  (let [folder (vim.fs.joinpath (vim.fn.stdpath "config") "lsp")
        files (vim.fn.readdir folder)]
    (icollect [_ v (ipairs files)]
      (string.gsub v "^(.+)%.fnl$" "%1"))))

(vim.lsp.enable (get-clients))
