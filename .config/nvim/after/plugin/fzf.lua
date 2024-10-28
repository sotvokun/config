-- after/plugin/fzf.lua
--


local ok, fzf = pcall(require, 'fzf-lua')
if not ok then
	return
end

if vim.g.loaded_fzf_lua_after then
	return
end
vim.g.loaded_fzf_lua_after = true


-- Options

if vim.fn.executable('rg') == 1 then
	vim.env.FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden --glob=!.git/'
	vim.env.FZF_DEFAULT_OPTS = '--layout=reverse --preview-window=border-sharp --bind ctrl-a:select-all,ctrl-d:deselect-all'
end

fzf.setup({
	winopts = {
		border = 'none',
		backdrop = 45,
	},
})



-- Mappings

vim.keymap.set('n', '<leader>f', function()
	fzf.files()
end)
vim.keymap.set('n', '<leader>o', function()
	fzf.oldfiles()
end)
vim.keymap.set('n', '<leader>b', function()
	fzf.buffers()
end)
vim.keymap.set('n', '<leader>%', function()
	fzf.live_grep()
end)
vim.keymap.set('n', '<leader><leader>', function()
	fzf.resume()
end)
