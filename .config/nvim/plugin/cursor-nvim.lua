-- cursor-nvim.lua
--
-- a plugin to open Cursor editor in neovim
--
-- USAGE:
--   This plugin provides commands and mappings to open Cursor editor from Neovim,
--   with the ability to preserve cursor position and hide the primary sidebar.
--
-- COMMANDS:
--   CursorOpen                - open Cursor editor at current cursor position
--   CursorOpenCwd            - open Cursor editor in current working directory
--
-- MAPPINGS:
--   <leader>co               - open Cursor at current position
--   <leader>cw               - open Cursor in current working directory
--
-- FEATURES:
--   - Preserves cursor position when opening files
--   - Automatically hides primary sidebar for AI-focused workflow
--   - Provides error notifications for common issues
--   - Supports both file and directory opening modes
--
-- REQUIREMENTS:
--   - Cursor editor must be installed and available in PATH
--   - Neovim 0.5 or later (for jobstart and notification support)
--

local M = {}

function M.open_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row = cursor_pos[1]
  local col = cursor_pos[2] + 1 -- Cursor uses 1-based column indexing
  
  local file_path = vim.api.nvim_buf_get_name(buf)
  
  if file_path == "" then
    vim.notify("No file is currently open", vim.log.levels.WARN)
    return
  end
  
  if not vim.fn.fnamemodify(file_path, ":p"):match("^/") then
    file_path = vim.fn.fnamemodify(file_path, ":p")
  end
  
  if vim.fn.filereadable(file_path) == 0 then
    vim.notify("File does not exist: " .. file_path, vim.log.levels.ERROR)
    return
  end
  
  -- Build the cursor command with goto position and hide sidebar
  local cmd = string.format("cursor --hide-primary-sidebar --goto %s:%d:%d", file_path, row, col)
  
  vim.fn.jobstart(cmd, {
    detach = true,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("Opened in Cursor: " .. vim.fn.fnamemodify(file_path, ":t"), vim.log.levels.INFO)
      else
        vim.notify("Failed to open Cursor. Make sure Cursor is installed and in PATH.", vim.log.levels.ERROR)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        vim.notify("Cursor error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end
  })
end


function M.open_cursor_cwd()
  local cwd = vim.fn.getcwd()
  local cmd = string.format("cursor --hide-primary-sidebar %s", cwd)
  
  vim.fn.jobstart(cmd, {
    detach = true,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("Opened Cursor in: " .. cwd, vim.log.levels.INFO)
      else
        vim.notify("Failed to open Cursor. Make sure Cursor is installed and in PATH.", vim.log.levels.ERROR)
      end
    end
  })
end


-- :CursorOpen
vim.api.nvim_create_user_command('CursorOpen', M.open_cursor, {
  desc = 'Open Cursor editor at current cursor position'
})

-- :CursorOpenCwd
vim.api.nvim_create_user_command('CursorOpenCwd', M.open_cursor_cwd, {
  desc = 'Open Cursor editor in current working directory'
})


vim.keymap.set('n', '<leader>co', M.open_cursor, { 
  desc = 'Open Cursor at current position',
  silent = true 
})

vim.keymap.set('n', '<leader>cw', M.open_cursor_cwd, { 
  desc = 'Open Cursor in current working directory',
  silent = true 
})
