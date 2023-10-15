(with-module [copilot :copilot]
  (local suggestion {:auto_trigger true :keymap false})
  (copilot.setup {: suggestion}))
