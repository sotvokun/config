local opt = vim.o

-- Faces
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = 'yes'
opt.number = true

-- Editing
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

-- Misc
opt.undofile = true
opt.cursorline = true
opt.timeoutlen = 400
opt.updatetime = 750
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'

-- Enable filetype.lua
-- TODO: remove this part when it be enabled by default
do
  local ver = vim.version()
  if ver.major <= 0 and ver.minor < 8 then
    vim.g.did_load_filetypes = 0
    vim.g.do_filetype_lua = 1
  end
end

-- Windows
if vim.fn.has('win32') == 1 or vim.fn.has('wsl') == 1 then
  require('svim.options.win32')
end

-- GUI for neovide
if vim.g.neovide ~= nil then
  require('svim.options.neovide')
end
