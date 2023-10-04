(vscode-incompatible!)

(with-module [gitsigns :gitsigns]
  (gitsigns.setup 
    {:signcolumn (not= 1 (vim.fn.exists "g:vscode"))})
  
  (keymap [nv] :<leader>gs "<cmd>Gitsigns stage_hunk<cr>")
  (keymap [nv] :<leader>gS "<cmd>Gitsigns stage_buffer<cr>")
  (keymap [nv] :<leader>gu "<cmd>Gitsigns undo_stage_hunk<cr>")
  (keymap [nv] :<leader>gr "<cmd>Gitsigns reset_hunk<cr>")
  (keymap [n] :<leader>gP "<cmd>Gitsigns preview_hunk<cr>")
  
  (keymap [n] "]g" "<cmd>Gitsigns next_hunk<cr>")
  (keymap [n] "[g" "<cmd>Gitsigns prev_hunk<cr>"))
