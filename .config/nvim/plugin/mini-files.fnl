(with-module [mini-files :mini.files]
  (mini-files.setup)
  (keymap [n] "<c-n>" (fn [] (if (not (MiniFiles.close)) (MiniFiles.open)))))
