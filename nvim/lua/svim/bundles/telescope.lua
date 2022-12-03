-- =========================================================
--
-- lisp.lua
--
-- =========================================================

svim.use {'nvim-telescope/telescope.nvim'}
svim.use {'LukasPietzschmann/telescope-tabs'}
svim.use {'GustavoKatel/telescope-asynctasks.nvim'}

local telescope_config = {
    defaults = {
        layout_strategy = 'bottom_pane',
        border = false
    }
}

svim.require('telescope-tabs', function(tt)
    tt.setup()
end)

svim.require('telescope', function (t)
    t.setup(telescope_config)
    -- * Keymap
    svim.map('n', '<leader>fb', ':Telescope buffers<cr>')
    svim.map('n', '<leader>ff', ':Telescope fd previewer=false<cr>')
    svim.map('n', '<leader>fg', ':Telescope live_grep<cr>')
    svim.map('n', '<leader>fo', ':Telescope oldfiles<cr>')
    svim.map('n',
        '<leader>ft', function() require('telescope-tabs').list_tabs() end)
    svim.map('n',
        '<leader>fq', function() require('telescope').extensions.asynctasks.all() end)
end)
