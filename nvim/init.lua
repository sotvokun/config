local utils = require('utils')

-- Options ---------------------------------------------------------------------

local opt = vim.opt

-- Misc
opt.showmode = false
opt.cursorline = true
opt.timeoutlen = 400
opt.signcolumn = 'yes'
opt.undofile = true
opt.updatetime = 1000
opt.mouse = 'a'
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.laststatus = 3

-- Indenting
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

-- Number
opt.number = true
opt.numberwidth = 2

-- Colorscheme
opt.termguicolors = true
vim.cmd 'silent! colorscheme carbonfox'

-- Neovim
if vim.g.neovide ~= nil then
  vim.opt.guifont = 'Iosevka Pragmatus:h12'
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursoor_trail_length = 0
end

-- Clipboard
vim.opt.clipboard = 'unnamedplus'
if utils.need_has('win32') or utils.need_has('wsl') then
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf'
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf'
    },
    cache_enabled = 0
  }
end

-- Fold
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldnestmax = 2

-- filetype.lua
-- TODO: remove this part when it be enabled by default.
do
  local version = vim.version()
  if version.major < 1 and version.minor < 8 then
    vim.g.did_load_filetypes = 0
    vim.g.do_filetype_lua = 1
  end
end

-- Keymaps for basic -----------------------------------------------------------

local set_keymap = utils.set_keymap

vim.cmd('nnoremap <space> <nop>')
vim.g.mapleader = ' '

-- Window movement----------------------
set_keymap('<c-h>', '<c-w>h', { desc = 'Go to left window' })
set_keymap('<c-j>', '<c-w>j', { desc = 'Go to down window' })
set_keymap('<c-k>', '<c-w>k', { desc = 'Go to up window' })
set_keymap('<c-l>', '<c-w>l', { desc = 'Go to right window' })

set_keymap('<a-h>', '<c-\\><c-n><c-w>h', { mode = 'i' })
set_keymap('<a-j>', '<c-\\><c-n><c-w>j', { mode = 'i' })
set_keymap('<a-k>', '<c-\\><c-n><c-w>k', { mode = 'i' })
set_keymap('<a-l>', '<c-\\><c-n><c-w>l', { mode = 'i' })

set_keymap('<c-h>', '<c-\\><c-n><c-w>h', { mode = 't' })
set_keymap('<c-j>', '<c-\\><c-n><c-w>j', { mode = 't' })
set_keymap('<c-k>', '<c-\\><c-n><c-w>k', { mode = 't' })
set_keymap('<c-l>', '<c-\\><c-n><c-w>l', { mode = 't' })

-- Editing -----------------------------
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

-- Some emacs keybinding for insert mode
set_keymap('<a-a>', '<c-\\><c-n>^i', { mode = 'i' })
set_keymap('<c-a>', '<c-\\><c-n>0i', { mode = 'i' })
set_keymap('<c-e>', '<c-\\><c-n>$a', { mode = 'i' })
set_keymap('<c-k>', '<c-\\><c-n>Da', { mode = 'i' })

-- Enhancing with plugins ------------------------------------------------------

if not (utils.need_executable('git') and utils.need_has('nvim-0.7.2')) then
  return
end

require('core')
