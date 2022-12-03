pcall(require, 'impatient')

-- Inject necessaries
-- ----------------------------

if (_G.svim == nil) then
    local M = {}
    M.plugins = {}
    M.use = function (plugin)
        table.insert(_G.svim.plugins, plugin)
    end
    M.require = function(plugin, callback)
        if type(plugin) == 'function' then plugin() return end
        local ok, required = pcall(require, plugin)
        if ok then
            if callback then callback(required)
            elseif required.setup then required.setup()
            else end
        else
            vim.notify(required, vim.log.levels.ERROR)
        end
    end

    M.default_keymap_opts = {
        replace_keycodes = false,
        noremap = true,
        silent = true
    }
    M.map = function(mode, lhs, rhs, opts)
        local opts = vim.tbl_extend('force', _G.svim.default_keymap_opts, opts or {})
        vim.keymap.set( mode, lhs, rhs, opts)
    end
    _G.svim = M
end


-- Setup plugins
-- ----------------------------

for _, bundle in ipairs(vim.g.svim_bundles) do
    local ok, message = pcall(require, "svim.bundles." .. bundle)
    if not ok then
        vim.notify(message, vim.log.levels.ERROR)
    end
end

require('paq')(_G.svim.plugins)
