(local lsp-server
  {:cmd ["typescript-language-server.cmd" "--stdio"]
   :root ["package.json" "tsconfig.json" "jsconfig.json"]})

(with-module [lsp :lsp]
  (lsp.start lsp-server))
