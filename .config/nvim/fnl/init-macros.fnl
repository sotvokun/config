;; ![macro,auto-require]

; Section: Utils

(fn exit-if! [condition]
  `(when ,condition
     (lua "return")))


; Section: Shortcuts

(fn exit-if-vscode! []
  (exit-if! `(= 1 (vim.fn.exists "g:vscode"))))

(fn with-module [module-binding ...]
  "Reference:

    https://raw.githubusercontent.com/gpanders/dotfiles/refs/heads/master/.config/nvim/fnl/macros.fnl

  Example:

    (with-modle [foo :foo]
      (foo.bar))

  The above example will be expand to:

    (match (pcall require :foo)
      (true foo) (do (foo.bar)))
  "
  (let [[binding name] module-binding]
    `(match (pcall require ,name)
       (true ,binding) (do ,...))))


; Section: vim api
; Reference:
;   - augroup:
;     https://raw.githubusercontent.com/gpanders/dotfiles/refs/heads/master/.config/nvim/fnl/macros.fnl

(lambda keymap [mode lhs rhs ?opts]
  (let [modes (icollect [val (string.gmatch (tostring mode) "%S")]
                val)]
    `(vim.keymap.set ,modes ,lhs ,rhs ,?opts)))

(lambda autocmd [events pattern callback ?opts]
  (let [opts (or ?opts {})]
    `(vim.api.nvim_create_autocmd
       ,events
       (vim.tbl_extend :keep
                       ,opts
                       {:pattern ,pattern
                        :callback ,callback}))))

(lambda augroup* [clear group ...]
  (do
    (set _G.augroup (tostring group))
    (if (and clear (= 0 (select :# ...)))
        `(vim.api.nvim_del_augroup_by_name ,(tostring group))
        `(do
           (vim.api.nvim_create_augroup ,(tostring group) {:clear ,clear})
           ,...))))

(lambda augroup [group ...]
  (augroup* false group ...))

(lambda augroup! [group ...]
  (augroup* true group ...))

{: exit-if!

 : exit-if-vscode!
 : with-module

 : keymap
 : autocmd
 : augroup
 : augroup!}
