(with-module [surround :nvim-surround]
  (surround.setup)
  (vim.keymap.set :o "ia" "i<")
  (vim.keymap.set :o "aa" "a<"))
