(local lsp-server
  {:cmd ["intelephense" "--stdio"]
   :root ["composer.json"]})

(with-module [lsp :lsp]
  (lsp.start lsp-server))
