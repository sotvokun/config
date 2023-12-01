" Section: Components

function! StatusLineCompModified()
    return &modified ? '[+]' : ''
endfunction

function! StatusLineCompReadonly()
    return &readonly ? '[RO]' : ''
endfunction

function! StatusLineCompFileformat()
    let l:format = &fileformat
    if l:format == 'dos'
        return '[CRLF]'
    elseif l:format == 'mac'
        return '[CR]'
    else
        return ''
    endif
endfunction

function! StatusLineCompFileencoding()
    if &fileencoding == 'utf-8' || &fileencoding == ''
        return ''
    else
        return '[' . toupper(&fileencoding) . ']'
endfunction

function! StatusLineCompFiletype()
    if &filetype == ''
        return ''
    else
        return '[' . (&filetype) . ']'
endfunction

function! s:get_floaterm_title()
    let arg2 = len(g:floaterm#buflist#gather())
    let arg1 = index(g:floaterm#buflist#gather(), bufnr()) + 1
    let title = b:floaterm_title
    let title = substitute(title, '\$1', arg1, '')
    let title = substitute(title, '\$2', arg2, '')
    return title
endfunction

function! StatusLineCompFilename()
    let l:winwidth = winwidth('%')
    let l:bufname = bufname('%')
    let l:filename = fnamemodify(l:bufname, '%:p:h')
    let l:isfile = &buftype == '' && filereadable(l:filename)

    if l:bufname == ''
        return '[No Name]'
    endif

    if l:isfile
        return (len(l:bufname) > 60 || l:winwidth < 100) ? pathshorten(l:bufname) : l:bufname
    elseif &buftype == 'help'
        return fnamemodify(l:bufname, ':t')
    elseif &filetype == 'floaterm'
        return s:get_floaterm_title()
    else
        return l:bufname
    endif
endfunction

function! StatusLineCompLocation()
    return line('.') . ':' . virtcol('.')
endfunction

function! s:mode_hl(mode)
    if a:mode == 'v' || a:mode == 'V' || a:mode == '\22' || a:mode == 's' || a:mode == 'S' || a:mode == '\19'
        return 'StatusLineModeVisual'
    elseif a:mode == 'i'
        return 'StatusLineModeInsert'
    elseif a:mode == 'r' || a:mode == 'R' || a:mode == 'Rv'
        return 'StatusLineModeReplace'
    elseif a:mode == 'c' || a:mode == 'cv' || a:mode == 'ce'
        return 'StatusLineModeCommand'
    elseif a:mode == 't'
        return 'StatusLineModeTerminal'
    elseif a:mode == '!'
        return 'StatusLineModeShell'
    else
        return 'Normal'
    endif
endfunction

function! StatusLineCompMode()
    let l:mode = mode()
    let s:mode = {
        \ 'v': 'visual',
        \ 'V': 'visual-line',
        \ '\22': 'visual-block',
        \ 's': 'select',
        \ 'S': 'select-line',
        \ '\19': 'select-block',
        \ 'i': 'insert',
        \ 'r': 'replace',
        \ 'R': 'replace',
        \ 'Rv': 'visual-replace',
        \ 'c': 'command',
        \ 'cv': 'ex',
        \ 'ce': 'ex',
        \ '!': 'shell',
        \ 't': 'terminal'
        \ }
    if get(s:mode, l:mode, '') == ''
        return ''
    else
        return '%#' . s:mode_hl(l:mode) . '#' . s:mode[l:mode] . '%*'
endfunction

function! StatusLineLspClients()
    let l:clients = v:lua.require'lsp'.util.client_names(bufnr('%'))
    if len(l:clients) == 0
        return ''
    else
        return ' [' . join(l:clients, ' ') . ']'
    endif
endfunction

function! StatusLineDissessionStatus()
    if !exists('g:loaded_dissession')
        return ""
    endif
    if g:dissession_ready && v:this_session == ''
        return '%#DissessionReady#' . '○ ' . '%*'
    elseif g:dissession_ready && v:this_session != ''
        return '%#DissessionLoaded#' . '● ' . '%*'
    else
        return ""
    endif
endfunction

" Section: Setup

set statusline=
set statusline+=%{%StatusLineDissessionStatus()%}
set statusline+=\ %{StatusLineCompFilename()}
set statusline+=\ %{StatusLineCompModified()}%{StatusLineCompReadonly()}
set statusline+=%=
set statusline+=%{%StatusLineCompMode()%}
set statusline+=%{StatusLineLspClients()}
set statusline+=\ %{StatusLineCompFiletype()}%{StatusLineCompFileformat()}%{StatusLineCompFileencoding()}
set statusline+=\ %10{StatusLineCompLocation()}
set statusline+=\ 

" vim: expandtab shiftwidth=4
