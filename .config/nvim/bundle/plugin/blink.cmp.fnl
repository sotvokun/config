; bundle/plugin/blink.cmp.fnl - blink.cmp configurations

(exit-if! (not (pcall require "blink.cmp")))

(exit-if! vim.g.loaded_blink_cmp_after)
(set vim.g.loaded_blink_cmp_after true)


; Section: Macros
; -----------------------------------------------------------------------------
;    Part: copilot.lua

(macro copilot-ready? []
  `(pcall require "copilot"))

(macro copilot-has-suggestion? []
  `(and (copilot-ready?) ((. (require "copilot.suggestion") :is_visible))))

(macro copilot-accept! []
  `((. (require "copilot.suggestion") :accept)))

(macro copilot-dismiss []
  `((. (require "copilot.suggestion") :dismiss)))

;    Part: completions-menu-columns

(macro completions-menu-columns []
  (let [left ["label" "label_description"]
        right ["kind"]]
    (do
      (tset left "gap" 1)
      `[,left ,right])))


; Section: Setup
; -----------------------------------------------------------------------------
;    Part: keymap
(lambda setup-keymap []
  {:preset "super-tab"
   :<c-e> ["hide" (lambda [cmp] (if (copilot-has-suggestion?) (copilot-dismiss))) "fallback"]
   :<tab> [(lambda [cmp]
             (if (cmp.snippet_active) (cmp.accept) (cmp.select_and_accept)))
           (lambda [cmp]
             (if (copilot-has-suggestion?) (copilot-accept!)))
           "snippet_forward"
           "fallback"]})

;    Part: provider-snippets
(lambda setup-provider-snippets []
  {:opts {:search_paths [(vim.fs.joinpath (vim.fn.stdpath "config") "snippet")]}})

;    Part: completion-list-selection
(lambda setup-completion-list-selection []
  {:preselect true :auto_insert false})


(with-module [blink :blink.cmp]
  (blink.setup {:keymap (setup-keymap)
                :cmdline {:enabled false}
                :completion {:menu {:draw {:columns (completions-menu-columns)}}
                             :list {:selection (setup-completion-list-selection)}}
                :sources {:providers {:snippets (setup-provider-snippets)}}
                :fuzzy {:implementation "lua"}}))
