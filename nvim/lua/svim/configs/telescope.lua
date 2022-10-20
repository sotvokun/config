local setup = {
  defaults = {
    layout_strategy = 'bottom_pane',
    border = false
  }
}
require('telescope').setup(setup)

if pcall(require, 'project_nvim') then
  require('telescope').load_extension('projects')
end
