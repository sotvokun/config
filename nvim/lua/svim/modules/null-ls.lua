local use = require('svim.modules.package').use

-- Packages ----------------------------------------------------------
use {'jose-elias-alvarez/null-ls.nvim'}

-- Exports -----------------------------------------------------------
local M = {}

M.options = {

}

M.apply = function (proc)
  local ok, null_ls = pcall(require, 'null-ls')
  if not ok then return end
  local sources = {}

  local function use(opts, builtin)
    builtin = builtin or true
    if builtin then
      local category = opts[1]
      local source = opts[2]
      if category == nil or source == nil then
        return
      end
      if opts['setup'] then
        table.insert(sources, null_ls.builtins[category][source].with(
          vim.tbl_extend('force', M.options, opts['setup'])))
      else
        table.insert(sources, null_ls.builtins[category][source])
      end
    else
      null_ls.register(opts)
    end
  end

  proc(use)

  null_ls.setup({
    sources = sources
  })
end

return M
