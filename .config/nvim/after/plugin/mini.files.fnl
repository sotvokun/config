(vscode-incompatible!)
(with-module [files :mini.files]
  (files.setup)
  
  (keymap [n] "<c-n>" 
          #(if (not (MiniFiles.close)) (MiniFiles.open)))
  
  (augroup minifiles#)
  (autocmd minifiles# [User]
           :pattern "MiniFilesBufferCreate"
           :callback
           (fn [args]
             (let [buf-id args.data.buf_id]
               (do
                 (keymap [n] :<esc> #(MiniFiles.close) :buffer buf-id)
                 (keymap [n] :<cr> #(match (MiniFiles.get_fs_entry)
                                      {:fs_type "file"} (do (MiniFiles.go_in) (MiniFiles.close))
                                      _ (MiniFiles.go_in))
                         :buffer buf-id))))))
