(require-macros :svim.macros.pkg)

;; LSP
(use-package stevearc/aerial.nvim :config (setup-package! :aerial))

;; Editing
(use-package folke/todo-comments.nvim)
(use-package ggandor/leap.nvim
             :requires [:tpope/vim-repeat]
             :config (config-package! :pkgs.leap))
(use-package kylechui/nvim-surround
             :config (setup-package! :nvim-surround))

;; Git
(use-package TimUntersberger/neogit)

;; Utilities
(use-package dstein64/vim-startuptime)
(use-package norcalli/nvim-colorizer.lua
             :ft ["html" "css" "javascript" "typescript" "yaml" "json"]
             :config (setup-package! :colorizer))
(use-package famiu/bufdelete.nvim)
(use-package gpanders/editorconfig.nvim)
(use-package sotvokun/reach.nvim
             :config (setup-package! :reach))
(use-package alec-gibson/nvim-tetris)
(use-package folke/zen-mode.nvim
             :config (config-package! :pkgs.zen-mode))
(use-package folke/twilight.nvim)

;; Terminal
(use-package akinsho/toggleterm.nvim
             :config (config-package! :pkgs.toggleterm))
