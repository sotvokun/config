pcall(require, 'impatient')

require('svim.options')
require('svim.bootstrap')

if _G['svim/bootstrap'] then
  require('svim.packages')
  require('svim.modules.tree-sitter')
  require('svim.modules.lualine')
  require('svim.modules.nvim-cmp')

  -- LSP Configurations
  require('svim.modules.lsp').apply(function (use)
    -- EXAMPLE: Setup language server
    -- use {<name of ls>, setup = <options>, raw = <manually setup>}
    use {'racket_langserver'}
  end)
  require('svim.modules.lsp-util')
  require('svim.modules.null-ls').apply(function (use)
    -- EXAMPLE: Use builtin source
    -- use {<category>, <source>, setup = <options>}
  end)

  require('svim.keymaps')
  require('svim.modules.package').apply()
end
