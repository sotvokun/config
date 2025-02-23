(let [gopls (vim.fn.exepath "gopls")]
  {:filetypes ["go"]
   :cmd [gopls]
   :root_markers ["go.mod"]
   :init_options {:usePlaceholders true :completeUnimported true}
   :settings {:autoformat true}})
