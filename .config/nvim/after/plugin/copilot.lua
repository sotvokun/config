-- after/plugin/copilot.lua
--

if vim.g.loaded_copilot_after then
	return
end
vim.g.loaded_copilot_after = true


-- copilot.vim
vim.g.copilot_no_tab_map = 1
vim.g.copilot_assume_mapped = 1
vim.g.copilot_tab_fallback = ''


-- copilot.lua
local ok, copilot = pcall(require, 'copilot')
if not ok then
	return
end

copilot.setup({
	suggestion = {
		auto_trigger = true,
		keymap = {
			accept = false,
			dismiss = false,
		},
	},
})


-- CopilotChat
local copilot_chat_ok, copilot_chat = pcall(require, 'CopilotChat')
if copilot_chat_ok then
	local cmp_ok, cmp = pcall(require, 'cmp')

	local default_config = require('CopilotChat.config')

	local inline_window = {
		layout = 'float',
		relative = 'cursor',
		width = 1,
	}

	copilot_chat.setup({
		debug = true,
		show_help = false,
		chat_complete = cmp_ok
	})

	vim.keymap.set('v', '<leader>cc', function ()
		copilot_chat.open({
			window = inline_window,
			selection = require('CopilotChat.select').visual,
		})
	end)

	vim.keymap.set('n', '<leader>cc', function ()
		copilot_chat.toggle({
			window = default_config.window,
			selection = require('CopilotChat.select').buffer,
		})
	end)

	vim.keymap.set('v', '<leader>ca', function ()
		copilot_chat.stop(false, {
			window = inline_window,
		})
		local actions = require('CopilotChat.actions')
		local prompts = actions.prompt_actions()

		local prompts = {
			prompt = 'Copilot Actions',
			actions = prompts.actions,
		}
		require('CopilotChat.integrations.fzflua').pick(prompts)
	end)

	vim.api.nvim_create_augroup('copilotchat#', {})
	vim.api.nvim_create_autocmd('BufEnter', {
		pattern = 'copilot-*',
		group = 'copilotchat#',
		callback = function ()
			vim.opt_local.number = false
		end
	})
end
