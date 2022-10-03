local use = require('svim.modules.package').use

-- Packages ----------------------------------------------------------
-- Completeion
use {'hrsh7th/nvim-cmp'}
use {'hrsh7th/cmp-buffer'}
use {'hrsh7th/cmp-path'}

-- Apply -------------------------------------------------------------
do
  local ok, cmp = pcall(require, 'cmp')
  if not ok then return end

  vim.o.completeopt = 'menu,menuone,noselect'

  local luasnip_ok, luasnip = pcall(require, 'luasnip')

  -- Snippet
  local snippet = {}

  if luasnip_ok then
    snippet.expand = function (args)
      luasnip.lsp_expand(args.body)
    end
  end

  -- Sources
  local sources = {
    {name = 'luasnip'},
    {name = 'buffer', keyword_length = 7, dup = 0},
    {name = 'path'}
  }
  if pcall(require, 'cmp_nvim_lsp') then
    table.insert(sources, 1, {name = 'nvim_lsp'})
  end

  -- Keymap
  local keymap = {
    ['<up>'] = cmp.mapping.select_prev_item(),
    ['<down>'] = cmp.mapping.select_next_item(),
    ['<c-p>'] = cmp.mapping.select_prev_item(),
    ['<c-n>'] = cmp.mapping.select_next_item(),
    ['<c-c>'] = cmp.mapping.abort(),
    ['<tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local entry = cmp.get_selected_entry()
        if not entry then
          cmp.select_next_item({
            behavior = cmp.SelectBehavior.Select
          })
        else
          cmp.confirm()
        end
      elseif luasnip_ok and luasnip.expand_or_jumpable() then
        luasnip.expand_or_locally_jumpable()
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<s-tab>'] = cmp.mapping(function()
      if luasnip_ok and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, {'i', 's'})
  }

  -- Formatting
  local formatting = {
    format = function(entry, item)
      local trimmed_word = string.gsub(entry.source.name, 'nvim_', '')
      item.menu = string.format('[%s]', trimmed_word)
      return item
    end
  }

  cmp.setup({
    formatting = formatting,
    snippet = snippet,
    mapping = cmp.mapping.preset.insert(keymap),
    sources = cmp.config.sources(sources)
  })
end
