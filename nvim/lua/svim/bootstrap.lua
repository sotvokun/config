local puterr = vim.api.nvim_err_writeln

local pkgman = require('svim.modules.package').package_manager
local pkgpath = vim.fn.stdpath('data') .. '/site/pack/' .. pkgman

-- Check requirements for bootstrap
local ver = vim.version()
local has_git = vim.fn.executable('git') == 1
if ver.major <= 0 and ver.minor < 7 and not has_git then
  puterr('minimum bootstrap requirements: neovim >= 0.7.0, git')
  return
end

-- `ensure' function to install necessary packages
local function ensure_install(user, repo)
  local fmt = string.format
  local path = fmt(pkgpath .. '/start/%s', repo)
  local doc_path = fmt('%s/doc', path)
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    vim.fn.system({'git', 'clone', '--depth', '1', fmt('https://github.com/%s/%s', user, repo), path})
    vim.cmd(fmt('packadd %s', repo))
    if vim.fn.isdirectory(doc_path) == 1 then
      vim.cmd(fmt('helptags %s', doc_path))
    end
  end
end

ensure_install("wbthomason", "packer.nvim")
ensure_install("lewis6991", "impatient.nvim")

_G['svim/bootstrap'] = true
