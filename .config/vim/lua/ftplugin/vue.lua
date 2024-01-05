local lsp = require('lsp')
local global_node_modules_path = nil

local function get_global_node_modules()
    if global_node_modules_path ~= nil then
        return global_node_modules_path
    end
    if vim.fn.executable('npm') ~= 1 then
        vim.notify(
            'npm is not installed, currently only support npm',
            vim.log.levels.ERROR
        )
        return ''
    end
    local path = vim.fn.systemlist('npm root -g')[1]
    if path == nil then
        vim.notify(
            'npm root -g return nil, please check your npm installation',
            vim.log.levels.ERROR
        )
        return ''
    end
    global_node_modules_path = path
    return path
end

local function get_local_node_modules(root_dir)
    if root_dir == nil then
        root_dir = vim.fn.getcwd()
    end
    local candidates = vim.fs.find('node_modules', {
        path = root_dir,
    })
    if #candidates == 0 then
        return ''
    end
    return candidates[1]
end

local function get_typescript_server_path(root_dir)
    local local_ts = vim.fs.normalize(
        get_local_node_modules(root_dir) .. '/typescript/lib'
    )
    if vim.fn.isdirectory(local_ts) == 1 then
        return local_ts
    end

    local global_ts = vim.fs.normalize(
        get_global_node_modules() .. '/typescript/lib'
    )
    if vim.fn.isdirectory(global_ts) == 1 then
        return global_ts
    end

    vim.notify(
        'typescript not found, please install typescript in global or local node_modules',
        vim.log.levels.ERROR
    )
    return ''
end

-- TODO The `init_options` may have some performance issue.
lsp.register({
    name = 'volar',
    cmd = { 'vue-language-server', '--stdio' },
    filetypes = { 'vue' },
    root_pattern = { 'package.json', 'vite.config.js', 'tsconfig.json', 'jsconfig.json' },
    init_options = {
        typescript = {
            tsdk = get_typescript_server_path(),
        }
    }
})
