local use = require('svim.modules.package').use

-- Packages ----------------------------------------------------------
use {'neovim/nvim-lspconfig'}
use {'williamboman/mason.nvim',
     requires =
     {'williamboman/mason-lspconfig.nvim'}}
use {'hrsh7th/cmp-nvim-lsp'}

-- Initialization and Setup ------------------------------------------
vim.diagnostic.config({
  virtual_text = {
    severity = {
      min = vim.diagnostic.severity.WARN
    },
    format = function() return '' end,
    spacing = 0
  },
  signs = {
    severity = {
      min = vim.diagnostic.severity.ERROR
    }
  },
  update_in_insert = true
})

do
  local function severity_mark(level)
    local severity = vim.diagnostic.severity
    if level == severity.WARN then
      return 'warn'
    elseif level == severity.ERROR then
      return 'error'
    elseif level == severity.HINT then
      return 'hint'
    end
  end

  local function diagnostic_format(diagnostic)
    return string.format('%s: %s [%s]',
      severity_mark(diagnostic.severity),
      diagnostic.message,
      diagnostic.source)
  end

  vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
    callback = function ()
      vim.diagnostic.open_float({
        format = diagnostic_format,
        scope = 'cursor'
      })
    end
  })
end

-- Exports -----------------------------------------------------------
local M = {}

M.options = {
  on_attach = function(client, bufnr)
    do
      local ok, lsp_signature = pcall(require, 'lsp_signature')
      if ok then
        lsp_signature.on_attach({}, bufnr)
      end
    end
  end,

  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if cmp_lsp_ok then
      capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    end
    local ufo_ok, _ = pcall(require, 'ufo')
    if ufo_ok then
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
    end
    return capabilities
  end)()
}

M.apply = function(proc)
  if not pcall(require, 'lspconfig') then
    return
  end

  local handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup(M.options)
    end
  }

  --------
  -- use {'racket_langserver', setup = {}, raw = function() end}
  local function use(opts)
    if opts[1] == nil then
      return
    end
    local pkg2server = require('mason-lspconfig.mappings.server').package_to_lspconfig
    local servername = pkg2server[opts[1]]
    if servername ~= nil then
      if opts['raw'] ~= nil then
        handlers[servername] = opts['raw']
      else
        handlers[servername] = function()
          require(servername).setup(
            vim.tbl_extend('force', M.options, opts['setup'] or {}))
        end
      end
    else
      require('lspconfig')[opts[1]].setup(
        vim.tbl_extend('force', M.options, opts['setup'] or {}))
    end
  end

  proc(use)

  require('mason').setup()
  require('mason-lspconfig').setup()
  require('mason-lspconfig').setup_handlers(handlers)
end

return M
