; after/after/fidget.fnl - fidget.nvim configuration
;

(if vim.g.loaded_fidget_after (values nil)
    (set vim.g.loaded_fidget_after true))

(let [(ok fidget) (pcall require :fidget)]
  (if ok (fidget.setup)))
