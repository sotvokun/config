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
        (keymap [n] "<leader>qh" #(vim.lsp.inlay_hint buf) :buffer buf :desc "Toggle inlay hint"))

      ; textDocument/completion
      (when (client.supports_method :textDocument/completion)
        (with-module [compl :lsp_compl]
          (vim.cmd "set completeopt+=noinsert")
          (let [{: expand_snippet} (require :snippy)]
            (set compl.expand_snippet expand_snippet))
          (keymap [i] :<cr> #(if (compl.accept_pum) :<c-y> :<cr>) :expr true :buffer true)
          (compl.attach client buf {}))))))

(autocmd
  lsp# [LspDetach]
  :callback
  (fn [{: buf :data {: client_id}}]
    (do
      (tset vim.b buf :lsp nil)
      (with-module [compl :lsp_compl]
        (compl.detach client_id buf))
      (autocmd lsp# [*] :buffer buf))))

; (autocmd lsp# [LspProgress] :pattern "*" :command "redrawstatus")

(command :LspStart #(let [lsp (require :lsp)] (lsp.enable)))
(command :LspStop #(let [lsp (require :lsp)] (lsp.disable)))
