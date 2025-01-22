; bundle/plugin/codecompanion.fnl - codecompanion configurations
;

(exit-if! (not (pcall require "codecompanion")))

(exit-if! vim.g.loaded_codecompanion_after)
(set vim.g.loaded_codecompanion_after true)



(macro copilot-claude []
  `(lambda []
     (let [adapters# (require "codecompanion.adapters")
           model# "claude-3.5-sonnet"]
       (adapters#.extend
         "copilot"
         {:schema {:model {:default model#}}}))))



(with-module [codecompanion :codecompanion]
  (codecompanion.setup
    {
     :display {:chat {:show_header_separator true :show_settings true}}
     :language "Chinese"
     :strategies {:chat {:adapter "copilot" :model "claude-3.5-sonnet"}
                  :inline {:adapter "copilot" :model "claude-3.5-sonnet"}}}))
