(vscode-incompatible!)

(with-module [lsp :lsp]
  (augroup lsp#)

  ; --------------------

  (fn lsp-attach [args]
    (let [buf args.buf
          client (vim.lsp.get_client_by_id args.data.client_id)]
      (do
        ; Document Highlight
        (when (client.supports_method :textDocument/documentHighlight)
          (autocmd lsp# [CursorHold InsertLeave]
                   :buffer buf
                   :callback vim.lsp.buf.document_highlight)
          (autocmd lsp# [CursorMoved InsertEnter]
                   :buffer buf
                   :callback vim.lsp.buf.clear_references))
        
        ; Keymaps
        (keymap [n] :K vim.lsp.buf.hover :buffer buf)
        (keymap [n] :gd vim.lsp.buf.definition :buffer buf)
        (keymap [n] :gD vim.lsp.buf.declaration :buffer buf)
        (keymap [n] :gr vim.lsp.buf.references :buffer buf)
        (keymap [n] :gR vim.lsp.buf.rename :buffer buf)
        
        (keymap [n] "<c-.>" vim.lsp.buf.code_action :buffer buf)
        (keymap [i] "<c-.>" vim.lsp.buf.signature_help :buffer buf))))

  (autocmd lsp# [LspAttach] :callback lsp-attach :buffer buf)
        
  
  ; --------------------
  
  (command :LspStart #(lsp.enable))
  (command :LspStop #(lsp.disable)))
