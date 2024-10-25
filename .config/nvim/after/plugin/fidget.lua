-- after/plugin/fidget.lua - fidget.nvim configuration
--

if vim.g.loaded_fidget_after then
	return
end
vim.g.loaded_fidget_after = true


local ok, fidget = pcall(require, 'fidget')
if not ok then
	return
end


fidget.setup()
