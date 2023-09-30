(require-macros :macros)

(local Hydra (require :hydra))

(macro hydra-head [lhs rhs ...]
  `[,(tostring lhs) 
    ,(tostring rhs) 
    (list->table ,[...])])

(macro hydra [...]
  `((require :hydra) (list->table ,[...])))

(hydra
  :name "Picker"
  :mode "n"
  :body "<leader>p"
  :config {:color "blue" :hint {:type :window}}
  :heads [(hydra-head
            "f" "<cmd>Files<cr>"
            :desc "Files")
          (hydra-head
            "b" "<cmd>Buffers<cr>"
            :desc "Buffers")])
