-- moonwalk.lua
-- Setup ------------------------------------------------------------------------------------------

local ok, moonwalk = pcall(require, "moonwalk")
if not ok then
    return
end

moonwalk.on("pre-compile", function(src)
    return "(require-macros :macros)\n" .. src
end)

moonwalk.on("ignore-path", function()
    return {
        "fnl/macros.fnl"
    }
end)

local CONFIG_HOME = vim.fn.stdpath("config")
local CONFIG_ALIAS = {
    CONFIG_HOME,
    vim.fn.expand("~/.config/nvim")
}


-- Autocmd ----------------------------------------------------------------------------------------

vim.api.nvim_create_augroup("moonwalk", { clear = true })

-- compile fennel files in config path 
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "moonwalk",
    pattern = vim.tbl_map(function(p)
        return vim.fs.normalize(p .. "/*.fnl")
    end, CONFIG_ALIAS),
    callback = function(args)
        local path = args.match
        for _, cfgpath in ipairs(vim.tbl_map(vim.fs.normalize, CONFIG_ALIAS)) do
            if vim.startswith(path, cfgpath) then
                path = string.gsub(path, cfgpath, vim.fs.normalize(CONFIG_HOME))
                break
            end
        end
        moonwalk.compile(path)
    end,
})

vim.api.nvim_create_autocmd("SourceCmd", {
    group = "moonwalk",
    pattern = "*.fnl",
    callback = function(args)
        local src_path = vim.fs.normalize(args.file)
        if vim.fn.has('win32') then
            src_path = src_path:gsub(":", "")
        end
        local out = (vim.fn.stdpath("cache") .. "/moonwalk/" .. src_path):gsub("%.fnl$", ".fnl.lua")
        vim.fn.mkdir(vim.fs.dirname(out), "p")

        vim.api.nvim_command("source " .. moonwalk.compile(args.file, out))
    end,
})
