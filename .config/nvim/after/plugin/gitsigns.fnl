(vscode-incompatible!)

(with-module [gitsigns :gitsigns]
  (gitsigns.setup) 
  
  (keymap [nv] :<leader>gs "<cmd>Gitsigns stage_hunk<cr>"      :desc "Stage hunk")
  (keymap [nv] :<leader>gS "<cmd>Gitsigns stage_buffer<cr>"    :desc "Stage buffer")
  (keymap [nv] :<leader>gu "<cmd>Gitsigns undo_stage_hunk<cr>" :desc "Undo stage hunk")
  (keymap [nv] :<leader>gr "<cmd>Gitsigns reset_hunk<cr>"      :desc "Reset hunk")
  (keymap [n]  :<leader>gP "<cmd>Gitsigns preview_hunk<cr>"    :desc "Preview hunk")
  
  (keymap [n] "]g" "<cmd>Gitsigns next_hunk<cr>")
  (keymap [n] "[g" "<cmd>Gitsigns prev_hunk<cr>"))
