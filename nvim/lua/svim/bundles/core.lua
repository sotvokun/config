-- =========================================================
--
-- core.lua
--
-- =========================================================

-- - Requirements
svim.use {'nvim-lua/plenary.nvim'}
svim.use {'tpope/vim-repeat'}


-- - Editing
svim.use {'numToStr/Comment.nvim'}
svim.require('Comment')

svim.use {'windwp/nvim-autopairs'}
svim.require('nvim-autopairs', function(ap)
    ap.setup({ fast_wrap = {} })
end)

svim.use {'kylechui/nvim-surround'}
svim.require('nvim-surround')

svim.use {'ggandor/leap.nvim'}
svim.require('leap', function(leap)
    leap.set_default_keymaps()
end)

svim.use {'folke/todo-comments.nvim'}
svim.require('todo-comments', function(tc)
    tc.setup({ signs = false })
end)


-- - Git
svim.use {'tpope/vim-fugitive'}
svim.use {'lewis6991/gitsigns.nvim'}
svim.require('gitsigns', function(gs)
    gs.setup()
    -- * Keymap
    svim.map('n', ']g', ':Gitsigns next_hunk<cr>')
    svim.map('n', '[g', ':Gitsigns prev_hunk<cr>')
end)


-- - Face
svim.use {'lukas-reineke/indent-blankline.nvim'}
svim.use {'stevearc/dressing.nvim'}
svim.use {'goolord/alpha-nvim'}
svim.require('alpha', function(alpha)
    local startify = require('alpha.themes.startify')
    startify.nvim_web_devicons.enabled = false
    alpha.setup(startify.config)
end)


-- - File and fuzzy finder
svim.use {'lambdalisue/fern.vim'}
svim.require(function()
    vim.g['fern#renderer#default#leaf_symbol'] = ' '
    vim.g['fern#renderer#default#collapsed_symbol'] = '+ '
    vim.g['fern#renderer#default#expanded_symbol'] = '- '
    vim.g['fern#hide_cursor'] = 1
    -- * Keymap
    svim.map('n', '<c-n>', ':Fern . -drawer -toggle<cr>')
    vim.api.nvim_create_autocmd('FileType', {
        pattern = {"fern"},
        callback = function()
            vim.o.number = false
            svim.map('n', '<c-l>', '<c-w>l')
            svim.map('n', '<c-n>', ':Fern . -drawer -toggle<cr>')
            svim.map('n', '<c-r>', '<Plug>(fern-action-redraw)')
        end
    })
end)


-- - Keymap
svim.use {'anuvyklack/hydra.nvim'}


-- - Terminal
svim.use {'akinsho/toggleterm.nvim'}
svim.require('toggleterm', function(tt)
    local shell = 'bash'
    if vim.fn.has('win32') == 1 then
        shell = 'powershell'
    end
    tt.setup({ shell = shell })
    -- * Keymap
    svim.map('n', '<c-\\>', ':ToggleTerm direction=float<cr>')
    svim.map('t', '<c-\\>', '<c-\\><c-n>:ToggleTerm<cr>')
    svim.map('t', '<esc>', '<c-\\><c-n>')
end)


-- - Tasks
svim.use {'skywind3000/asynctasks.vim'}
svim.use {'skywind3000/asyncrun.vim'}
svim.require(function()
    vim.g.asyncrun_open = 6
    vim.g.asynctasks_config_name = ".vim/tasks.ini"
end)


-- - Misc
svim.use {'MunifTanjim/exrc.nvim'}
svim.require('exrc', function(exrc)
    exrc.setup({
        files = {".vim/exrc.lua", ".vim/exrc.vim"}
    })
end)

svim.use {'gpanders/editorconfig.nvim'}
svim.use {'tpope/vim-dotenv'}
svim.use {'folke/zen-mode.nvim'}
svim.require('zen-mode')
