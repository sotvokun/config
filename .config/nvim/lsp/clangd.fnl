(let [clangd (vim.fn.exepath "clangd")]
  {:filetypes ["c" "cpp"]
   :cmd [clangd "--background-index"]
   :root_markers [".clangd" ".clang-tidy" ".clang-format" "compile_commands.json" "compile_flags.txt" ".git"]
   :capabilities {:textDocument {:completion {:editsNearCursor true}}}})
