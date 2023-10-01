(augroup lsp#)

(fn handle-document-highlight [buf]
  (do
    (autocmd lsp# [CursorHold InsertLeave] 
             :buffer buf
             :callback vim.lsp.buf.document_highlight)
    (autocmd lsp# [CursorMoved InsertEnter] 
             :buffer buf
             :callback vim.lsp.buf.clear_references)))


(autocmd
  lsp# [LspAttach] 
  :callback 
  (fn [{: buf :data {: client_id}}]
    (do
      (local client (vim.lsp.get_client_by_id client_id))
      (tset vim.b buf :lsp client.name)

      ; Keymap
      (keymap [n] "gr" vim.lsp.buf.references :buffer buf)
      (keymap [i] "<c-q>" vim.lsp.buf.signature_help :buffer buf)
      (keymap [n] "gR" vim.lsp.buf.rename :buffer buf)
      (keymap [n] "<c-cr>" vim.lsp.buf.code_action :buffer buf)
      (keymap [n] "K" vim.lsp.buf.hover :buffer buf)

      ; textDocument/documentHighlight
      (when (client.supports_method :textDocument/documentHighlight)
        (handle-document-highlight buf))

      ; textDocument/inlayHint
      (when (client.supports_method :textDocument/inlayHint)
        (keymap [n] "<leader>qh" #(vim.lsp.inlay_hint buf) :buffer buf :desc "Toggle inlay hint")))))

      ; textDocument/completion
      ; - Inject by MiniCompletion

(autocmd
  lsp# [LspDetach]
  :callback
  (fn [{: buf :data {: client_id}}]
    (do
      (tset vim.b buf :lsp nil)
      (autocmd lsp# [*] :buffer buf))))

; (autocmd lsp# [LspProgress] :pattern "*" :command "redrawstatus")

(command :LspStart #(let [lsp (require :lsp)] (lsp.enable)))
(command :LspStop #(let [lsp (require :lsp)] (lsp.disable)))
