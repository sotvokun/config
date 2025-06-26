(local vue-language-server-path
       (let [node_modules (vim.trim (vim.fn.system (table.concat [(vim.fn.exepath "npm") "root" "-g"] " ")))]
         (vim.fs.joinpath node_modules "@vue" "language-server")))

(local vue-plugin
       {:name "@vue/typescript-plugin"
        :location vue-language-server-path
        :languages ["vue"]
        :configNamespace "typescript"})

(let [typescript-language-server-path (vim.fn.exepath "typescript-language-server")
      has-vue-language-server (= 1 (vim.fn.isdirectory vue-language-server-path))
      filetypes ["javascript" "javascriptreact" "typescript" "typescriptreact"]
      plugins []]
  (do
    (if has-vue-language-server
        (do
          (table.insert filetypes "vue")
          (table.insert plugins vue-plugin)))
    {:filetypes filetypes
     :cmd [typescript-language-server-path "--stdio"]
     :root_markers ["package.json"]
     :init_options {:hostInfo "neovim" :plugins plugins}}))
