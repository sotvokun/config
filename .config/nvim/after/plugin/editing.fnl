; editing.fnl
; | Motional (leap)
; | Pairs (autopairs)
; | Surround (nvim-surround)

; Motional =====================================

(with-module [leap :leap]
  (keymap [n] :gs "<Plug>(leap-forward-to)")
  (keymap [n] :gS "<Plug>(leap-backward-to)")
  (keymap [vo] :gx "<Plug>(leap-forward-till)")
  (keymap [vo] :gX "<Plug>(leap-backward-till)"))


; Pairs ========================================

(tset vim.g :AutoPairsMapCR 1)
(tset vim.g :AutoPairsMapSpace 0)


; Surround =====================================

(with-module [surround :nvim-surround]
  (surround.setup)
  
  (keymap [o] "ia" "i<")
  (keymap [o] "aa" "a<"))
