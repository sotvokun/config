;; Predicates
;; --------------------

(fn nil? [val]
  `(or (= :nil (type ,val))
       (and (= :table (type ,val))
            (= 0 (length (vim.tbl_keys ,val))))))

(fn number? [val]
  `(= :number (type ,val)))

(fn string? [val]
  `(= :string (type ,val)))

(fn boolean? [val]
  `(= :boolean (type ,val)))

(fn table? [val]
  `(= :table (type ,val)))

(fn list? [val]
  `(vim.tbl_islist ,val))

(fn quote? [val]
  `(and (table? ,val)
        (< 1 (length ,val))
        (table? (. ,val 1))
        (= 1 (length (. ,val 1)))
        (= :quote (tostring (. ,val 1)))))

(fn executable? [expr]
  `(= 1 (vim.fn.executable ,expr)))

(fn even? [val]
  (assert-compile (number? val))
  `(= 0 (% ,val 2)))

(fn odd? [val]
  (assert-compile (number? val))
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

(fn command [name cmd ...]
  (assert-compile (string? name))
  `(vim.api.nvim_create_user_command 
     ,name 
     ,cmd
     (list->table ,[...])))


;; Export
;; --------------------

{: nil?
 : number?
 : string?
 : boolean?
 : table?
 : list?
 : quote?
 : executable?
 : even?
 : odd?

 : ++
 : --
 : head
 : tail
 : list->table
 : with-module
 
 : command}
