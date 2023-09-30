; ------------------------------------------------ 
;  lsp.fnl
;
;  REFERENCE: 
;  https://github.com/gpanders/dotfiles/blob/master/.config/nvim/fnl/lsp.fnl
; ------------------------------------------------ 

(when (nil? vim.g.lsp)
  (set vim.g.lsp {:autostart true}))

(local compl 
  (match (pcall require :lsp_compl)
    (true compl) compl
    _ nil))


(fn on-init [client result]
  (do
    (when compl
      (do
        (set vim.lsp.text_document_completion_list_to_complete_items
             compl.text_document_completion_list_to_complete_items)
        (when (client.supports_method :textDocument/signatureHelp)
          (set client.server_capabilities.signatureHelpProvider.triggerCharacters []))))
    (match result.offsetEncoding
      enc (set client.offset_encoding env))))

(fn hover [_ result ctx]
  ((. vim.lsp.handlers :textDocument/hover) _ result ctx))

(fn signature-help [_ result ctx]
  (vim.lsp.handlers.signature_help _ result ctx {:focusable false}))


(local handlers {:textDocument/hover hover
                 :textDocument/signatureHelp signature-help})

(local capabilities 
  (vim.tbl_deep_extend :force
                       (vim.lsp.protocol.make_client_capabilities)
                       {:general {:positionEncodings [:utf-8 :utf-16]}}
                       (if compl (compl.capabilities) {})))


(fn start [config]
  (do
    (when (and (executable? (head config.cmd))
               (not= vim.g.lsp.autostart false)
               (= vim.bo.buftype "")
               (vim.uv.fs_access (vim.api.nvim_buf_get_name 0) :r)
               (vim.api.nvim_buf_is_loaded 0))
      (let [root-dir (if config.root
                       (let [[root-marker] (vim.fs.find config.root {:upward true})]
                         (vim.fs.dirname root-marker)))
            config_ (vim.tbl_extend :keep
                                    config
                                    {:root_dir (or root-dir (vim.uv.cwd))
                                     :on_init on-init
                                     : capabilities
                                     : handlers})]
        (vim.lsp.start config_))))) 

(fn enable []
  (do
    (tset vim.g.lsp :autostart true)
    (vim.cmd "doautoall <nomodeline> FileType")))

(fn disable []
  (do
    (tset vim.g.lsp :autostart false)
    (vim.lsp.stop_client (vim.lsp.get_clients))))


{: start
 : enable
 : disable}
 
