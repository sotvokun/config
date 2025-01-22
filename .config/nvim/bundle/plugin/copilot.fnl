; bundle/plugin/copilot.fnl - copilot configurations
;

(exit-if! (not (pcall require "copilot")))

(exit-if! vim.g.loaded_copilot_after)
(set vim.g.loaded_copilot_after true)


(with-module [copilot :copilot]
  (copilot.setup
    {:suggestion {:auto_trigger true
                  :keymap {:accept false :dismiss false}}}))
