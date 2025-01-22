; bundle/plugin/cmp.fnl - nvim-cmp configurations
;


(exit-if! (not (pcall require "cmp")))

(exit-if! vim.g.loaded_cmp_after)
(set vim.g.loaded_cmp_after true)


; Section: Macros
; -----------------------------------------------------------------------------
(macro feedkey [keys mode]
  `(vim.api.nvim_feedkeys (vim.api.nvim_replace_termcodes ,keys true true true)
                          ,mode
                          true))

;    Part: copilot.lua
;
(macro copilot-ready? []
  `(pcall require "copilot"))

(macro copilot-has-suggestion? []
  `(and (copilot-ready?) ((. (require "copilot.suggestion") :is_visible))))

(macro copilot-accept! []
  `((. (require "copilot.suggestion") :accept)))

(macro copilot-dismiss []
  `((. (require "copilot.suggestion") :dismiss)))


(with-module [cmp :cmp]
  (with-module [cmp-lsp :cmp_nvim_lsp]
    (vim.lsp.config "*" {:capabilities (cmp-lsp.default_capabilities)}))

  (fn setup-sources []
    (let [src [{:name "vsnip"} {:name "buffer"} {:name "path"}]
          cmp-lsp-ready (pcall require "cmp_nvim_lsp")]
      (do
        (when cmp-lsp-ready (table.insert src 2 {:name "nvim_lsp"}))
        (cmp.config.sources src))))

  (fn setup-snippets []
    (let [snippet-expand-fn (if (= 1 (vim.fn.exists "*vsnip#anonymous")) #((. vim.fn :vsnip#anonymous) $1.body)
                                nil)]
      (if snippet-expand-fn {:expand snippet-expand-fn}
          {})))

  (fn setup-mappings []
    (let [key-tab (cmp.mapping
                   (lambda [fallback]
                     (vim.print (cmp.visible))
                     (if (cmp.visible) (let [entry (cmp.get_selected_entry)]
                                         (if (not entry) (cmp.select_next_item {:behavior cmp.SelectBehavior.Select})
                                             (cmp.confirm)))
                         (= 1 ((. vim.fn :vsnip#available))) (feedkey "<Plug>(vsnip-expand-or-jump)" "")
                         (copilot-has-suggestion?) (copilot-accept!)
                         (fallback)))
                   [:i :s])
         key-shift-tab (cmp.mapping
                         (lambda [fallback]
                           (if (cmp.visible) (cmp.select_prev_item)
                               (= 1 ((. vim.fn :vsnip#jumpable) -1)) (feedkey "<Plug>(vsnip-jump-prev)" "")
                               (fallback)))
                         [:i :s])
         key-ctrl-e (cmp.mapping
                      (lambda [fallback]
                        (if (cmp.visible) (cmp.abort)
                            (copilot-has-suggestion?) (copilot-dismiss)
                            (fallback)))
                      [:i :s])
         key-cr (lambda [fallback]
                    (if (and (cmp.visible) (cmp.get_active_entry)) (cmp.confirm {:behavior cmp.ConfirmBehavior.Replace
                                                                                 :select false})
                        (fallback)))
         key-ctrl-p (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Select})
         key-ctrl-n (cmp.mapping.select_next_item {:behavior cmp.SelectBehavior.Select})]
      (cmp.mapping.preset.insert
        {:<tab> key-tab
         :<s-tab> key-shift-tab
         :<cr> {:i key-cr :s (cmp.mapping.confirm {:select true})}
         :<c-e> key-ctrl-e
         :<c-n> key-ctrl-n
         :<c-p> key-ctrl-p})))

  (cmp.setup {:completion {:completeopt "menu,menuone,noinsert"}
              :sources (setup-sources)
              :snippet (setup-snippets)
              :mapping (setup-mappings)}))
