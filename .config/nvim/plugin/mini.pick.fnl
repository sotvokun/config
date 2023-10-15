(vscode-incompatible!)
(with-module [pick :mini.pick]
  (pick.setup)

  ;; Snippets
  (with-module [snippy :snippy.main]
    (fn snippets []
      (let [filetype vim.bo.filetype
            all (do (snippy.read_snippets) snippy._snippets)
            default (or (. all "_") [])
            ft (or (or (. all filetype) []))]
        (vim.tbl_deep_extend :force default ft)))
    (fn snippy-picker [local-opts opts]
      (do
        (local snippets-data (snippets))
        (fn preview [item bufid]
          (pcall vim.api.nvim_buf_set_lines bufid 0 -1 false (. (. snippets-data item) :body)))
        (local source {:name "Snippets" :items (vim.tbl_keys snippets-data) :preview preview})
        (local opts__
          (vim.tbl_deep_extend :force
                               (or opts {})
                               {: source}))
        (local item (MiniPick.start opts__))
        (when (not (nil? item))
          (snippy.expand_snippet item)
          (snippy.expand))))
    (tset MiniPick.registry :snippet (fn [local-opts] (snippy-picker local-opts))))

  ;; oldfiles
  (fn oldfiles-picker [local-opts opts]
    (let [cwd (vim.fn.getcwd)
          oldfiles (icollect [_ p (ipairs vim.v.oldfiles)]
                      (when (and (vim.startswith p cwd)
                                 (= 1 (vim.fn.filereadable p)))
                        (vim.fn.fnamemodify p ":~:.")))]
      (do
        (local source {:name "Oldfiles" :items oldfiles})
        (local opts_ 
          (vim.tbl_deep_extend :force 
                               (or opts {}) 
                               {: source}))
        (local item (MiniPick.start opts_)))))
  (tset MiniPick.registry :oldfiles (fn [local-opts] (oldfiles-picker local-opts)))

  ; lsp lists
  ; > declaration
  ; > definition
  ; > document_symbols
  ; > implementation
  ; > references
  ; > type_definition
  ; > workspace_symbol

  (fn lsp-list-handler [opts]
    (fn [{: items : title}]
      (let [text-builder (fn [item]
                           (let [filename (vim.fn.fnamemodify item.filename ":~:.")
                                 location (string.format "%s:%s" item.lnum item.col)]
                             (string.format "%s:%s:%s" filename location item.text)))
            items (vim.tbl_map (fn [item]
                                 {:path item.filename 
                                  :lnum item.lnum 
                                  :col item.col 
                                  :text (text-builder item) 
                                  :path_type "file"})
                               items)
            source {:name title :items items}
            opts (vim.tbl_deep_extend :force (or opts {}) {:source source})]
        (MiniPick.start opts))))

  (fn lsp-symbol-list-handler [opts ?show-filename]
    (let [kind-filter #(not= "Variable" $1.kind)
          show-filename (or ?show-filename false)]
      (fn [{: items : title}]
        (let [text-builder (fn [item]
                             (let [kind (string.format "[%s]" item.kind)
                                   filename (vim.fn.fnamemodify item.filename ":~:.")
                                   location (string.format "%s:%s" item.lnum item.col)
                                   name (string.match item.text "^%[%w+%]%s(.*)")]
                               (if (not show-filename) (string.format "%-45s%-20s%s" name kind location)
                                 (string.format "%-45s%-20s%s:%s" name kind filename location))))
              symbols (vim.tbl_filter kind-filter items)
              pitems (vim.tbl_map (fn [item]
                                    {:path item.filename
                                     :lnum item.lnum
                                     :col item.col
                                     :text (text-builder item)
                                     :path_type "file"})
                                  symbols)
              source {:name title :items pitems}
              opts (vim.tbl_deep_extend :force (or opts {}) {:source source})]
          (MiniPick.start opts)))))

  (local lsp-pickers 
    {:declaration 
       (fn [local-opts opts] 
         (vim.lsp.buf.declaration {:on_list (lsp-list-handler opts)}))
     :definition 
       (fn [local-opts opts] 
         (vim.lsp.buf.definition {:on_list (lsp-list-handler opts)}))
     :document_symbol 
       (fn [local-opts opts] 
         (vim.lsp.buf.document_symbol {:on_list (lsp-symbol-list-handler opts)}))
     :implementation 
       (fn [local-opts opts] 
         (vim.lsp.buf.implementation {:on_list (lsp-list-handler opts)}))
     :references 
       (fn [local-opts opts] 
         (vim.lsp.buf.references nil {:on_list (lsp-list-handler opts)}))
     :workspace_symbol 
       (fn [local-opts]
         (vim.lsp.buf.workspace_symbol 
           (vim.fn.input "Query: ")
           {:on_list (lsp-symbol-list-handler opts true)}))
     :type_definition 
       (fn [local-opts opts] 
         (vim.lsp.buf.type_definition {:on_list (lsp-list-handler opts)}))})

  (each [k v (pairs lsp-pickers)]
    (tset MiniPick.registry (.. "lsp." k) v))
  
  (keymap [n] :<leader>f "<cmd>Pick files<cr>"     :silent true :desc "Open file picker")
  (keymap [n] :<leader>b "<cmd>Pick buffers<cr>"   :silent true :desc "Open buffer picker")
  (keymap [n] :<leader>/ "<cmd>Pick grep_live<cr>" :silent true :desc "Open live grep")
  (keymap [n] :<leader>? "<cmd>Pick grep<cr>"      :silent true :desc "Open grep")
  (keymap [n] "<leader>]" "<cmd>Pick snippet<cr>"  :silent true :desc "Open snippet picker")
  (keymap [n] :<leader>o "<cmd>Pick oldfiles<cr>"  :silent true :desc "Open oldfiles picker")
  (keymap [n] "<leader>'" "<cmd>Pick resume<cr>"   :silent true :desc "Open last picker"))
