(require-macros :svim.macros.keymap)
(require-macros :svim.macros.vim)

; Leader key
(call/cmd nnoremap :<space> :<nop>)
(set vim.g.mapleader " ")

; Movement
; - Normal mode
(set-keymap :<c-h> :<c-w>h :label "Go to left window")
(set-keymap :<c-j> :<c-w>j :label "Go to down window")
(set-keymap :<c-k> :<c-w>k :label "Go to up window")
(set-keymap :<c-l> :<c-w>l :label "Go to right window")

; - Insert mode
(set-keymap :<a-h> "<c-\\><c-n><c-w>h" :mode :i)
(set-keymap :<a-j> "<c-\\><c-n><c-w>j" :mode :i)
(set-keymap :<a-k> "<c-\\><c-n><c-w>k" :mode :i)
(set-keymap :<a-l> "<c-\\><c-n><c-w>l" :mode :i)

; Buffers
(set-keymap :<leader>eb "<cmd>ene<cr>" :label "Buffer")
(set-keymap :dq ":Bdelete<cr>" :label "Buffer")
(set-keymap :dQ ":bd" :label "Buffer and layout")

; Quickfix
(set-keymap :d! ":ccl<cr>" :label "Close Quickfix")

; REACH - GO
(let [{: buffers : tabpages} (require :reach)
      buf-opts {:handle :dynamic
                :show_icons false
                :modified_icon "[+]"
                :previous {
                           :depth 1}}
      tabp-opts {:show_icons false}
      reach-open-tabpage (lambda [] (tabpages tabp-opts))
      reach-open-buffer (lambda [] (buffers buf-opts))]
  (do
    (set-keymap :<leader>gt reach-open-tabpage :label "Tabpages")
    (set-keymap :<leader>gb reach-open-buffer :label "Buffers")
    (set-keymap :<leader>b reach-open-buffer :label "Buffers")))

; TELESCOPE
(set-keymap :<c-p> ":Telescope<cr>" :label "Open Telescope")
(set-keymap :<leader>fb ":Telescope buffers<cr>" :label "Buffers")
(set-keymap :<leader>ff ":Telescope find_files<cr>" :label "Files")
(set-keymap :<leader>fh ":Telescope help_tags<cr>" :label "Help tags")
(set-keymap :<leader>fo ":Telescope oldfiles<cr>" :label "History files")
(set-keymap :<leader>fk ":Telescope keymaps<cr>" :label "Keymaps")
(set-keymap :<leader>fs ":Telescope lsp_document_symbols<cr>" :label "Document symbols")
(set-keymap :<leader>fS ":Telescope lsp_dynamic_workspace_symbols<cr>" :label "Workspace symbols (Dynamic)")
(set-keymap :<leader>fT ":TodoTelescope<cr>" :label "Todo comments")

; NEOTREE
(set-keymap :<c-n> ":NvimTreeToggle<cr>" :label "Toggle Nvim-Tree")

; LSP
(set-keymap :gD "<cmd>lua vim.lsp.buf.declaration()<cr>" :label "Go to declaration [LSP]")
(set-keymap :gd "<cmd>lua vim.lsp.buf.definition()<cr>" :label "Go to definition [LSP]")
(set-keymap :gr "<cmd>lua vim.lsp.buf.references()<cr>" :label "Go to references [LSP]")
(set-keymap :gi "<cmd>lua vim.lsp.buf.implementation()<cr>" :label "Go to implmentations [LSP]")
(set-keymap :K "<cmd>lua vim.lsp.buf.hover()<cr>" :label "Hover [LSP]")
(set-keymap :<leader>ca "<cmd>lua vim.lsp.buf.code_action()<cr>" :label "Code Action")
(set-keymap :<leader>cd "<cmd>:TroubleToggle<cr>" :label "Open diagnostic window")
(set-keymap :<leader>cf "<cmd>lua vim.lsp.buf.formatting()<cr>" :label "Formatting")
(set-keymap :<leader>cr "<cmd>lua vim.lsp.buf.rename()<cr>" :label "Rename")
(set-keymap :<leader>ck "<cmd>lua vim.lsp.buf.signature_help()<cr>" :label "Signature")
(set-keymap :<leader>cD "<cmd>lua vim.lsp.buf.type_definition<cr>" :label "Go to type definition")
(set-keymap :<leader>cs ":AerialToggle<cr>" :label "List all symbols with tree (Aerial)")
(set-keymap :<leader>cS "<cmd>lua vim.lsp.buf.document_symbol()<cr>" :label "Lists all symbols")
(set-keymap :<leader>cI "<cmd>lua vim.lsp.buf.incoming_calls()<cr>" :label "List all call sites of the symbol")
(set-keymap :<leader>cI "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>" :label "List all sites that are called by the symbol")

