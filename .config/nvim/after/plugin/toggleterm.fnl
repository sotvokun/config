(vscode-incompatible!)

(with-module [toggleterm :toggleterm]
  (toggleterm.setup)

  (augroup toggleterm#)
  (autocmd toggleterm# [TermEnter]
           :callback
           #(keymap [t] "<c-\\>" "<cmd>exe v:count1 . 'ToggleTerm'<cr>"))
  
  (keymap [n] "<c-\\>" "<cmd>exe v:count1 . 'ToggleTerm'<cr>"))
