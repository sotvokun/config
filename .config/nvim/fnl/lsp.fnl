(when (nil? vim.g.lsp)
  (set vim.g.lsp {:autostart true}))

(local uv (or vim.uv vim.loop))

; ------------------------------------------------

(fn on-init [client result]
  (match result.offsetEncoding
    enc (set client.offset_encoding enc)))

(fn hover [_ result ctx]
  (let [handler-setup (. vim.lsp.handlers "textDocument/hover")]
    (handler-setup _ result ctx {})))

(fn signature-help [_ result ctx]
  (let [handler-setup (. vim.lsp.handlers "textDocument/signatureHelp")]
    (handler-setup _ result ctx {:focusable false})))

; ------------------------------------------------

(fn make-capabilities []
  (let [capabilities (vim.lsp.protocol.make_client_capabilities)
        generalPositionEnc {:general {:positionEncoding [:utf-8 :utf-16]}}
        (cmp-ok cmp) (pcall require :cmp_nvim_lsp)]
    (vim.tbl_deep_extend :keep 
                         capabilities 
                         generalPositionEnc
                         (if cmp-ok (cmp.default_capabilities) {}))))

(fn make-handlers []
  {"textDocument/signatureHelp" signature-help
   "textDocument/hover" hover})

; ------------------------------------------------

(fn find-root-dir [markers]
  (vim.fs.dirname (head (vim.fs.find markers {:upward true}))))

; ------------------------------------------------

(augroup lsp#FileType)

(fn register [config]
  (let [filetype (match (type config.filetype)
                   :string [config.filetype]
                   :table config.filetype
                   _ nil)
        root-dir (or (find-root-dir config.root) uv.cwd)
        capabilities (make-capabilities)
        handlers (make-handlers)
        before-start config.before_start
        
        client-config (vim.tbl_extend :keep 
                                      (vim.tbl_extend :force 
                                                      config 
                                                      {:filetype nil :before_start nil})
                                      {:root_dir root-dir
                                       :on_init on-init
                                       :capabilities capabilities
                                       :handlers handlers})

        start-fn (fn []
                   (let [is-autostart (not= false vim.lsp.start)
                         is-executable (= 1 (vim.fn.executable (head config.cmd)))]
                     (when (and is-autostart is-executable)
                       (vim.lsp.start (if before-start (before-start client-config) 
                                          client-config)))))]
                         
    (autocmd lsp#FileType [FileType] 
             :pattern filetype
             :callback start-fn)))

(fn start [config]
  (let [root-dir (or (find-root-dir config.root) uv.cwd)
        capabilities (make-capabilities)
        handlers (make-handlers)
        
        is-autostart (not= false vim.g.lsp.autostart)
        is-executable (= 1 (vim.fn.executable (head config.cmd)))
        is-normalbuf (= vim.bo.buftype "")
        is-accessible (uv.fs_access (vim.api.nvim_buf_get_name 0) :r)
        is-loaded (vim.api.nvim_buf_is_loaded 0)
        
        client-config (vim.tbl_extend :keep
                                      config
                                      {:root_dir root-dir
                                       :on_init on-init
                                       :capabilities capabilities
                                       :handlers handlers})]
    (when (and is-autostart is-executable is-normalbuf is-accessible is-loaded)
      (vim.lsp.start client-config))))

(fn enable []
  (set vim.g.lsp.autostart true)
  (vim.cmd "doautoall <nomodeline> FileType"))

(fn disable []
  (let [clients (vim.lsp.get_active_clients)]
    (do
      (set vim.g.lsp.autostart false)
      (vim.lsp.stop_client clients)
      (vim.cmd "augroup lsp#FileType | au! | augroup END"))))

{: start
 : register
 : enable
 : disable}
