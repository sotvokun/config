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

-- Fold
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Windows
if vim.fn.has('win32') == 1 or vim.fn.has('wsl') == 1 then
  require('svim.options.win32')
end

-- GUI for neovide
if vim.g.neovide ~= nil then
  require('svim.options.neovide')
end
