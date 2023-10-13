(vscode-incompatible!)

(with-module [clue :mini.clue]
  (local builtins clue.gen_clues)
  (local clues [(builtins.marks)
                (builtins.registers)
                (builtins.windows)
                (builtins.z)])
  (local triggers [])

  (fn set-clue [trigger-modes trigger-keys ...]
    """
    ... - array<[keys desc ?postkeys]>
    """
    (each [_ mode (ipairs (vim.split trigger-modes "" {:trimempty true}))]
      (do
        (table.insert triggers {:mode mode :keys trigger-keys})
        (each [_ [keys desc postkeys] (ipairs [...])]
          (table.insert clues {: mode :keys (.. trigger-keys keys) :desc desc :postkeys postkeys})))))
  (fn set-map-desc [mode lhs desc]
    (each [_ mode (ipairs (vim.split mode "" {:trimempty true}))]
      (clue.set_mapping_desc mode lhs desc)))

  ; ---------------------------------------------------------------------------

  ; Triggers for builtins
  (set-clue :nx "'")
  (set-clue :nx "`")
  (set-clue :nx "\"")
  (set-clue :ic :<c-r>)
  (set-clue :n  :<c-w>)
  (set-clue :nx :z)

  ; Leader
  (set-clue :nx "<leader>"
            [:g "+Git"])

  ; ---------------------------------------------------------------------------

  (clue.setup 
    {:window {:delay 250 :config {:width "auto"}}
     : triggers 
     : clues}))
