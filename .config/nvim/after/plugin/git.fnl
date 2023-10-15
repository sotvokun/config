; git.fnl - The configurations for git integration
; | Common (gitsigns)

(vscode-incompatible!)

; Common =======================================

(with-module [gitsigns :gitsigns]
  (gitsigns.setup) 
  
  (keymap [n] "]g" "<cmd>Gitsigns next_hunk<cr>")
  (keymap [n] "[g" "<cmd>Gitsigns prev_hunk<cr>")
  
  (keymap [nv] :<leader>gs "<cmd>Gitsigns stage_hunk<cr>"      :desc "Stage hunk")
  (keymap [nv] :<leader>gS "<cmd>Gitsigns stage_buffer<cr>"    :desc "Stage buffer")
  (keymap [nv] :<leader>gu "<cmd>Gitsigns undo_stage_hunk<cr>" :desc "Undo stage hunk")
  (keymap [nv] :<leader>gr "<cmd>Gitsigns reset_hunk<cr>"      :desc "Reset hunk")

  (keymap [n]  :<leader>gg "<cmd>Git<cr>"                           :desc "Open fugitive")
  (keymap [n]  :<leader>gcc "<cmd>Git commit<cr>"                   :desc "Create a commit")
  (keymap [n]  :<leader>gca "<cmd>Git commit --amend<cr>"           :desc "Amend a commit")
  (keymap [n]  :<leader>gce "<cmd>Git commit --amend --no-edit<cr>" :desc "Amend a commit without editing")

  (keymap [n]  :<leader>gB "<cmd>Git blame<cr>"                     :desc "Blame current file")
  (keymap [n]  :<leader>gL "<cmd>Git log<cr>"                       :desc "Show git log")
  
  (augroup fugitive#)
  (autocmd fugitive# [FileType] 
           :pattern ["fugitive*" "git"] 
           :callback 
           #(let [{: buf} $1]
              (keymap [n] :q "<cmd>q<cr>" :desc "Quit" :buffer buf)
              (vim.api.nvim_set_option_value "number" false {: buf}))))
