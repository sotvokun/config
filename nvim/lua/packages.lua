local packages = {
  -- Main
  {'wbthomason/packer.nvim'},
  {'lewis6991/impatient.nvim'},
  {'nvim-lua/plenary.nvim'},
  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup()
    end
  },
  {
    'anuvyklack/hydra.nvim'
  },

  -- Faces
  {'EdenEast/nightfox.nvim'},
  {
    'b0o/incline.nvim',
    config = function() require('incline').setup() end
  },
  {
    'nvim-lualine/lualine.nvim',
    config = require('configs.lualine')
  },
  {'lukas-reineke/indent-blankline.nvim'},
  {
    'stevearc/dressing.nvim',
    config = function() require('dressing').setup() end
  },
  {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup() end
  },

  -- File Exploring
  {
    'kyazdani42/nvim-tree.lua',
    config = require('configs.nvim-tree')
  },
  {
    'nvim-telescope/telescope.nvim',
    config = require('configs.telescope')
  },
  {'nvim-telescope/telescope-project.nvim'},

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    config = require('configs.nvim-cmp'),
    requires = {
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path'
    }
  },

  -- Snippets
  {
    'hrsh7th/vim-vsnip',
    setup = function()
      vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/snippets'
    end
  },
  {'rafamadriz/friendly-snippets'},

  -- Editing
  { 
    'numToStr/Comment.nvim', 
    config = function() require('Comment').setup() end 
  },
  { 
    'windwp/nvim-autopairs', 
    config = function() 
      require('nvim-autopairs').setup({
        ignored_next_char = '[%w]'
      })
    end 
  },
  { 
    'kylechui/nvim-surround', 
    config = function() require('nvim-surround').setup() end
  },
  {
    'ggandor/leap.nvim',
    config = function() require('leap').set_default_keymaps() end
  },

  -- Git
  {'TimUntersberger/neogit'},
  {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end
  },

  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    config = function() 
      local cfg = {}
      if vim.fn.has('win32') == 1 then
        cfg.shell = 'powershell'
      end
      require('toggleterm').setup(cfg)
    end
  },

  -- Utilities
  {'dstein64/vim-startuptime'},
  {'gpanders/editorconfig.nvim'},
  {'famiu/bufdelete.nvim'},
  {
    'sotvokun/reach.nvim', 
    config = function() require('reach').setup() end
  },
  {
    'norcalli/nvim-colorizer.lua',
    ft = {'html', 'css', 'javascript', 'typescript', 'yaml', 'json'},
    config = function() require('colorizer') end
  },

  -- Game
  {'seandewar/nvimesweeper'},

  -- Misc
  {'antoinemadec/FixCursorHold.nvim'},
  {
    'folke/todo-comments.nvim',
    config = function() require('todo-comments').setup() end
  }
}

local setup = function(opts)
  if vim.tbl_islist(opts.load) then
    for _, v in ipairs(opts.load) do
      local ok, data = pcall(require, 'packages.' .. tostring(v))
      if ok then
        packages = vim.list_extend(packages, data)
      end
    end
  end

  require('packer').startup(function (use)
    for _, v in ipairs(packages) do
      use(v)
    end
  end)
end

return {
  setup = setup
}
