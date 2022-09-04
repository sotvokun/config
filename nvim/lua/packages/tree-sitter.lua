local packages = {
  { 
    'nvim-treesitter/nvim-treesitter' ,
    config = function()
      local configs = require('nvim-treesitter.configs')
      configs.setup({
        highlight = {
          enable = true,
        }
      })
    end
  },
  {'nvim-treesitter/nvim-treesitter-textobjects'}
}

return packages