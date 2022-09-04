local Hydra = require('hydra')

-- Utils -----------------------------------------------------------------------

local function set_label(lhs, name)
  require('which-key').register({
    [lhs] = { name = name }
  })
end

-- Telescope -------------------------------------------------------------------

set_label('<c-p>', 'Telescope')
Hydra({
  name = 'Telescope',
  mode = 'n',
  body = '<c-p>',
  heads = {
    { 'b', '<cmd>Telescope buffers<cr>', { desc = 'Buffers'} },
    { 'f', '<cmd>Telescope find_files<cr>', { desc = 'Find files'} },
    { 'h', '<cmd>Telescope help_tags<cr>', { desc = 'Help tags'} },
    { 'o', '<cmd>Telescope oldfiles<cr>', { desc = 'History files'} },
    { 'k', '<cmd>Telescope keymaps<cr>', { desc = 'Keymaps'} },
    {
      's', '<cmd>Telescope lsp_document_symbols<cr>',
      { desc = 'Document symbols' }
    },
    {
      'S', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>',
      { desc = 'Workspace symbols (dynamic)' }
    },
    { 'g', '<cmd>Telescope grep_string<cr>', { desc = 'Grep string' } },
    { 'G', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' } },
    { 't', '<cmd>Telescope buffers<cr>', { desc = 'Todo comments'} },
    { '<c-p>', '<cmd>Telescope project<cr>', { desc = 'Projects' } },
  }
})

-- Buffers and Windows ---------------------------------------------------------

local function reach_buffers()
  require('reach').buffers({
    handle = 'dynamic',
    show_icons = false,
    modified_icon = '[+]',
    previous = { depth = 1 }
  })
end

set_label('<c-x>', 'Buffers and Windows')
Hydra({
  name = 'Buffers and Windows',
  mode = 'n',
  body= '<c-x>',
  heads = {
    { '0', '<c-w>q', { desc = 'Quit current window' } },
    { '1', '<c-w>o', { desc = 'Quit other windows' } },
    { 'b', reach_buffers, { desc = 'Buffer list' } }
  }
})

-- Quick settings --------------------------------------------------------------

set_label('<c-q>', 'Quick Settings')
Hydra({
  name = 'Quick Settings',
  mode = 'n',
  body = '<c-q>',
  heads = {
    { 'r', '<cmd>set rnu!<cr>', { desc = 'Relative number' } },
    { 'w', '<cmd>set wrap!<cr>', { desc = 'Text wrap' } },
    { '<c-q>', '<cmd>nohls<cr>', { desc = 'Disable search highlighting' } },
  }
})
