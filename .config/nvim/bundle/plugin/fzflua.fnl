; bundle/plugin/fzf.fnl - fzf-lua configurations
;


(exit-if! (not (pcall require "fzf-lua")))

(exit-if! vim.g.loaded_fzflua_after)
(set vim.g.loaded_fzflua_after true)


(keymap n :<leader>f "<cmd>FzfLua files<cr>")
(keymap n :<leader>o "<cmd>FzfLua oldfiles<cr>")
(keymap n :<leader>b "<cmd>FzfLua buffers<cr>")
(keymap n :<leader>% "<cmd>FzfLua live_grep<cr>")

(with-module [fzflua :fzf-lua]
  (fzflua.register_ui_select)
  (fzflua.setup
    {:fzf_colors true
     :winopts {:border "none" 
               :backdrop 45
               :preview {:border "none"}}
     :previewers {:builtin {:syntax false :treesitter false}}
     :lsp {:symbols {:symbol_style 3}}}))
