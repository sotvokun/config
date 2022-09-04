local set_keymap = require("utils").set_keymap

-- Utils -----------------------------------------------------------------------

local function set_label(lhs, name)
  require('which-key').register({
    [lhs] = { name = name }
  })
end

local function setup(list)
  for _, val in ipairs(list) do
    local lhs = val[1]
    local rhs = val[2]
    val[1] = nil
    val[2] = nil
    set_keymap(lhs, rhs, val)
  end
end

-- Settings --------------------------------------------------------------------

local keymaps = {

  -- Buffers -----------------------------
  {'<leader>eb', '<cmd>ene<cr>', desc = 'Buffer'},
  {'dq', '<cmd>Bdelete<cr>', desc = 'Buffer'},
  {'dQ', '<cmd>bd<cr>', desc = 'Buffer and layout'},

  -- Telescope ---------------------------
  {'<a-x>', '<cmd>Telescope commands<cr>', desc = 'Call commands'},

  -- Nvim-Tree ---------------------------
  {'<c-n>', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle nvim-tree'},

  -- Tabpage -----------------------------
  {'[t', ':tabp<cr>', desc = 'Go to previous tabpage'},
  {']t', ':tabn<cr>', desc = 'Go to next tabpage'},
  {'<leader>et', ':tabnew<cr>', desc = 'Tabpage'},

  -- UFO ---------------------------------
  {'zR', require('ufo').openAllFolds, desc = 'Open all folds'},
  {'zM', require('ufo').closeAllFolds, desc = 'Close all folds'},

  -- LSP ---------------------------------
  {
    'gd', '<cmd>lua vim.lsp.buf.definition()<cr>',
    desc = 'Go to definition [LSP]'
  },
  {
    'gr', '<cmd>lua vim.lsp.buf.references()<cr>',
    desc = 'Go to references [LSP]'
  },
  {
    'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>',
    desc = 'Go to declaration [LSP]'
  },
  {
    'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>',
    desc = 'Go to implementation [LSP]'
  },
  {
    'K', '<cmd>lua vim.lsp.buf.hover()<cr>',
    desc = 'Hover [LSP]'
  },
  {
    '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>',
    desc = 'Code Action'
  },
  { '<leader>cd', '<cmd>:TroubleToggle<cr>', desc = 'Open diagnostic window' },
  {
    '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<cr>',
    desc = 'Formatting'
  },
  { '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<cr>', desc = 'Rename' },
  { '<leader>cs', '<cmd>AerialToggle<cr>', desc = 'List all symbols with tree' },
}

-- Setup -----------------------------------------------------------------------

setup(keymaps)
