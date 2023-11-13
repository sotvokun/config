local lsp = require('lsp')

lsp.start({
    name = 'intelephense',
    filetypes = 'php',
    cmd = { 'intelephense', '--stdio' },
    root_dir = lsp.util.root_pattern({'composer.json'})
})

-- vim: et sw=4 cc=80
