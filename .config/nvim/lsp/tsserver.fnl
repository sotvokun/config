(macro get-mason-path [...]
  `(if (and vim.env.MASON (not= 0 (length vim.env.MASON)))
      (vim.fs.joinpath vim.env.MASON ,...)
      ""))


(let [typescript-language-server-path (vim.fn.exepath "typescript-language-server")
      vue-language-server-path (get-mason-path "packages" "vue-language-server" "node_modules" "@vue" "language-server")
      has-vue-language-server (= 1 (vim.fn.isdirectory vue-language-server-path))
      filetypes ["javascript" "javascriptreact" "typescript" "typescriptreact"]
      plugins []]
  (do
    (if has-vue-language-server
        (do
          (table.insert filetypes "vue")
          (table.insert plugins {:name "@vue/typescript-plugin"
                                 :location vue-language-server-path
                                 :languages ["vue"]})))
    {:filetypes filetypes
     :cmd [typescript-language-server-path "--stdio"]
     :root_markers ["package.json"]
     :init_options {:hostInfo "neovim" :plugins plugins}}))
