; language-server-protocol.fnl
; | Mason (mason)
; | Diagnostics (vim.diagnostic)

(vscode-incompatible!)

; Mason ========================================

(with-module [mason :mason]
  (mason.setup))


; Diagnostics ==================================

(let [Severity vim.diagnostic.severity
      update-in-insert true
      underline {:severity {:min Severity.HINT}}
      signs {:severity {:min Severity.WARN}}
      virtual-text {:severity {:min Severity.ERROR}}]

  (vim.diagnostic.config {:update_in_insert update-in-insert
                          :underline underline
                          :signs signs
                          :virtual_text virtual-text})
  
  (keymap [n] :g? "<cmd>lua vim.diagnostic.open_float()<cr>"))
