-- lsp.lua
--
-- lsp.lua is a minimial lsp configuration plugin to setup lsp quickly and more
-- naturally.

local get_clients = vim.lsp.get_active_clients
local M = {}


-- Options

if not vim.g.lsp_auto_start then
    vim.g.lsp_auto_start = true
end
M.auto_start = vim.g.lsp_auto_start


-- Register

M.registered = {}


--- Register a language-server
-- @param opt           The options that based on `vim.lsp.start_client()`, and
--                      it extended with the following fields:
--                      - `filetypes`: associating the language-server with
--                        given filetypes. When `vim.g.lsp_auto_start` is true,
--                        the language-server will start and create a client
--                        with `FileType` autocmd.
function M.register(opts)
    local name = opts.name
    if not opts.name then return end

    local filetypes = opts.filetypes
    local filetypes_type = type(filetypes)

    if not (filetypes_type == 'string' 
        or (filetypes_type == 'table' and vim.tbl_islist(filetypes))) then
        return
    end

    M.registered[name] = vim.deepcopy(opts)
end


--- Register or start a language-server
-- @param opt           The options that based on `vim.lsp.start_client()`, and
--                      it extended with the following fields:
--                      - `filetypes`: associating the language-server with
--                        given filetypes. When `vim.g.lsp_auto_start` is true,
--                        the language-server will start and create a client
--                        with `FileType` autocmd.
function M.start(opts)
    local name = opts.name
    if not opts.name then return end

    local start_opt = M.registered[name]
    if not start_opt then
        M.register(opts)
    end

    if M.auto_start or M.util.check_status(name) then
        vim.lsp.start(opts)
    end
end


--- Start a registered language-server by name
-- @param name          Registered language-server name
function M.start_by_name(name)
    if (M.registered[name] == nil) then
        return
    end
    vim.lsp.start(M.registered[name])
end


--- Stop a actived language-server client by its name
-- @param name          The name of server client
function M.stop_by_name(name)
    vim.lsp.stop_client(vim.tbl_filter(function(o)
        return o.name == name
    end, get_clients()))
end


--- Stop a actived language-server
-- @param filter        The filter to stop actived client, it could be the
--                      following contents:
--                      - `nil`: stop all actived clients
--                      - `string`: the name of clients
--                      - `number`: the id of clients
--                      - `list`: the id and name to stop
--
function M.stop(filter)
    local clients = get_clients()
    local filter_type = type(filter)

    if filter_type == 'nil' then
        vim.lsp.stop_client(clients)
    end

    if filter_type == 'number' then
        vim.lsp.stop_client(filter)
    end

    if filter_type == 'string' then
        M.stop_by_name(filter)
    end

    if filter_type == 'table' then
        for _, val in ipairs(filter) do
            local val_type = type(val)
            if val_type == 'number' then
                vim.lsp.stop_client(val)
            elseif val_type == 'string' then
                M.stop_by_name(val)
            end
        end
    end
end


-- Utils

M.util = {}

--- Get all registered names
function M.util.registered_names()
    return vim.tbl_keys(M.registered)
end

--- find root_dir by pass the marked files or folders
function M.util.root_pattern(items)
    if type(items) == 'string' then
        items = {items}
    end
    return vim.fs.dirname(vim.fs.find(items, {
        upward = true
    })[1])
end

--- Get all client names
function M.util.client_names()
    return vim.tbl_map(function(o)
        return o.name
    end, get_clients())
end

--- Check language-server with name is started
function M.util.check_status(name)
    return #(vim.tbl_filter(function(n)
        return n == name
    end, M.util.client_names())) ~= 0
end

return M

-- vim: expandtab shiftwidth=4 colorcolumn=80
