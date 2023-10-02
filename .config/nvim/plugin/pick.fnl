(with-module [pick :pick]
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
          (vim.print snippets-data)
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

  
  (keymap [n] :<c-g>f "<cmd>Pick files<cr>" :silent true)
  (keymap [n] :<c-g>b "<cmd>Pick buffers<cr>" :silent true)
  (keymap [n] :<c-g>/ "<cmd>Pick grep_live<cr>" :silent true)
  (keymap [n] :<c-g>? "<cmd>Pick grep<cr>" :silent true)
  (keymap [in] "<c-g>]" "<cmd>Pick snippet<cr>" :silent true)
  (keymap [n] :<c-g><c-g> "<cmd>Pick resume<cr>" :silent true)
  (keymap [n] :<c-g><c-f> "<cmd>Pick oldfiles<cr>" :silent true))
