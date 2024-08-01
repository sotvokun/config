; after/plugin/cmp.fnl - cmp configuration
;

(if vim.g.loaded_cmp_after (lua :return)
    (set vim.g.loaded_cmp_after true))

(if (not= 0 (vim.fn.exists "g:vscode"))
    (lua :return))

(if (not (pcall require :cmp)) (lua :return))

(macro feedkey [keys mode]
  `(vim.api.nvim_feedkeys
     (vim.api.nvim_replace_termcodes
       ,keys true true true)
     ,mode
     true))

(macro copilot-ready []
  `(and (not= 0 (vim.fn.exists ":Copilot"))
       ((. vim.fn :copilot#Enabled))))

(macro copilot-has-suggestion []
  `(and (copilot-ready)
       (let [suggestion# ((. vim.fn :copilot#GetDisplayedSuggestion))]
         (and (not= nil suggestion#.text) (not= 0 (length suggestion#.text))))))

(let [cmp (require :cmp)
      setup-snippets
        (fn []
          {:expand (fn [args] ((. vim.fn :vsnip#anonymous) args.body))})
      setup-sources
        (fn []
          (let [sources [{:name "vsnip"} {:name "buffer"} {:name "path"}]
                cmp-lsp-ok (pcall require :cmp_nvim_lsp)]
            (do
              (if cmp-lsp-ok (table.insert sources 2 {:name "nvim_lsp"}))
              (cmp.config.sources sources))))
      map-tab
        (fn [fallback]
          (if (cmp.visible)
              (let [entry (cmp.get_selected_entry)]
                (if (not entry) (cmp.select_next_item
                                  {:behavior cmp.SelectBehavior.Select})
                    (cmp.confirm)))
              (= 1 ((. vim.fn :vsnip#available) 1))
                (feedkey "<Plug>(vsnip-expand-or-jump)" "")
              (copilot-ready)
                (vim.api.nvim_feedkeys
                  ((. vim.fn :copilot#Accept)
                   (vim.api.nvim_replace_termcodes
                     "<Tab>" true true true)) :n true)
              (fallback)))
        map-s-tab
          (fn [fallback]
            (if (= 1 ((. vim.fn :vsnip#jumpable) -1))
                  (feedkey "<Plug>(vsnip-jump-prev)" "")
                (fallback)))
        map-cr
          (fn [fallback]
            (if (and (cmp.visible) (cmp.get_active_entry))
                  (cmp.confirm
                    {:behavior cmp.ConfirmBehavior.Replace
                     :select false})
                (fallback)))
        map-c-e
          (fn [fallback]
            (if (cmp.visible)
                  (cmp.abort)
                (copilot-has-suggestion)
                  (feedkey "<Plug>(copilot-dismiss)" "")
                (fallback)))]
  (cmp.setup
    {:completion {:completeopt "menu,menuone,noinsert"}
     :snippet (setup-snippets)
     :sources (setup-sources)
     :mapping {:<tab> (cmp.mapping map-tab [:i :s])
               :<s-tab> (cmp.mapping map-s-tab [:i :s])
               :<cr> (cmp.mapping
                       {:i map-cr :s (cmp.mapping.confirm {:select true})})
               :<c-e> (cmp.mapping map-c-e [:i :s])
               :<c-n> (cmp.mapping.select_next_item
                        {:behavior cmp.SelectBehavior.Select})
               :<c-p> (cmp.mapping.select_prev_item
                        {:behavior cmp.SelectBehavior.Select})}}))
