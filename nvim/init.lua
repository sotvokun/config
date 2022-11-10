pcall(require, 'impatient')

require('svim.options')
require('svim.bootstrap')

if _G['svim/bootstrap'] then
  require('svim.packages')
  require('svim.modules.tree-sitter')
  require('svim.modules.lualine')
  require('svim.modules.nvim-cmp')
  require('svim.modules.snippet').apply()

  -- LSP Configurations
  require('svim.modules.lsp').apply(function (use)
    -- EXAMPLE: Setup language server
    -- use {<name of ls>, setup = <options>, raw = <manually setup>}
    -- use {'racket_langserver'}
  end)
  require('svim.modules.lsp-util')
  require('svim.modules.null-ls').apply(function (use)
    use({'cspell', {diagnostics = {
      diagnostics_postprocess = function (diagnostic)
        diagnostic.severity = vim.diagnostic.severity['WARN']
      end
    }}})
  end)

  -- Development Spec
  require('svim.modules.web-dev')

  require('svim.keymaps')
  require('svim.autocmds')
  require('svim.modules.package').apply()
end
