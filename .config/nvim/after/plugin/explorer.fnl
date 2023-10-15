; explorer.fnl
; | Files (mini.files)

(vscode-incompatible!)

; Files ========================================

(with-module [files :mini.files]
  (files.setup)
  
  (keymap [n] "<c-n>" 
          #(if (not (MiniFiles.close)) (MiniFiles.open)))
  

  ; Customization -------------------------------

  ; Press <cr> to enter a directory or open a file
  (fn enter-node []
    (match (MiniFiles.get_fs_entry)
      {:fs_type "file"} (do (MiniFiles.go_in) (MiniFiles.close))
      _ (MiniFiles.go_in)))

  ; Press gh to toggle dotfiles visibility
  (var dotfiles-visible? true)
  (fn toggle-dotfiles []
    (let [show (fn [] true)
          hide #(not (vim.startswith $1.name "."))]
      (do 
        (set dotfiles-visible? (not dotfiles-visible?))
        (local filter (if dotfiles-visible? show hide))
        (MiniFiles.refresh {:content {: filter}}))))

  ; Press <c-s> and <c-v> to split and vsplit selection file
  (fn split-selction [direction]
    (let [cmd (match direction 
                :v "vsplit"
                :t "tabnew"
                _ "split")
          entry (MiniFiles.get_fs_entry)]
      (when (and entry (= entry.fs_type "file"))
        (do
          (vim.cmd (string.format "%s %s" cmd entry.path))
          (MiniFiles.close)))))
    

  (augroup minifiles#)
  (autocmd minifiles# [User]
           :pattern "MiniFilesBufferCreate"
           :callback
           (fn [args]
             (let [buf-id args.data.buf_id]
               (do
                 (keymap [n] :<esc> #(MiniFiles.close) :buffer buf-id)
                 (keymap [n] :<cr> enter-node :buffer buf-id)
                 (keymap [n] :gh toggle-dotfiles :buffer buf-id)
                 (keymap [n] :<c-s> #(split-selction :s) :buffer buf-id)
                 (keymap [n] :<c-v> #(split-selction :v) :buffer buf-id)
                 (keymap [n] :<c-t> #(split-selction :t) :buffer buf-id))))))
