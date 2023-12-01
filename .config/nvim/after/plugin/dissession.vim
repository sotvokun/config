nnoremap <expr><leader>$ (dissession#check() ? "<cmd>call dissession#load()<cr>" : "<cmd>call dissession#save()<cr>")
