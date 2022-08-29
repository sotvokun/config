return function()
  local api = vim.api
  local cmp = require('cmp')

  local has_words_before = function()
    local line, col = unpack(api.nvim_win_get_cursor(0))
    return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  local feedkey = function(key, mode)
    api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end

  -- Sources -----------------------------

  local src1 = {
    { name = 'vsnip' },
  }
  local src2 = {
    { name = 'path' },
    { name = 'buffer', dup = 0 }
  }

  -- Import `cmp_nvim_lsp' when it is available
  do
    local ok, _ = pcall(require, 'cmp_nvim_lsp')
    if ok then
      table.insert(src1, {name='nvim_lsp'})
    end
  end

  local sources = cmp.config.sources(src1, src2)

  -- Options -----------------------------

  local snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end
  }
  local formatting = {
    format = function (entry, item)
      item['menu'] = string.format('[%s]', string.gsub(entry.source.name, 'nvim_', ''))
      return item
    end
  }

  -- Key settings ------------------------

  local mapping = {
    ['<up>'] = cmp.mapping.select_prev_item(),
    ['<down>'] = cmp.mapping.select_next_item(),
    ['<c-p>'] = cmp.mapping.select_prev_item(),
    ['<c-n>'] = cmp.mapping.select_next_item(),
    ['<c-e>'] = cmp.mapping.close(),
    ['<cr>'] = cmp.mapping.confirm(),
    ['<tab>'] = cmp.mapping(function(fallback)
      local is_visible = cmp.visible()
      local selected = cmp.get_selected_entry()
      if is_visible then
        if not selected then
          cmp.select_next_item()
        else
          cmp.confirm()
        end
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<s-tab>'] = cmp.mapping(function(fallback)
      local is_visible = cmp.visible()
      if (is_visible) then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      else
      end
    end, {'i', 's'})
  }

  -- Setup -------------------------------

  cmp.setup({
    snippet = snippet,
    formatting = formatting,
    sources = sources,
    mapping = mapping
  })
end
