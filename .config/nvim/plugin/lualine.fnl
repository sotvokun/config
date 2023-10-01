
; Component
; --------------------

(fn lsp-server []
  (local bufnr (vim.fn.bufnr))
  (local active-clients (vim.lsp.get_active_clients))
  (local client-strings 
    (icollect [_ srv (ipairs active-clients)] 
      (when (. srv.attached_buffers bufnr) srv.name)))
  (table.concat client-strings " "))

(fn indent []
  (local expandtab (if vim.bo.expandtab "SPC" "TAB"))
  (local tabstop vim.bo.tabstop)
  (local shiftwidth vim.bo.shiftwidth)
  (table.concat [expandtab " ts=" tabstop " sw=" shiftwidth] " "))


; Macros
; --------------------
(macro module [name ...]
  `(vim.tbl_extend :keep [,(tostring name)] (list->table ,[...])))

(macro module-comp [comp ...]
  `(vim.tbl_extend :keep [,comp] (list->table ,[...])))

; Setup
; --------------------
(with-module [lualine :lualine]
  (local options 
    {:section_separators "" 
     :component_separators ""
     :theme "solarized"})

  (local sections_
    {:lualine_a [(module mod 
                         :fmt (fn [] " ") 
                         :padding {:left 0 :right 0})]
     :lualine_b [(module filename 
                         :path 1)]
     :lualine_c [(module branch)
                 (module diff)]

     :lualine_x [{:1 lsp-server}
                 (module diagnostics 
                         :symbols {:error "E " :warn "W " :info "I " :hint "H "})
                 (module filetype)
                 (module fileformat 
                         :symbols {:unix "LF" :dos "CRLF" :mac "CR"})
                 (module encoding 
                         :fmt (fn [str] (string.upper str)))
                 (module location)]
     :lualine_y []
     :lualine_z []})
  
  (local sections
    {:lualine_a [(module mod 
                         :fmt (fn [] " ") 
                         :padding {:left 0 :right 0})]
     :lualine_b [(module filename :path 1)]
     :lualine_c [(module branch) 
                 (module diff)]
     
     :lualine_x [(module-comp lsp-server)
                 (module diagnostics 
                         :symbols {:error "E " :warn "W " :info "I " :hint "H "})
                 (module filetype)
                 (module fileformat 
                         :symbols {:unix "LF" :dos "CRLF" :mac "CR"})
                 (module encoding 
                         :fmt (fn [str] (string.upper str)))
                 (module location)]
     :lualine_y []
     :lualine_z []})

  (local inactive-sections
    {:lualine_a []
     :lualine_b []
     :lualine_c [(module filename :path 1)]
     :lualine_x [(module location)]
     :lualine_y []
     :lualine_z []})
  
  (local tabline
    {:lualine_a []
     :lualine_b [(module tabs :mode 2)]
     :lualine_c []
     :lualine_x [(module-comp indent 
                              :color "Comment")]
     :lualine_y []
     :lualine_z []})
  
  (lualine.setup 
    {: options 
     : sections
     :inactive_sections inactive-sections}))
