return function()
  local telescope = require('telescope')
  telescope.setup({
    defaults = {
      layout_strategy = 'center',
      layout_config = {
        mirror = true
      }
    }
  })
  telescope.load_extension('project')
end
