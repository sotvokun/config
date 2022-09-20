local use = require('svim.modules.package').use

-- Packages ----------------------------------------------------------
use {'L3MON4D3/LuaSnip'}
use {'saadparwaiz1/cmp_luasnip'}
use {'rafamadriz/friendly-snippets'}

-- Exports -----------------------------------------------------------
local M = {}

M.apply = function(setup)
  local ok, luasnip = pcall(require, 'luasnip')
  if not ok then return end

  if type(setup) == 'function' then
    setup(luasnip)
  end

  require('luasnip.loaders.from_vscode').lazy_load()
end

return M
