-- =========================================================
--
-- treesitter.lua
--
-- =========================================================

svim.use {'nvim-treesitter/nvim-treesitter', branch = 'v0.8.0'}
svim.use {'nvim-treesitter/nvim-treesitter-context'}
svim.use {'nvim-treesitter/nvim-treesitter-textobjects'}

local textobj_select_keymap = {
    ['af'] = '@function.outer',
    ['if'] = '@function.inner',
    ['ac'] = '@class.outer',
    ['ic'] = '@class.inner',
    ['ia'] = '@attribute.inner',
    ['aa'] = '@attribute.outer'
}

svim.require('nvim-treesitter.configs', function(config)
    config.setup({
        highlight = {
            enable = true
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = textobj_select_keymap
            }
        }
    })
end)

svim.require('treesitter-context', function(ctx)
    ctx.setup()
end)
