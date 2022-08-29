local exports = {}

-- Settings --------------------------------------------------------------------

vim.diagnostic.config({
  virtual_text = {
    severity = {
      min = vim.diagnostic.severity.WARN
    },
    format = function(_) return "" end,
    spacing = 1
  },
  signs = {
    severity = {
      min = vim.diagnostic.severity.WARN
    }
  },
  update_in_insert = true
})

local function severity_mark(level)
  if level == vim.diagnostic.severity.WARN then
    return 'warn'
  elseif level == vim.diagnostic.severity.ERROR then
    return 'error'
  elseif level == vim.diagnostic.severity.HINT then
    return 'hint'
  else
    return ''
  end
end

vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
  callback = function()
    vim.diagnostic.open_float({
      format = function(diagnostic)
        return string.format('%s: %s [%s]', severity_mark(diagnostic.severity), diagnostic.message, diagnostic.source)
      end
    })
  end
})

-- Options ---------------------------------------------------------------------

local function on_attach(client, bufnr)
  require('lsp_signature').on_attach({}, bufnr)
end

local function get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  return capabilities
end

-- Private ---------------------------------------------------------------------

local LANGSERVER_SET = 'LS_SET'
local NULL_LS_SET = 'NULL_LS_SET'

local function get_lspcfg_name(ls_name)
  return require('mason-lspconfig.mappings.server').package_to_lspconfig[ls_name]
end

local function init_set(name)
  if _G[name] == nil then
    _G[name] = {}
  end
end

local function set_language_server(lang, is_null_ls)
  if is_null_ls == nil or is_null_ls == false then
    local name = lang[1]
    lang[1] = nil
    _G[LANGSERVER_SET][name] = lang
  else
    local fullname = lang[1]
    lang[1] = nil
    _G[NULL_LS_SET][fullname] = lang
  end
end

local function get_null_ls_builtin(category, name)
  local data = require('null-ls.builtins')
  if data[category] == nil then return nil end
  if data[category][name] == nil then return nil end
  return data[category][name]
end

-- Public ----------------------------------------------------------------------

local startup = function(init)
  vim.opt.completeopt = 'menu,menuone,noselect'
  init_set(LANGSERVER_SET)
  init_set(NULL_LS_SET)

  if (type(init) == 'function') then
    init(set_language_server)
  end

  -- LSP ---------------------------------

  local default_setup = {
    on_attach = on_attach,
    capabilities = get_capabilities()
  }

  local lspconfig_setup_list = {
    function(server_name)
      require('lspconfig')[server_name].setup(default_setup)
    end
  }

  for name_, opts_ in pairs(_G[LANGSERVER_SET]) do
    local name = get_lspcfg_name(name_)
    lspconfig_setup_list[name] = function()
      local special_setup = vim.tbl_extend('force', default_setup, opts_)
      require('lspconfig')[name].setup(special_setup)
    end
  end

  require('mason').setup()
  local mason_lsp = require('mason-lspconfig')
  mason_lsp.setup_handlers(lspconfig_setup_list)

  -- NULL-LS -----------------------------

  local null_ls_sources = {}

  for name_, opts_ in pairs(_G[NULL_LS_SET]) do
    local category, name = string.gmatch(name_, '(%w+).(%w+)')()
    local server = get_null_ls_builtin(category, name)
    if server == nil then
      goto continue
    end
    if vim.tbl_isempty(opts_) then
      table.insert(null_ls_sources, server)
    else
      table.insert(null_ls_sources, server.with(opts_))
    end
    ::continue::
  end

  require('null-ls').setup({
    sources = null_ls_sources
  })
end

exports.startup = startup

return exports
