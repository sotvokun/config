if type(_G['svim/packages']) == 'nil' then
  _G['svim/packages'] = {}
end

local M = {}

M.package_manager = 'packer'

M.use = function(opt)
  _G['svim/packages'] = vim.list_extend(_G['svim/packages'], {opt})
end

M.apply = function()
  require('packer').startup(function (use)
    for _, item in ipairs(_G['svim/packages']) do
      use(item)
    end
  end)
end

return M
