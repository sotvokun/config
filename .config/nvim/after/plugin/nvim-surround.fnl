(let [setup (. (require :nvim-surround) :setup)]
  (setup))

(vim.keymap.set :o "ia" "i<")
(vim.keymap.set :o "aa" "a<")
