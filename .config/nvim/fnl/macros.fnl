;; Predicates

(fn nil? [val]
  `(= nil ,val))

(fn executable? [expr]
  `(= 1 (vim.fn.executable ,expr)))


;; Handy
(fn first [val]
  `(. ,val 1))


(fn define-command [name cmd ?opts]
  `(vim.api.nvim_create_user_command 
     ,(tostring name)
     ,cmd 
     ,(or ?opts {})))

{: nil?
 : executable?

 : first
 
 : define-command}
