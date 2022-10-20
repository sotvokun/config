local icons = {
  webdev_colors = false,
  git_placement = 'after',
  show = {
    file = false,
    folder = false,
    folder_arrow = true
  },
  glyphs = {
    folder = {
      arrow_closed = '>',
      arrow_open = 'v',
      default = '>',
      open = 'v',
      empty = '>',
      empty_open = '='
    },
    git = {
      unstaged = 'U',
      untracked = 'u',
      staged = '+',
      renamed = 'R',
      deleted = 'D',
    }
  }
}

local renderer = {
  indent_width = 2,
  icons = icons,
  indent_markers = {
    enable = false
  }
}

local setup_opts = {
  renderer = renderer
}

if pcall(require, 'project_nvim') then
  setup_opts = vim.tbl_extend('force', setup_opts, {
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true
    }
  })
end

require('nvim-tree').setup(setup_opts)
