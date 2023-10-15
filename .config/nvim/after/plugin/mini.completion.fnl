(vscode-incompatible!)

(with-module [mini-completion "mini.completion"]

  ;; copilot
  (fn copilot []
    (let [copilot (match (pcall require :copilot)
                    (true copilot_) copilot_
                    _ nil)
          suggestion (if (and copilot copilot.setup_done)
                       (require :copilot.suggestion)
                       nil)]
      (if (and copilot suggestion) suggestion nil)))

  ;; Unregister native completion
  (when (= 1 (vim.fn.exists "*SvimUnmapCompl"))
    (vim.cmd "call SvimUnmapCompl()"))

  ;; Setup
  (mini-completion.setup)

  ;; KeyFn
  (fn tab-fn []
    (let [info (vim.fn.complete_info)
          has-selected (not= -1 (. info "selected"))]
      (if (not has-selected) (feedkeys :<c-n>)
        (feedkeys :<c-y>))))

  ;; Keymap
  (keymap [is] "<tab>" (fn []
                        (if 
                          (= 1 (vim.fn.pumvisible)) (tab-fn)
                          (let [copilot (copilot)]
                            (and copilot (copilot.is_visible))) ((. (copilot) :accept))
                          (feedkeys :<tab>)))) 

  ;; Because <c-e> has mapped too many things, so the fallback to move to the end of line
  ;; is working with <end> instead of the defined <c-e>
  (keymap [i] "<c-e>" #(if 
                         (= 1 (vim.fn.pumvisible)) (feedkeys :<c-e> :ni)
                         (let [copilot (copilot)]
                           (and copilot (copilot.is_visible))) ((. (copilot) :dismiss))
                         (feedkeys :<end>)))

  (keymap [i] "<c-k>" #(MiniCompletion.complete_twostage)))
