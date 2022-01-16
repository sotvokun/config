local util = {}

function util.raw_echo(msg)
    vim.api.nvim_echo({{msg}}, true, {})
end

function util.raw_n_echo(msg)
    vim.api.nvim_echo({{msg}}, false, {})
end

function util.echo(mod, msg)
    util.raw_echo("["..mod.."] "..msg)
end

function util.n_echo(mod, msg)
    util.raw_n_echo("["..mod.."] "..msg)
end

function util.create_file(path, content)
    if vim.fn.has('win32') then
        path = path:gsub("/", "\\")
    end
    os.execute("echo "..content.." > "..path)
end

function util.remove_file(path)
    if vim.fn.has('win32') then
        path = path:gsub("/","\\")
        os.execute("del "..path)
    else
        os.execute("rm "..path)
    end
end

return util
