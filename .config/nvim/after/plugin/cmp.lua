-- cmp.lua
--
-- - nvim-cmp
-- - cmp-path
-- - cmp-buffer
-- - cmp-vsnip
-- - copilot.vim

if vim.g.vscode then return end

local ok, cmp = pcall(require, 'cmp')
if not ok then return end

local copilot_ready =
    vim.fn.exists(':Copilot') ~= 0 and vim.fn['copilot#Enabled']()

-- Configurations

--- Snippets
function setup_snippets()
    return {
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end
    }
end

--- Sources
function setup_sources()
    local source_list = {
        { name = 'vsnip' },
        { name = 'buffer' },
        { name = 'path' },
    }

    if pcall(require, 'cmp_nvim_lsp') then
        table.insert(source_list, { name = 'nvim_lsp' })
    end

    return cmp.config.sources(source_list)
end

--- Mappings
function setup_mappings()
    local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes(key, true, true, true),
            mode,
            true
        )
    end

    local tab_fn = function(fallback)
        if cmp.visible() then
            local entry = cmp.get_selected_entry()
            if not entry then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                cmp.confirm()
            end
        elseif vim.fn['vsnip#available'](1) == 1 then
            feedkey('<Plug>(vsnip-expand-or-jump)', '')
        elseif copilot_ready then
            vim.api.nvim_feedkeys(
                vim.fn['copilot#Accept'](
                    vim.api.nvim_replace_termcodes('<Tab>', true, true, true)
                ),
                'n',
                true
            )
        else
            fallback()
        end
    end

    local shift_tab_fn = function(fallback)
        if vim.fn['vsnip#jumpable'](-1) == 1 then
            feedkey('<Plug>(vsnip-jump-prev)', '')
        else
            fallback()
        end
    end

    local i_cr_fn = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false
            })
        else
            fallback()
        end
    end

    local i_c_e_fn = function(fallback)
        local copilot_suggestion = vim.fn['copilot#GetDisplayedSuggestion']()
        if cmp.visible() then
            cmp.abort()
        elseif string.len(copilot_suggestion.uuid) ~= 0 then
            feedkey('<Plug>(copilot-dismiss)', '')
        else
            fallback()
        end
    end

    return {
        ['<tab>'] = cmp.mapping(tab_fn, {'i', 's'}),
        ['<s-tab>'] = cmp.mapping(shift_tab_fn, {'i', 's'}),
        ['<cr>'] = cmp.mapping({
            i = i_cr_fn,
            s = cmp.mapping.confirm({ select = true })
        }),
        ['<c-e>'] = cmp.mapping(i_c_e_fn, {'i', 's'}),
        ['<c-n>'] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select
        }),
        ['<c-p>'] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select
        }),
    }
end


-- Setup

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    snippet = setup_snippets(),
    sources = setup_sources(),
    mapping = setup_mappings()
})

-- vim: expandtab shiftwidth=4 colorcolumn=80
