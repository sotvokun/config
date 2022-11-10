local use = require('svim.modules.package').use

-- Packages ----------------------------------------------------------
use {'jose-elias-alvarez/null-ls.nvim'}
use {'jayp0521/mason-null-ls.nvim'}

-- Exports -----------------------------------------------------------
local M = {}

M.options = {

}

M.apply = function (proc)
  local ok, null_ls = pcall(require, 'null-ls')
  if not ok then return end

  if not pcall(require, 'mason-null-ls') then
    return
  end

  local handlers = {
    function(source_name, methods)
      require('mason-null-ls.automatic_setup')(source_name, methods)
    end
  }

  ----------
  -- Mason-null-ls
  -- use {'mason-package-name', {'type' = {}, 'type' = {}}}
  --
  -- external
  -- use ({}, false)
  local function use(opts, mason)
    mason = mason or true
    if mason then
      if opts[1] == nil or opts[2] == nil then
        return
      end
      local pkg2source = require('mason-null-ls.mappings.source').package_to_null_ls
      local sourcename = pkg2source[opts[1]]
      local type_opts = opts[2]
      if sourcename == nil then return end
      local source_list = {}
      for _, value in ipairs(vim.tbl_keys(type_opts)) do
        local category = ''
        if type(value) == 'number' then
          category = type_opts[value]
          table.insert(source_list, null_ls.builtins[category][sourcename].with(M.options))
        else
          category = value
          local source_opts = vim.tbl_extend('force', M.options, type_opts[value])
          table.insert(source_list, null_ls.builtins[category][sourcename].with(source_opts))
        end
      end
      handlers[sourcename] = function(_, _)
        for _, source in ipairs(source_list) do
          null_ls.register(source)
        end
      end
    else
      null_ls.register(opts)
    end
  end

  proc(use)

  require('mason-null-ls').setup()
  require('mason-null-ls').setup_handlers(handlers)
  require('null-ls').setup()
end

return M
