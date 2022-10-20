local create_autocmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

-- Mkdir for write file
-- REFERENCE: https://github.com/jghauser/mkdir.nvim
create_augroup('MkdirRun', {})
create_autocmd('BufWritePre', {
  desc = 'mkdir for write a file',
  group = 'MkdirRun',
  pattern = '*',
  callback = function()
    local dir = vim.fs.normalize(vim.fn.expand('<afile>:p:h'))
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end
})
