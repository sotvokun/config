(with-module [lsp :lsp]
  (lsp.start {:cmd ["intelephense" "--stdio"]
              :root ["composer.json"]}))
