local use = require('svim.modules.package').use

if not pcall(require, 'lspconfig') then
  return
end

-- Packages ----------------------------------------------------------
use {'stevearc/aerial.nvim',
     config =
     function() require('aerial').setup() end}

use {'folke/trouble.nvim',
     config =
     function()
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
     end}

use {'ray-x/lsp_signature.nvim',
     config =
     function()
       require('lsp_signature').setup({
         bind = true,
         hint_enable = false,
         handler_opts = {
           border = 'single'
         }
       })
     end}

use {'kosayoda/nvim-lightbulb',
     config =
     function()
       require('nvim-lightbulb').setup({
         autocmd = {enabled = true}
       })
       vim.fn.sign_define('LightBulbSign', {
         text = 'A',
         texthl = 'A',
         linehl = 'A',
         numhl = 'A'
       })
     end}

use {'j-hui/fidget.nvim', config = function() require('fidget').setup() end}

use {'kevinhwang91/nvim-ufo',
     requires = {'kevinhwang91/promise-async'},
     config =
     function()
       require('ufo').setup({
         provider_selector = function(bufnr, filetype, buftype)
           return {'lsp', 'indent'}
         end})
     end}
