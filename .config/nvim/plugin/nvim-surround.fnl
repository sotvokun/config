(with-module [surround :nvim-surround]
  (surround.setup)
  
  (keymap [o] "ia" "i<")
  (keymap [o] "aa" "a<"))
