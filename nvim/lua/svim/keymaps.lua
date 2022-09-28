local set_keymap = function(lhs, rhs, opts)
  local mode = 'n'
  if opts and opts.mode then
    mode = opts.mode
    opts.mode = nil
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Leader Key --------------------------------------------------------
vim.cmd('nnoremap <space> <nop>')
vim.g.mapleader = ' '

-- Window movement ---------------------------------------------------
set_keymap('<c-h>', '<c-w>h', { desc = 'Go to the left window' })
set_keymap('<c-j>', '<c-w>j', { desc = 'Go to the down window' })
set_keymap('<c-k>', '<c-w>k', { desc = 'Go to the up window' })
set_keymap('<c-l>', '<c-w>l', { desc = 'Go to the right window' })

set_keymap('<a-h>', '<c-\\><c-n><c-w>h', { mode = { 'i', 't' } })
set_keymap('<a-j>', '<c-\\><c-n><c-w>j', { mode = { 'i', 't' } })
set_keymap('<a-k>', '<c-\\><c-n><c-w>k', { mode = { 'i', 't' } })
set_keymap('<a-l>', '<c-\\><c-n><c-w>l', { mode = { 'i', 't' } })

-- Editing -----------------------------------------------------------
-- Better indenting
set_keymap('<', '<gv', { mode = 'v' })
set_keymap('>', '>gv', { mode = 'v' })

-- Move selected line and block
set_keymap('<a-j>', ":m '>+1<cr>gv-gv", {
  mode = 'x',
  desc = 'Move selection down'
})

set_keymap('<a-k>', ":m '<-2<cr>gv-gv", {
  mode = 'x',
  desc = 'Move selection up'
})

-- Movement in insert mode
set_keymap('<c-a>', '<c-\\><c-n>0i', { mode = 'i' })
set_keymap('<a-a>', '<c-\\><c-n>^i', { mode = 'i' })
set_keymap('<c-e>', '<c-\\><c-n>$a', { mode = 'i' })
set_keymap('<c-n>', '<down>', { mode = 'i', noremap = true})
set_keymap('<c-p>', '<up>', { mode = 'i', noremap = true})
set_keymap('<c-f>', '<right>', { mode = 'i'})
set_keymap('<c-b>', '<left>', { mode = 'i'})

-- Buffers -----------------------------------------------------------
set_keymap('<leader>ee', '<cmd>enew<cr>', { desc = 'New buffer' })
set_keymap('d!', '<cmd>%bdelete<cr>', { desc = 'Delete all buffers' })
set_keymap('dq', '<cmd>Bdelete<cr>', { desc = 'Delete buffer (hold window)' })
set_keymap('dQ', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })

-- Tabs --------------------------------------------------------------
set_keymap('<leader>et', '<cmd>tabnew<cr>', { desc = 'New tab' })
set_keymap('[t', '<cmd>tabprevious<cr>', { desc = 'Previous tab' })
set_keymap(']t', '<cmd>tabnext<cr>', { desc = 'Next tab' })
set_keymap('d<c-t>', '<cmd>tabclose<cr>', { desc = 'Close tab' })

-- LSP ---------------------------------------------------------------
set_keymap('gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { desc = 'Go to definition [LSP]' })
set_keymap('gr', '<cmd>lua vim.lsp.buf.references()<cr>', { desc = 'Go to references [LSP]' })
set_keymap('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { desc = 'Go to declaration [LSP]' })
set_keymap('gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { desc = 'Go to implementation [LSP]' })
set_keymap('K', '<cmd>lua vim.lsp.buf.hover()<cr>', { desc = 'Hover [LSP]' })
set_keymap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', { desc = 'Code Action [LSP]' })
set_keymap('<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<cr>', { desc = 'Formatting [LSP]' })
set_keymap('<leader>cd', '<cmd>TroubleToggle<cr>', { desc = 'Diagnostic' })
set_keymap('<leader>cs', '<cmd>AerialToggle<cr>', { desc = 'Symbols' })
set_keymap('<leader>cr', '<cmd>lua vim.lsp.buf.rename()<cr>', { desc = 'Rename [LSP]' })

-- Toggle Term -------------------------------------------------------
set_keymap('<c-\\>', '<cmd>ToggleTerm<cr>', { desc = 'Toggle terminal' })
set_keymap('<c-\\>', '<c-\\><c-n><cmd>ToggleTerm<cr>', { mode = 't' })
set_keymap('<esc>', '<c-\\><c-n>', { mode = 't' })

-- <c-x> -------------------------------------------------------------
set_keymap('<c-x>b', '<cmd>Telescope buffers<cr>', { desc = 'List buffers' })
set_keymap('<c-x>g', '<cmd>Telescope live_grep<cr>', { desc = 'Live Grep' })
set_keymap('<c-x>f', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })

-- Macros ------------------------------------------------------------
set_keymap('Q', '@q', { desc = 'Replay macro q' })

-- Quick Setup -------------------------------------------------------
set_keymap('<leader>qq', '<cmd>nohl<cr>', { desc = 'Disable search highlight' })
set_keymap('<leader>qr', '<cmd>set relativenumber!<cr>', { desc = 'Toggle relative number' })
set_keymap('<leader>qw', '<cmd>set wrap!<cr>', { desc = 'Text wrap' })

-- Misc --------------------------------------------------------------
set_keymap('<space><space>', ':', { desc = 'Command' })
set_keymap('<a-x>', '<cmd>Telescope<cr>', { desc = 'Telescope' })
set_keymap('<c-n>', '<cmd>NeoTreeFocusToggle<cr>', { desc = 'Toggle NeoTree' })
set_keymap('<F10>', '<cmd>UndotreeToggle<cr>', { desc = 'Toggle Undotree' })
