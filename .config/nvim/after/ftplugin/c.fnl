(local lsp-server
  {:cmd ["clangd" "--background-index"]
   :root [".clangd" ".clang-format" "compile_commands.json" "compile_flags.txt" "CMakeLists.txt"]
   :flags {:debounce_text_changes 20}
   :capabilities {:textDocument {:completion {:editsNearCursor true}
                                 :offsetEncoding [:utf-8 :utf-16]}}})

(with-module [lsp :lsp]
  (lsp.start lsp-server))
