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

require('nvim-tree').setup({
  renderer = renderer
})
