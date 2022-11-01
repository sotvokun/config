local use = require('svim.modules.package').use

use {'nvim-treesitter/nvim-treesitter',
     commit = '4cccb6f494eb255b32a290d37c35ca12584c74d0'}
use {'windwp/nvim-ts-autotag'}
use {'nvim-treesitter/nvim-treesitter-context',
     config =
     function ()
       require('treesitter-context').setup()
     end}
use {'danymat/neogen', config = function()
      require('neogen').setup({})
     end}

-- Apply -------------------------------------------------------------
do
  local ok, tsconfig = pcall(require, 'nvim-treesitter.configs')
  if ok then
    tsconfig.setup({
      autotag = { enable = true },
      highlight = { enable = true }
    })
  end
end
