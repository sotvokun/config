local exports = {}

-- Packages --------------------------------------------------------------------

local PKG_MANAGER = 'packer'

local exports = {}

local ensure_installed = function(url, alias)
  local pkgman_path = vim.fn.stdpath('data') .. '/site/pack/' .. PKG_MANAGER
  local pkg_name = alias or url:gsub('.*/', '')
  local pkg_path = string.format(pkgman_path .. '/start/%s', pkg_name)
  local pkg_doc_path = string.format('%s/doc', pkg_path)
  if vim.fn.empty(vim.fn.glob(pkg_path)) > 0 then
    vim.fn.system({'git', 'clone', '--depth', '1', url, pkg_path})
    vim.cmd(string.format('packadd %s', pkg_name))
    if vim.fn.isdirectory(pkg_doc_path) == 1 then
      vim.cmd(string.format('helptags %s', pkg_doc_path))
    end
    return { pkg_name }
  else
    return nil
  end
end

exports.ensure_installed = ensure_installed

-- Keymaps ---------------------------------------------------------------------

local set_keymap = function(lhs, rhs, opts)
  local mode = opts.mode or 'n'
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end

exports.set_keymap = set_keymap

-- Others ----------------------------------------------------------------------

local need_executable = function(name)
  return vim.fn.executable(name)
end

local need_has = function(name)
  return vim.fn.has(name)
end

exports.need_executable = need_executable
exports.need_has = need_has

return exports
