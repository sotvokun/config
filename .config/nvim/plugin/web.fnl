; web.fnl - A plugin to setup web development environment

(vscode-incompatible!)

; - typescript language server for javascript, typescript, jsx, tsx
(with-module [lsp :lsp]
  (local filetypes ["javascript" "typescript" "javascriptreact" "typescriptreact"])
  (local tsserver-options
    {:hostInfo "neovim"
     :completionDisableFilterText true})
  (lsp.register {:name "tsserver"
                 :cmd ["typescript-language-server" "--stdio"]
                 :root ["package.json" "jsconfig.json" "tsconfig.json"]
                 :filetype filetypes
                 :init_options tsserver-options})

  (fn lsp-process-items [items base]
    """
    Remove dots as prefix from `textEdit.newText` as it is used verbatim
    REFERENCE: https://github.com/echasnovski/mini.nvim/issues/306#issuecomment-1517954136
    """
    (do
      (each [_ item (ipairs items)]
        (let [new-text (. (or item.textEdit {}) :newText)]
          (when (string? new-text)
            (tset item.textEdit :newText 
                  (string.gsub new-text "^%.+" "")))))
      (MiniCompletion.default_process_items items base)))

  (autocmd lsp#FileType [FileType]
           :pattern filetypes
           :callback 
           #(tset vim.b :minicompletion_config
                 {:lsp_completion
                  {:process_items lsp-process-items}})))

; - vue language server
(with-module [lsp :lsp]
  (local filetypes ["vue"])

  (local volar-options {:typescript {:tsdk ""}})

  (fn find-tsserver-lib [root]
    (let [node-module-path (vim.fs.normalize (.. root "/node_modules"))
          lib-path (vim.fs.normalize (.. node-module-path "/typescript/lib"))]
      (if (= 1 (vim.fn.isdirectory lib-path)) lib-path
          "")))

  (fn before-start [config]
    (vim.tbl_extend :force config
                    {:init_options
                     {:typescript {:tsdk (find-tsserver-lib config.root_dir)}}}))

  ; TODO - the tsdk may should be optional or fallback to global tsserver

  (lsp.register {:name "volar"
                 :cmd ["vue-language-server" "--stdio"]
                 :root ["package.json"]
                 :filetype filetypes
                 :init_options volar-options
                 :before_start before-start}))
