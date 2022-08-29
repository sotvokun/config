return function()
  local icons = {
    webdev_colors = false,
    symlink_arrow = ' -> ',
    git_placement = 'after',
    padding = '',
    show = {
      file = false,
      folder = false,
      folder_arrow = true,
      git = true
    },
    glyphs = {
      folder = {
        default = '>',
        arrow_closed = '>',
        arrow_open = 'v',
        empty = '>',
        empty_open = '=',
        symlink = '>',
        symlink_open = 'v'
      },
      git = {
        unstaged = 'U',
        staged = '+',
        unmerged = '',
        renamed = 'R',
        untracked = '',
        deleted = 'D',
        ignored = ''
      }
    }
  }
  local cfg = {
    renderer = {
      icons = icons
    }
  }
  require('nvim-tree').setup(cfg)
end
