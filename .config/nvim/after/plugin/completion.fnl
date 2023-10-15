; completion.fnl - The configuration of completions included lsp and copilot

(vscode-incompatible!)

; Copilot ======================================

(with-module [copilot :copilot]
  (local suggestion {:auto_trigger true :keymap false})
  (copilot.setup {: suggestion}))

; Completion ===================================

(with-module [cmp :cmp]
  (vim.cmd "packadd cmp-buffer")
  (vim.cmd "packadd cmp-snippy")
  ; Unregister native completion ----------------
  (when (= 1 (vim.fn.exists "*SvimUnmapCompl"))
    (vim.cmd "call SvimUnmapCompl()"))

  ; Copilot Compatible --------------------------
  (fn copilot-suggestion []
    (let [copilot (match (pcall require :copilot)
                    (true copilot) copilot
                    _ nil)
          suggestion (if (and copilot copilot.setup_done)
                       (require :copilot.suggestion)
                       nil)]
      (if (and copilot suggestion) suggestion nil)))
  (cmp.event:on :menu_opened #(tset vim.b :copilot_suggestion_hidden true))
  (cmp.event:on :menu_closed #(tset vim.b :copilot_suggestion_hidden false))

  ; Snippet -------------------------------------
  (local snippy (match (pcall require :snippy)
                  (true snippy-) snippy-
                  _ nil))
  (local snippet (if snippy {:expand #(snippy.expand $1.body)}
                   nil))
  
  ; Sources -------------------------------------
  (local sources [{:name "nvim_lsp"}
                  {:name "snippy"}
                  {:name "buffer"}])

  ; Mappings ------------------------------------
  ; <tab>
  (fn tab-key [fallback]
    (let [copilot (copilot-suggestion)]
      (if 
        ;; Popup visible
        (cmp.visible) (let [entry (cmp.get_selected_entry)]
                        (if 
                          (not entry) (cmp.select_next_item)
                          (cmp.confirm)))
        ;; Copilot suggestion
        (and copilot (copilot.is_visible)) (copilot.accept)
        ;; Snippet expansion
        (and snippy (snippy.can_expand_or_advance)) (snippy.expand_or_advance)
        ;; Fallback
        (fallback))))

  ; <s-tab>
  (fn shift-tab-key [fallback]
    (let [copilot (copilot-suggestion)]
      (if 
        ;; Snippet jump back
        (and snippy (snippy.can_jump -1)) (snippy.previous)
        ;; Fallback
        (fallback))))

  ; <c-n>
  (fn c-n-key [fallback]
    (let [copilot (copilot-suggestion)]
      (if
        ;; Select next item
        (cmp.visible) (cmp.select_next_item)
        ;; Select next copilot suggestion
        (and copilot (copilot.is_visible)) (copilot.next)
        ;; Fallback
        (fallback))))

  ; <c-p>
  (fn c-p-key [fallback]
    (let [copilot (copilot-suggestion)]
      (if
        ;; Select previous item
        (cmp.visible) (cmp.select_prev_item)
        ;; Select previous copilot suggestion
        (and copilot (copilot.is_visible)) (copilot.prev)
        ;; Fallback
        (fallback))))

  ; <c-e>
  (fn c-e-key [fallback]
    (let [copilot (copilot-suggestion)]
      (if
        ;; Close popup
        (cmp.visible) (cmp.close)
        ;; Close copilot suggestion
        (and copilot (copilot.is_visible)) (do (vim.print "A") (copilot.dismiss))
        ;; Fallback
        (fallback))))

  ; <c-k>
  (fn c-k-key [fallback] (cmp.complete))

  (local mapping
    {:<tab> (cmp.mapping tab-key [:i :s])
     :<s-tab> (cmp.mapping shift-tab-key [:i :s])
     :<c-n> (cmp.mapping c-n-key [:i :s])
     :<c-p> (cmp.mapping c-p-key [:i :s])
     :<c-e> (cmp.mapping c-e-key [:i :s])
     :<c-k> (cmp.mapping c-k-key [:i :s])})
  
  ; Setup ---------------------------------------
  (cmp.setup {: snippet 
              : mapping 
              :sources (cmp.config.sources sources)}))
