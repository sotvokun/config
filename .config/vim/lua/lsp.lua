-- lsp.lua
--
-- lsp.lua is a minimial lsp configuration plugin to setup lsp quickly and more
-- naturally.

local get_clients = vim.lsp.get_active_clients
local M = {}

-- Functions

M.registered = {}

--- Register a language server
-- @param opts:     options for setup language-server client, the options
--                  should be santizible by `lsp.util.santize_option()`.
--
function M.register(opts)
    local name = opts.name
    if not name then
        error('name is required')
    end
    if M.registered[name] then
        return
    end
    M.registered[name] = M.util.santize_option(opts)
end

--- Start a registered language server by name
-- @param name:     the name of registered language server
--
function M.start_by_name(name)
    local opts = M.registered[name]
    if not opts then
        error('name is not registered')
    end
    return vim.lsp.start(vim.deepcopy(opts))
end

--- Stop a registered language server by name
-- @param name:     the name of registered language server
--
function M.stop_by_name(name)
    local opts = M.registered[name]
    if not opts then
        error('name is not registered')
    end
    local clients = get_clients()
    for _, client in ipairs(clients) do
        if client.name == name then
            client.stop()
        end
    end
end

--- Stop all language server clients
function M.stop_all()
    vim.lsp.stop_client(get_clients(), true)
end

--- Restart a registered language server by name
-- @param name:     the name of registered language server
--
function M.restart_by_name(name)
    local opts = M.registered[name]
    if not opts then
        error('name is not registered')
    end
    local clients = get_clients()
    for _, client in ipairs(clients) do
        if client.name == name then
            local buffers = vim.tbl_keys(client.attached_buffers)
            client.stop()
            vim.defer_fn(function()
                local client_id = M.start_by_name(name)
                for _, bufnr in ipairs(buffers) do
                    vim.lsp.buf_attach_client(bufnr, client_id)
                end
            end, 500)
        end
    end
end


-- Util

M.util = {}

--- Sanitize options for language-server client
-- @param opt:      options for setup language-server client, the most fields
--                  are same as `vim.lsp.start_client`, but there has some new
--                  fields:
--                  - root_pattern: the pattern files or folders to find the
--                    root directory of project.
function M.util.santize_option(opt)
    opt = vim.deepcopy(opt)
    if opt.root_pattern then
        opt.root_dir = M.util.root_pattern(opt.root_pattern)
    end
    if type(opt.filetypes) == 'string' then
        opt.filetypes = {opt.filetypes}
    end
    if type(opt.capabilities) == 'table' then
        opt.capabilities = vim.tbl_deep_extend(
            'keep', opt.capabilities, M.util.setup_capabilities()
        )
    else
        opt.capabilities = M.util.setup_capabilities()
    end
    if type(opt.cmd) == 'table' and vim.fn.has('win32') == 1 then
        local exe = opt.cmd[1]
        if vim.fn.executable(exe .. '.exe') == 1 then
            opt.cmd[1] = exe .. '.exe'
        elseif vim.fn.executable(exe .. '.cmd') == 1 then
            opt.cmd[1] = exe .. '.cmd'
        else
            opt.cmd[1] = exe
        end
    end
    return opt
end

--- Get all registered names
function M.util.registered_names()
    return vim.tbl_keys(M.registered)
end

--- Get all started names
function M.util.started_names()
    return vim.tbl_filter(function(name)
        return vim.tbl_contains(M.util.client_names(), name)
    end, M.util.registered_names())
end

--- find root_dir by pass the marked files or folders
function M.util.root_pattern(items)
    local items_type = type(items)
    if items_type ~= 'string' and not vim.tbl_islist(items) then
        error('items must be string or list')
    end
    if items_type == 'string' then
        items = {items}
    end
    return vim.fs.dirname(vim.fs.find(items, {
        upward = true
    })[1])
end

--- Get all client names
function M.util.client_names(bufnr)
    local output = bufnr and get_clients({bufnr = bufnr}) or get_clients()
    return vim.tbl_map(function(o)
        return o.name
    end, output)
end

--- Check language-server with name is started
function M.util.check_status(name)
    return #(vim.tbl_filter(function(n)
        return n == name
    end, M.util.client_names())) ~= 0
end

--- Get registered language-server client options by filetype
function M.util.get_registered_by_filetype(filetype)
    local clients = {}
    for _, opt in pairs(M.registered) do
        if vim.tbl_contains(opt.filetypes, filetype) then
            table.insert(clients, opt)
        end
    end
    return clients
end

-- Setup capabilities
function M.util.setup_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if cmp_nvim_lsp_ok then
        capabilities = vim.tbl_deep_extend(
            'keep', capabilities, cmp_nvim_lsp.default_capabilities()
        )
    end
    return capabilities
end

-- Convert language server registry to coc.nvim style
function M.util.coc_serialize(name)
    local opt = M.registered[name]
    if not opt then
        error('name is not registered')
    end
    local command = ''
    local args = {}
    if opt.cmd and vim.tbl_islist(opt.cmd) then
        command = opt.cmd[1]
        args = vim.list_slice(opt.cmd, 2)
    elseif opt.cmd and type(opt.cmd) == 'string' then
        command = opt.cmd
    end
    return {
        command = command,
        args = args,
        filetypes = opt.filetypes,
        initializationOptions = opt.init_options and opt.init_options or {},
        rootPatterns = opt.root_pattern and opt.root_pattern or {},
        settings = opt.settings and opt.settings or {},
        cwd = opt.root_dir and opt.root_dir or vim.fn.getcwd()
    }
end

return M

-- vim: expandtab shiftwidth=4 colorcolumn=80
