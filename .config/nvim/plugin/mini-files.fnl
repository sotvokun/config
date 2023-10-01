(with-module [mini-files :mini.files]
  (mini-files.setup)
  (keymap [n] "<c-n>" (fn [] (if (not (MiniFiles.close)) (MiniFiles.open))))
  
  (augroup minifiles#)
  (autocmd minifiles# [User] 
           :pattern "MiniFilesBufferCreate"
           :callback 
           (fn [args]
             (let [buf_id args.data.buf_id]
               (do
                 (keymap [n] :<esc> #(MiniFiles.close) :buffer buf_id)
                 (keymap [n] :<cr> #(match (MiniFiles.get_fs_entry)
                                      {:fs_type "file"} (do (MiniFiles.go_in) (MiniFiles.close))
                                      _ (MiniFiles.go_in)) 
                         :buffer buf_id))))))
