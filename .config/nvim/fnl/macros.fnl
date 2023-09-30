;; Predicates
;; --------------------

(fn nil? [val]
  `(= nil ,val))

(fn executable? [expr]
  `(= 1 (vim.fn.executable ,expr)))

(fn even? [val]
  `(= 0 (% ,val 2)))

(fn odd? [val]
  `(= 1 (% ,val 2)))


;; Handy
;; --------------------

(fn ++ [val]
  `(+ ,val 1))

(fn -- [val]
  `(+ ,val -1))

(fn head [val]
  `(. ,val 1))

(fn tail [val]
  `(. ,val ,(length val)))

(fn list->table [val]
  (let [len (length val)
        list_ (if (= 1 (% len 2))
                  [(unpack val 1 (- len 1))]
                  val)
        result {}]
      (do 
        (each [i v (ipairs list_)] 
          (when (odd? i) 
            (tset result (. list_ i) (. list_ (+ i 1)))))
        result)))

(fn with-module [module-binding ...]
  (let [[binding name] module-binding]
    `(match (pcall require ,name)
       (true ,binding)
       (do ,...))))

;; VIM
;; --------------------

(fn define-command [name cmd ?opts]
  `(vim.api.nvim_create_user_command 
     ,(tostring name)
     ,cmd 
     ,(or ?opts {})))


;; Export
;; --------------------

{: nil?
 : executable?
 : even?
 : odd?

 : ++
 : --
 : head
 : tail
 : list->table
 : with-module
 
 : define-command}
