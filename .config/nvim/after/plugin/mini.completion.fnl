(vscode-incompatible!)

(with-module [mini-completion "mini.completion"]

  ;; Unregister native completion
  (when (= 1 (vim.fn.exists "*SvimUnmapCompl"))
    (vim.cmd "call SvimUnmapCompl()"))

  ;; Setup
  (mini-completion.setup)

  ;; Keys
  (local keys {:<c-n> (vim.api.nvim_replace_termcodes :<c-n> true true true)
               :<tab> (vim.api.nvim_replace_termcodes :<tab> true true true)
               :<c-y> (vim.api.nvim_replace_termcodes :<c-y> true true true)})

  (macro with-key [key]
    `(. keys ,key))
  
  ;; KeyFn
  (fn tab-fn []
    (let [info (vim.fn.complete_info)
          has-selected (not= -1 (. info "selected"))]
      (if (not has-selected) (with-key :<c-n>)
        (with-key :<c-y>))))

  ;; Keymap
  (keymap [is] "<tab>" (fn []
                        (if (= 1 (vim.fn.pumvisible)) (tab-fn)
                          (with-key :<tab>)))
          :expr true)
  (keymap [i] "<c-k>" #(MiniCompletion.complete_twostage)))
