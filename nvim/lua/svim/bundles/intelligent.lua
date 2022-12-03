-- =========================================================
--
-- intelligent.lua
--
-- =========================================================

svim.use {'liuchengxu/vista.vim'}
svim.require(function()
    vim.g['vista#renderer#enable_icon'] = 0
    if vim.g.svim_lsp then
        vim.g['vista_default_executive'] = 'nvim_lsp'
    elseif vim.g.svim_coc then
        vim.g['vista_default_executive'] = 'coc'
    end
    svim.map('n', '<leader>cs', ':Vista!!<cr>')
end)

svim.use {'kevinhwang91/promise-async'}
svim.use {'kevinhwang91/nvim-ufo'}
svim.require('ufo', function(ufo)
    ufo.setup()
end)
