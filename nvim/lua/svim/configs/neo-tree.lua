local icon = {
  folder_closed = '>',
  folder_open = 'v',
  folder_empty = '=',
  default = ''
}

local git_status = {
  symbols = {
    added = '',
    modified = '',
    deleted = 'D',
    renamed = 'R',

    untracked = '',
    ignored = '',
    unstaged = 'U',
    staged = '+',
    conflict = 'C'
  }
}

require('neo-tree').setup({
  default_component_configs = {
    icon = icon,
    git_status = git_status
  }
})
