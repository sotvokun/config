if exists('b:did_vue_ftplugin')
    finish
endif
let b:did_vue_ftplugin = 1


" Load HTML ftplugin for vue files
runtime! ftplugin/html.vim


if has('nvim')
    lua require('ftplugin.vue')
endif
