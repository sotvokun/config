-- =========================================================
--
-- colors.lua
--
-- =========================================================

svim.use {'sotvokun/falcon'}
svim.require('falcon', function()
    vim.g.falcon_detect_gui = 0
    vim.g.falcon_background = 1
    vim.cmd('silent! colorscheme falcon')
end)

svim.use {'aktersnurra/no-clown-fiesta.nvim'}
svim.use {'kvrohit/rasmus.nvim'}
