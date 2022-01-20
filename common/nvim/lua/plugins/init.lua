vim.cmd("packadd packer.nvim")
local packer = require('packer')

--[[
{
    uid = "",               -- plugin unique identifier
    setup = function,       -- the setup method
    post_sync = function,   -- post-install/update method
}
--]]
local plugin_list = {
    -- UI
    {"mcchrish/zenbones.nvim"},
    {
        "nvim-lualine/lualine.nvim",
        setup = function() require('plugins/lualine') end
    },

    -- Helper
    {
        "folke/which-key.nvim",
        setup = function() require('plugins/which-key') end
    },
    {
        "nvim-telescope/telescope.nvim",
        post_sync = function() vim.cmd("checkhealth telescope") end,
        setup = function() require('plugins/telescope') end
    },
    {"nvim-telescope/telescope-file-browser.nvim"},

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        post_sync = function() vim.cmd("TSUpdate") end,
        setup = function() require('plugins/nvim-treesitter') end
    },

    -- LSP
    {"neovim/nvim-lspconfig"},
    {
        "williamboman/nvim-lsp-installer",
        post_sync = function() vim.cmd("checkhealth nvim-lsp-installer") end,
        setup = function() require('plugins/lsp') end
    },

    -- Snippets
    {"L3MON4D3/LuaSnip"},

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        setup = function() require('plugins/nvim-cmp') end
    },
    {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"},
    {"hrsh7th/cmp-cmdline"},
    {"saadparwaiz1/cmp_luasnip"},

    -- Dependencies
    {"rktjmp/lush.nvim"},       -- zenbones.nvim
    {"nvim-lua/plenary.nvim"}   -- telescope.nvim
}


--[[PACKER_WORK::BEGIN]]
packer.startup({
function()
    -- Packer
    use "wbthomason/packer.nvim"

    for _, val in ipairs(plugin_list) do
        local item = {[1] = val[1]}
        if val.post_sync then
            item.run = val.post_sync
        end
        if val.branch then
            item.branch = val.branch
        end
        if val.commit then
            item.commit = val.commit
        end
        use(item)
    end
end,
config = {
    display = {
        open_fn = require('packer.util').float
    }
}
})
--[[PACKER_WORK::END]]

return plugin_list
