" Neovide
" ----------------------------
if exists('g:neovide')
    set guifont=Iosevka\ Pragmatus:h12
    let g:neovide_cursor_animation_length = 0.03
    let g:neovide_cursor_trail_length = 0.3

    if has('mac')
        let g:neovide_input_macos_alt_is_meta = v:true
    endif
endif

" Nvim-qt
" ----------------------------
if exists('g:GuiLoaded')

endif
