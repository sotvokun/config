-- =========================================================
--
-- coc.lua
--
-- =========================================================

svim.use {'neoclide/coc.nvim', branch = 'release'}
svim.use {'fannheyward/telescope-coc.nvim'}
svim.require('telescope', function(t)
    t.load_extension('coc')
end)

vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 300
vim.o.signcolumn = 'yes'

-- * Coc Setup
vim.g.coc_start_at_startup = 0
vim.notify('use :CocStart to start coc service')

-- * Auto complete
function _G.coc_check_backspace()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local mapopts = { expr = true }
local fn = vim.fn

svim.map('i', '<tab>',
  'coc#pum#visible() ? coc#pum#confirm() : "<tab>"',
  mapopts)
svim.map('i', '<c-n>', 'coc#pum#visible() ? coc#pum#next(1) : "<down>"', mapopts)
svim.map('i', '<c-p>', 'coc#pum#visible() ? coc#pum#prev(1) : "<up>"', mapopts)
svim.map('i', '<c-.>', 'coc#refresh()', {silent = true, expr = true})

-- * LSP features
svim.map('n', 'gd', ':Telescope coc definitions<cr>')
svim.map('n', 'gy', ':Telescope coc type_definitions<cr>')
svim.map('n', 'gD', ':Telescope coc declarations<cr>')
svim.map('n', 'gi', ':Telescope coc implementations<cr>')
svim.map('n', 'gr', ':Telescope coc references<cr>')

function _G.coc_show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
svim.map('n', 'K', ':lua _G.coc_show_docs()<cr>')

local nowait_opts = {nowait = true}
-- ** Coc special action
svim.map('n', '<leader>cf', '<Plug>(coc-fix-current)', nowait_opts)
svim.map('n', '<leader>cl', '<Plug>(coc-codelens-action)', nowait_opts)
svim.map('n', '<leader>cc', ':Telescope coc commands<cr>', nowait_opts)
-- ** LSP compatible action
svim.map('n', '<leader>cr', '<Plug>(coc-rename)', nowait_opts)
svim.map('n', '<leader>ca', '<Plug>(coc-codeaction)', nowait_opts)
svim.map('n', '<leader>cd', ':Telescope coc diagnostics<cr>', nowait_opts)
svim.map('n', '<leader>cD', ':Telescope coc workspace_diagnostics<cr>', nowait_opts)

-- Autocmd
vim.cmd('autocmd User CocStatusChange redrawstatus')

vim.g.svim_coc = true
