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
        (keymap [n] :K vim.lsp.buf.hover                            :buffer buf :desc "Hover")
        (keymap [n] :gd "<cmd>Pick lsp.definition<cr>"              :buffer buf :desc "Go to definition")
        (keymap [n] :gD "<cmd>Pick lsp.declaration<cr>"             :buffer buf :desc "Go to declaration")
        (keymap [n] :gr "<cmd>Pick lsp.references<cr>"              :buffer buf :desc "Go to references")
        (keymap [n] :gI "<cmd>Pick lsp.implementation<cr>"          :buffer buf :desc "Go to implementation")
        (keymap [n] :gR vim.lsp.buf.rename                          :buffer buf :desc "Rename")
        (keymap [n] :<leader>s "<cmd>Pick lsp.document_symbol<cr>"  :buffer buf :desc "Open document symbol picker")
        (keymap [n] :<leader>S "<cmd>Pick lsp.workspace_symbol<cr>" :buffer buf :desc "Open workspace symbol picker")
        
        (keymap [n] "<c-.>" vim.lsp.buf.code_action    :buffer buf :desc "Code action")
        (keymap [i] "<c-.>" vim.lsp.buf.signature_help :buffer buf :desc "Signature helper"))))

  (autocmd lsp# [LspAttach] :callback lsp-attach :buffer buf)
        
  
  ; --------------------
  
  (command :LspStart #(lsp.enable))
  (command :LspStop #(lsp.disable)))
