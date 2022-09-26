local use = require('svim.modules.package').use

-- Core
use {'wbthomason/packer.nvim'}
use {'lewis6991/impatient.nvim'}

-- Keymaps
use {'folke/which-key.nvim',
     config =
     function ()
       require('which-key').setup()
     end}

-- Pre-requirements
use {'nvim-lua/plenary.nvim'}
use {'antoinemadec/FixCursorHold.nvim'}

-- Faces
use {'EdenEast/nightfox.nvim',
     config =
     function()
       vim.cmd('colorscheme duskfox')
     end}
use {'lukas-reineke/indent-blankline.nvim'}
use {'stevearc/dressing.nvim',
     config =
     function()
       require('dressing').setup()
     end}
use {'goolord/alpha-nvim',
     config =
     function()
       require('svim.configs.alpha')
     end}

-- File and fuzzy finder
use {'nvim-telescope/telescope.nvim',
     config =
     function()
       require('svim.configs.telescope')
     end}
use {'nvim-neo-tree/neo-tree.nvim',
     config =
     function ()
       require('svim.configs.neo-tree')
     end,
     requires = {'MunifTanjim/nui.nvim'}}

-- Editing
use {'numToStr/Comment.nvim',
     config =
     function()
       require('Comment').setup()
     end}
use {'windwp/nvim-autopairs',
     config =
     function()
       require('nvim-autopairs').setup({
         ignored_next_char = '[%w]',
         fast_wrap = {}
       })
     end}
use {'kylechui/nvim-surround',
     config =
     function()
       require('nvim-surround').setup()
     end}
use {'ggandor/leap.nvim',
     config =
     function()
       require('leap').set_default_keymaps()
     end,
     requires =
     {'tpope/vim-repeat'}}
use {'s1n7ax/nvim-window-picker',
     config =
     function()
       require('window-picker').setup()
     end}

-- Git
use {'TimUntersberger/neogit'}
use {'sindrets/diffview.nvim'}
use {'lewis6991/gitsigns.nvim',
     config =
     function()
       require('gitsigns').setup()
     end}

-- Terminal
use {'akinsho/toggleterm.nvim',
     config =
     function()
       local opts = {}
       if vim.fn.has('win32') == 1 then
         opts.shell = 'powershell'
       end
       require('toggleterm').setup(opts)
     end}

-- Misc
use { 'sotvokun/lftp-sync.nvim' }
use {'gpanders/editorconfig.nvim'}
use {'dstein64/vim-startuptime'}
use {'famiu/bufdelete.nvim'}
use {'mbbill/undotree',
     setup =
     function()
       vim.g.undotree_WindowLayout = 2
     end}
