; snippet.fnl - The configurations for snippet support
; | Snippet (snippy)

; Snippet ======================================

(with-module [snippy :snippy]
  (local local-snippet-dir (if vim.g.vscode ".vscode/snippets" ".snippets"))
  (snippy.setup {:local_snipet_dir local-snippet-dir})
  
  (keymap [i] "<c-]>" #(if (snippy.can_expand_or_advance) (snippy.expand_or_advance) 
                         (feedkeys "<c-]>"))
          :desc "Expand snippet or jump to next placeholder")
  (keymap [ s] "<c-[>" #(if (snippy.can_jump 1) (snippy.next)
                          (feedkeys "<c-[>"))
          :desc "Jump to next placeholder")
  (keymap [is] "<c-}>" #(if (snippy.can_jump -1) (snippy.previous)
                          (feedkeys "<c-}>"))
          :desc "Jump to previous placeholder"))
