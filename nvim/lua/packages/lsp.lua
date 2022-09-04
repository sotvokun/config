local packages = {
  {'hrsh7th/cmp-nvim-lsp'},

  {'neovim/nvim-lspconfig'},
  {'jose-elias-alvarez/null-ls.nvim'},
  {
    'williamboman/mason.nvim',
    requires = {'williamboman/mason-lspconfig.nvim'}
  },
  {
    'stevearc/aerial.nvim',
    config = function() require('aerial').setup() end
  },
  {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup({
        icons = false,
        fold_open = 'v',
        fold_closed = '>',
        indent_lines = false,
        signs = {
          error = 'error',
          warning = 'warn',
          hint = 'hint',
          information = 'info'
        }
      })
    end
  },
  {
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup({
        hint_enable = false,
        handler_opts = {
          border = 'single'
        }
      })
    end
  },
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup({
        autocmd = {
          enabled = true
        }
      })
      -- vim.fn.sign_define('LightBulbSign', {
      --   text = 'A',
      --   texthl = 'A',
      --   linehl = 'A',
      --   numhl = 'A',
      -- })
    end
  },

  {'mfussenegger/nvim-dap'},

  {
    'kevinhwang91/nvim-ufo',
    requires = { 'kevinhwang91/promise-async' }
  },

}

return packages
