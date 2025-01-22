; bundle/plugin/ccc.fnl - ccc.nvim configurations
;

(exit-if! (not (pcall require "ccc")))

(exit-if! vim.g.loaded_ccc_after)
(set vim.g.loaded_ccc_after true)


(with-module [ccc :ccc]
  (ccc.setup
    {:highlighter {:filetypes ["vim"]}}))