(set-keymap-label :<leader>cw "Workspace")
(set-keymap :<leader>cwa "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>" :label "Add")
(set-keymap :<leader>cwr "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>" :label "Remove")
(set-keymap :<leader>cwl "<cmd>lua =vim.lsp.buf.list_workspace_folder()<cr>" :label "List")

(set-keymap-label :<leader>cL :label "LSP")
(set-keymap :<leader>cLi ":LspInfo<cr>" :label "Info")
(set-keymap :<leader>cLr ":LspRestart<cr>" :label "Restart")
(set-keymap :<leader>cLs ":LspStart<cr>" :label "Start")
(set-keymap :<leader>cLx ":LspStop<cr>" :label "Stop")

; TAB CONTROL
(set-keymap "[t" ":tabp<cr>" :label "Go to previous tab")
(set-keymap "]t" ":tabn<cr>" :label "Go to next tab")
(set-keymap :<leader>et ":tabnew<cr>" :label "Tab")

; WINDOW MOVEMENT
(set-keymap :<c-h> "<c-w>h" :label "Move to the left window")
(set-keymap :<c-j> "<c-w>j" :label "Move to the down window")
(set-keymap :<c-k> "<c-w>k" :label "Move to the up window")
(set-keymap :<c-l> "<c-w>l" :label "Move to the right window")

; TERMINAL
(set-keymap-label "<leader>t" :label "Terminal")
(set-keymap "<c-\\>" (lambda [] (call/cmd ToggleTerm))
            :mode [:n :t]
            :label "Toggle terminal")
(set-keymap :<leader>tt ":ToggleTerm<cr>" 
            :mode [:n :t]
            :label "Toggle")
(set-keymap :<esc> :<C-\><C-n> :mode :t)
(set-keymap :<c-h> "<c-\\><c-n><c-w>h" :mode :t)
(set-keymap :<c-j> "<c-\\><c-n><c-w>j" :mode :t)
(set-keymap :<c-k> "<c-\\><c-n><c-w>k" :mode :t)
(set-keymap :<c-l> "<c-\\><c-n><c-w>l" :mode :t)

; QUICK SETTING
(set-keymap :<leader>qr ":set rnu!<cr>" :label "Relative number")
(set-keymap :<leader>qw ":set wrap!<cr>" :label "Text wrap")
(set-keymap :<leader>qq ":nohls<cr>" :label "Disable search highlighting")
(set-keymap :<leader>qz ":ZenMode<cr>" :label "Zen Mode")

;----------------
; BETTER EDITING
;----------------
(set-keymap :< :<gv :mode :v)
(set-keymap :> :>gv :mode :v)

; Move selected line and block
(set-keymap :<a-j> ":m '>+1<cr>gv-gv" :mode :x :label "Move selected up")
(set-keymap :<a-k> ":m '<-2<cr>gv-gv" :mode :x :label "Move selected down")

;-------------------
; LABEL FOR PLUGINS
;-------------------
(set-keymap-label "s" "Leap forward")
(set-keymap-label "S" "Leap backward")

;----------------------
; LABEL FOR LEADERMENU
;----------------------
(set-keymap-label :<leader>e "New")
(set-keymap-label :<leader>f "Find")
(set-keymap-label :<leader>c "Code(LSP)")
(set-keymap-label :<leader>q "Quick Setting")
(set-keymap-label :<leader>g "Go")
(set-keymap-label :<leader>t "Terminal")
