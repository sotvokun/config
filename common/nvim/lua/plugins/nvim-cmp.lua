local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    mapping = {
        ['<M-k>'] = cmp.mapping.select_prev_item(),
        ['<M-j>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<Tab>'] = function (fallback)
            if cmp.visible() then
                cmp.confirm{select=true}
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function (fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }
    },
    {
        { name = "buffer" }
    })
})
