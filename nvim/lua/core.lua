local ensure_installed = require('utils').ensure_installed

ensure_installed('https://github.com/wbthomason/packer.nvim')
ensure_installed('https://github.com/lewis6991/impatient.nvim')

-- Initialization --------------------------------------------------------------

require('impatient')

require('packages').setup({
  load = { 'tree-sitter', 'lsp' }
})

require('lsp').startup(function(use)
  use {
    'lua-language-server',
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT'
        },
        diagnostics = {
          globals = { 'vim' }
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
          }
        }
      }
    }
  }

  use({
    'diagnostics.cspell',
    diagnostics_postprocess = function(diagnostic)
      diagnostic.severity = vim.diagnostic.severity.HINT
    end
  }, true)
end)

require('keymap')
