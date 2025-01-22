(let [intelephense (vim.fn.exepath "intelephense")
      userhome (if (= 1 (vim.fn.has "win32")) vim.env.USERPROFILE vim.env.HOME)
      xdg-config-home (if vim.env.XDG_CONFIG_HOME vim.env.XDG_CONFIG_HOME
                          (vim.fs.joinpath userhome ".config"))
      intelephense-config-path (vim.fs.joinpath xdg-config-home "intelephense")
      intelephense-licence-path (vim.fs.joinpath intelephense-config-path "license.key")

      cwd (vim.uv.cwd)
      vscode-settings-path (vim.fs.joinpath cwd ".vscode" "settings.json")
      vscode-settings-raw (if (= 1 (vim.fn.filereadable vscode-settings-path))
                              (vim.fn.json_decode (vim.fn.readfile vscode-settings-path))
                              {})
      vscode-settings ((. vim.fn "json#expand") vscode-settings-raw)]
  {:filetypes ["php"]
   :cmd [intelephense "--stdio"]
   :root_markers ["composer.json"]
   :init_options {:licenceKey intelephense-licence-path}
   :settings {:intelephense (or (. vscode-settings "intelephense") {})}})
