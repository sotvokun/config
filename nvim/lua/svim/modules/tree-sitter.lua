local use = require('svim.modules.package').use

use {'nvim-treesitter/nvim-treesitter'}
use {'windwp/nvim-ts-autotag'}
use {'nvim-treesitter/nvim-treesitter-context',
     config =
     function ()
       require('treesitter-context').setup()
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
