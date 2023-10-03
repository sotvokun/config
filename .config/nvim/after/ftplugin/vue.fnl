(local tsserver-lib []
  (let [pcwd (vim.fs.dirname (vim.fn.getcwd))
        bufpath (vim.fs.dirname (vim.api.nvim_buf_get_name 0))
        node-modules
        (vim.fs.find "node_modules"
                     {:path bufpath
                      :stop pcwd
                      :upward true})]
    (.. (head node-modules) "/typescript/lib/")))

(local lsp-server
  {:cmd ["vue-language-server" "--stdio"]
   :root ["package.json" "tsconfig.json" "jsconfig.json"]
   :init_options {:typescript {:tsdk (tsserver-lib)}}})

(with-module [lsp :lsp]
             (lsp.start lsp-server))
