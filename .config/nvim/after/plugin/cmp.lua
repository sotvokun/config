-- after/plugin/cmp.lua - cmp configuration
--

if vim.g.loaded_cmp_after then
	return
end
vim.g.loaded_cmp_after = true


local ok, cmp = pcall(require, 'cmp')
if not ok then
	return
end


-- Helper functions

local function feedkey(keys, mode)
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes(keys, true, true, true),
		mode,
		true
	)
end

local function copilot_ready()
	-- for copilot.lua
	local copilot_ok, copilot = pcall(require, 'copilot')
	return copilot_ok

	-- -- for copilot.vim
	-- return vim.fn.exists(':Copilot') ~= 0 and vim.fn['copilot#Enabled']()
end

local function copilot_has_suggestion()
	if not copilot_ready() then
		return false
	end

	-- for copilot.lua
	return require('copilot.suggestion').is_visible()

	-- -- for copilot.vim
	-- local suggestion = vim.fn['copilot#GetDisplayedSuggestion']()
	-- return suggestion.text ~= nil and string.len(suggestion.text) > 0
end

local function copilot_accept()
	-- for copilot.lua
	require('copilot.suggestion').accept()

	-- -- for copilot.vim
	-- vim.api.nvim_feedkeys(
	-- 	vim.fn['copilot#Accept'](
	-- 		vim.api.nvim_replace_termcodes('<tab>', true, true, true)
	-- 	),
	-- 	'n',
	-- 	true
	-- )
end

local function copilot_dismiss()
	-- for copilot.lua
	require('copilot.suggestion').dismiss()

	-- -- for copilot.vim
	-- feedkey('<Plug>(copilot-dismiss)', '')
end


-- Setups

local function setup_snippets()
	return {
		expand = function(args)
			vim.fn['vsnip#anonymous'](args.body)
		end
	}
end

local function setup_sources()
local sources = {
		{name = 'vsnip'},
		{name = 'buffer'},
		{name = 'path'}
	}
	local ok, nvim_lsp = pcall(require, 'cmp_nvim_lsp')
	if ok then
		table.insert(sources, 2, {name = 'nvim_lsp'})
	end
	return cmp.config.sources(sources)
end


-- Keymaps

local function map_tab(fallback)
	if cmp.visible() then
		local entry = cmp.get_selected_entry()
		if not entry then
			cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
		else
			cmp.confirm()
		end
	elseif vim.fn['vsnip#available']() == 1 then
		feedkey('<Plug>(vsnip-expand-or-jump)', '')
	elseif copilot_has_suggestion() then
		copilot_accept()
	else
		fallback()
	end
end

local function map_s_tab(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif vim.fn['vsnip#jumpable'](-1) == 1 then
		feedkey('<Plug>(vsnip-jump-prev)', '')
	else
		fallback()
	end
end

local function map_cr(fallback)
	if cmp.visible() and cmp.get_active_entry() then
		cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false})
	else
		fallback()
	end
end

local function map_c_e(fallback)
	if cmp.visible() then
		cmp.abort()
	elseif copilot_has_suggestion() then
		copilot_dismiss()
	else
		fallback()
	end
end


cmp.setup({
	completion = {
		completeopt = 'menu,menuone,noinsert'
	},
	snippet = setup_snippets(),
	sources = setup_sources(),
	mapping = {
		['<tab>'] = cmp.mapping(map_tab, {'i', 's'}),
		['<s-tab>'] = cmp.mapping(map_s_tab, {'i', 's'}),
		['<cr>'] = {
			['i'] = map_cr,
			['s'] = cmp.mapping.confirm({select = true})
		},
		['<c-e>'] = cmp.mapping(map_c_e, {'i', 's'}),
		['<c-n>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
		['<c-p>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})
	}
})
