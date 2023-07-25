" ==============================================================================
"
" mercury.vim - A colorscheme with low contrast and little bit colors
"
" Author:  Junchen Du <sotvokun#outlook.com>
" Created: 2022-12-27
" Updated: 2023-07-25
" LICENSE: UNLICENSE
"
" ==============================================================================

if v:version > 580
  highlight clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name = 'mercury'

let s:has_termguicolors = !(has('termguicolors') && &termguicolors)

if !(has('nvim')) && !s:has_termguicolors && !t_Co != 256
  echoerr "'mercury' only supports 256-colors terminal and the options 'termguicolors' is enabled"
  finish
endif


" Color Palette
" ----------------------------------------------------------
let s:mercury_colors = {}

let s:mercury_colors['black']           = ['#1c1c1c', 234]
let s:mercury_colors['bright_black']    = ['#000000',   0]
let s:mercury_colors['white']           = ['#eeeeee', 255]
let s:mercury_colors['bright_white']    = ['#ffffff',  15]

" Dark && Normal
let s:mercury_colors['dark_red']        = ['#870000',  88]
let s:mercury_colors['dark_green']      = ['#008700',  28]
let s:mercury_colors['dark_yellow']     = ['#af5f00', 130]
let s:mercury_colors['dark_blue']       = ['#005faf',  25]
let s:mercury_colors['dark_magenta']    = ['#8700af',  91]
let s:mercury_colors['dark_cyan']       = ['#005f87',  24]

" Darker
let s:mercury_colors['darker_red']      = ['#5f0000',  52]
let s:mercury_colors['darker_green']    = ['#005f00',  22]
let s:mercury_colors['darker_yellow']   = ['#875f00',  94]
let s:mercury_colors['darker_blue']     = ['#00005f',  17]
let s:mercury_colors['darker_magenta']  = ['#5f0087',  54]

" Light && Bright
let s:mercury_colors['light_red']       = ['#d70000', 160]
let s:mercury_colors['light_green']     = ['#5faf00',  70]
let s:mercury_colors['light_yellow']    = ['#ffaf00', 214]
let s:mercury_colors['light_blue']      = ['#0087d0',  32]
let s:mercury_colors['light_magenta']   = ['#af00ff', 129]
let s:mercury_colors['light_cyan']      = ['#00afaf',  37]

" Lighter
let s:mercury_colors['lighter_red']     = ['#ffd7d7', 224]
let s:mercury_colors['lighter_green']   = ['#87d787', 114]
let s:mercury_colors['lighter_yellow']  = ['#ffd787', 221]
let s:mercury_colors['lighter_blue']    = ['#87dfff', 117]
let s:mercury_colors['lighter_magenta'] = ['#d7d7ff', 189]

let s:c = s:mercury_colors


" Color Palette (Grayscale)
" ----------------------------------------------------------
let s:mercury_grays = {}

let s:mercury_grays['black_sp']         = ['#121212', 233]
let s:mercury_grays['black']            = ['#000000',   0]
let s:mercury_grays['darkest']          = ['#1c1c1c', 234]
let s:mercury_grays['darker']           = ['#3a3a3a', 237]
let s:mercury_grays['dark']             = ['#4e4e4e', 239]
let s:mercury_grays['gray']             = ['#6c6c6c', 242]
let s:mercury_grays['light']            = ['#a8a8a8', 248]
let s:mercury_grays['lighter']          = ['#c6c6c6', 251]
let s:mercury_grays['lightest']         = ['#e4e4e4', 254]
let s:mercury_grays['white']            = ['#ffffff',  15]
let s:mercury_grays['white_sp']         = ['#eeeeee', 255]

let s:g = s:mercury_grays


" Utility
" ----------------------------------------------------------
let s:attrs = {
      \ 'bold'     : 'bold',
      \ 'italic'   : 'italic',
      \ 'underline': 'underline',
      \ 'undercurl': 'undercurl',
      \ 'inverse'  : 'inverse',
      \ 'strikethrough'
      \            : 'strikethrough',
      \ 'none'     : 'NONE'
      \ }
let s:a = s:attrs

let s:none = ['NONE', 'NONE']

function! s:h(scope, fg, ...) " bg, attr_list
  let l:fg = copy(a:fg)
  let l:bg = get(a:, 1, ['NONE', 'NONE'])
  let l:attr_list = filter(get(a:, 2, ['NONE']), 'type(v:val) == 1')
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'

  let l:hi_string = [
        \ 'highlight', a:scope,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . l:fg[1],
        \ 'guibg=' . l:bg[0], 'ctermbg=' . l:bg[1],
        \ 'gui=' . l:attrs, 'cterm=' . l:attrs
        \ ]
  execute join(l:hi_string, ' ')
endfunction

function! s:hl(src, dst)
  for l:hl in a:dst
    let l:hil_string = ['hi!', 'link', l:hl, a:src]
    execute join(l:hil_string, ' ')
  endfor
endfunction


" Terminal
" ----------------------------------------------------------
let g:terminal_ansi_colors = [
      \ s:c.black[0],        s:c.dark_red[0],      s:c.dark_green[0],  s:c.dark_yellow[0], 
      \ s:c.dark_blue[0],    s:c.dark_magenta[0],  s:c.dark_cyan[0],   s:c.white[0],
      \ 
      \ s:c.bright_black[0], s:c.light_red[0],     s:c.light_green[0], s:c.light_yellow[0],
      \ s:c.light_blue[0],   s:c.light_magenta[0], s:c.light_cyan[0],  s:c.bright_white[0]
      \ ]

if has('nvim')
  for s:tci in range(16)
    let g:terminal_color_{s:tci} = g:terminal_ansi_colors[s:tci]
  endfor
endif


let s:k = {}
" Dark
" ----------------------------------------------------------
if &background ==# 'dark'
  let s:k['fg'] = {
        \ 'normal'  : s:g.lightest,
        \ 'brighter': s:g.white,
        \ 'bright'  : s:g.white_sp,
        \ 'dim'     : s:g.light,
        \ 'dimmer'  : s:g.darker,
        \ 'ignore'  : s:g.darkest,
        \ 'mid'     : s:g.gray,
        \ 'inverse' : s:g.darkest
        \ }

  let s:k['bg'] = {
        \ 'normal'  : s:g.darkest,
        \ 'popup'   : s:g.black,
        \ 'inactive': s:g.dark,
        \ 'active'  : s:g.darker,
        \ 'separator'
        \           : s:g.darker,
        \ 'bright'  : s:g.dark,
        \ 'mid'     : s:g.gray,
        \ 'inverse' : s:g.light,
        \ 'column'  : s:g.black_sp,
        \ 'unimportant'
        \           : s:g.black_sp,
        \ 'cursorline'
        \           : s:g.darker
        \ }

  let s:k['red']        = { 'normal': s:c.light_red,        'bright': s:c.lighter_red,      'dim': s:c.dark_red }
  let s:k['green']      = { 'normal': s:c.light_green,      'bright': s:c.lighter_green,    'dim': s:c.dark_green }
  let s:k['yellow']     = { 'normal': s:c.light_yellow,     'bright': s:c.lighter_yellow,   'dim': s:c.dark_yellow }
  let s:k['blue']       = { 'normal': s:c.light_blue,       'bright': s:c.lighter_blue,     'dim': s:c.dark_blue }
  let s:k['magenta']    = { 'normal': s:c.light_magenta,    'bright': s:c.lighter_magenta,  'dim': s:c.dark_magenta }
  let s:k['cyan']       = { 'normal': s:c.light_cyan,                                       'dim': s:c.dark_cyan }
endif


" Light
" ----------------------------------------------------------
if &background ==# 'light'
  let s:k['fg'] = {
        \ 'normal'  : s:g.darkest,
        \ 'brighter': s:g.black,
        \ 'bright'  : s:g.black_sp,
        \ 'dim'     : s:g.dark,
        \ 'dimmer'  : s:g.lighter,
        \ 'ignore'  : s:g.lightest,
        \ 'mid'     : s:g.gray,
        \ 'inverse' : s:g.white_sp
        \ }

  let s:k['bg'] = {
        \ 'normal'  : s:g.white_sp,
        \ 'popup'   : s:g.white,
        \ 'inactive': s:g.light,
        \ 'active'  : s:g.lighter,
        \ 'separator'
        \           : s:g.lighter,
        \ 'bright'  : s:g.light,
        \ 'mid'     : s:g.gray,
        \ 'inverse' : s:g.darkest,
        \ 'column'  : s:g.lightest,
        \ 'unimportant'
        \           : s:g.lightest,
        \ 'cursorline'
        \           : s:g.lightest
        \ }

  let s:k['red']        = { 'normal': s:c.dark_red,        'bright': s:c.darker_red,      'dim': s:c.light_red }
  let s:k['green']      = { 'normal': s:c.dark_green,      'bright': s:c.darker_green,    'dim': s:c.light_green }
  let s:k['yellow']     = { 'normal': s:c.dark_yellow,     'bright': s:c.darker_yellow,   'dim': s:c.light_yellow }
  let s:k['blue']       = { 'normal': s:c.dark_blue,       'bright': s:c.darker_blue,     'dim': s:c.light_blue }
  let s:k['magenta']    = { 'normal': s:c.dark_magenta,    'bright': s:c.darker_magenta,  'dim': s:c.light_magenta }
  let s:k['cyan']       = { 'normal': s:c.dark_cyan,                                      'dim': s:c.light_cyan }
endif


" Highlight Groups
" ----------------------------------------------------------

call s:h('Normal', s:k.fg.normal, s:k.bg.normal)
call s:h('EndOfBuffer', s:k.fg.dimmer)
call s:h('NonText', s:k.fg.dimmer)
call s:hl('NonText', ['SpecialKey'])
call s:h('Title', s:k.fg.brighter, s:none, [s:a.bold])
call s:h('Folded', s:k.fg.dimmer, s:k.bg.unimportant, [s:a.italic])
call s:h('Search', s:k.fg.inverse, s:c.light_yellow)
call s:hl('Search', ['IncSearch'])
call s:h('Visual', s:none, s:k.bg.active)
call s:h('Question', s:k.green.dim, s:none, [s:a.bold])
call s:h('WarningMsg', s:k.red.normal)
call s:h('ModeMsg', s:none, s:none, [s:a.bold])
call s:h('MoreMsg', s:k.green.dim, s:none, [s:a.bold])

" Spell
call s:h('SpellBad', s:k.red.normal, s:none, [s:a.undercurl])
call s:h('SpellCap', s:k.yellow.normal, s:none, [s:a.undercurl])
call s:h('SpellRare', s:k.yellow.bright, s:none, [s:a.undercurl])
call s:h('SpellLocal', s:k.yellow.bright, s:none, [s:a.underline])

" Diff
call s:h('DiffAdd', s:k.fg.normal, s:k.green.dim)
call s:h('DiffChange', s:k.fg.normal, s:k.yellow.dim)
call s:h('DiffDelete', s:k.fg.normal, s:k.red.dim)
call s:h('DiffText', s:k.fg.normal, s:k.yellow.dim, [s:a.underline])

" RedrawDebug
call s:h('RedrawDebugNormal', s:k.fg.ignore, s:k.bg.inverse)
call s:h('RedrawDebugClear', s:k.fg.ignore, s:k.yellow.normal)
call s:h('RedrawDebugComposed', s:k.fg.ignore, s:k.green.normal)
call s:h('RedrawDebugRecompose', s:k.fg.ignore, s:k.red.normal)

" Diagnostic
call s:h('DiagnosticError', s:k.red.normal)
call s:h('DiagnosticWarn', s:k.yellow.normal)
call s:h('DiagnosticInfo', s:k.blue.bright)
call s:h('DiagnosticHint', s:k.fg.brighter)
call s:h('DiagnosticUnderlineError', s:k.red.normal, s:none, [s:a.underline])
call s:h('DiagnosticUnderlineWarn', s:k.yellow.normal, s:none, [s:a.underline])
call s:h('DiagnosticUnderlineInfo', s:k.blue.bright, s:none, [s:a.underline])
call s:h('DiagnosticUnderlineHint', s:k.fg.brighter, s:none, [s:a.underline])

" Syntax
call s:h('Comment', s:k.fg.mid)
call s:h('Identifier', s:k.fg.normal)
call s:h('Constant', s:k.fg.normal)
call s:h('Operator', s:k.fg.normal)
call s:h('Special', s:k.fg.normal)
call s:h('Keyword', s:k.fg.brighter, s:none, [s:a.bold])
call s:hl('Keyword', ['Statement', 'Type', 'Include', 'PreProc'])
call s:h('String', s:k.green.normal)
call s:hl('String', ['SpecialChar'])
call s:h('Number', s:k.blue.normal)
call s:h('Macro', s:k.magenta.normal)

" Interfaces
"  - Misc
call s:h('WinSeparator', s:k.bg.separator)

"  - Cursor
call s:h('Cursor', s:k.fg.normal, s:k.bg.normal, [s:a.inverse])
call s:hl('Cursor', ['lCursor', 'CursorIM'])
call s:h('CursorLine', s:none, s:k.bg.cursorline)
call s:hl('CursorLine', ['CursorColumn'])

"  - Number/Sign/Color Column
call s:h('LineNr', s:k.fg.dim, s:k.bg.column)
call s:h('CursorLineNr', s:k.fg.dim, s:k.bg.column, [s:a.bold])
call s:h('SignColumn', s:none, s:k.bg.column)
call s:hl('SignColumn', ['FoldColumn'])
call s:h('ColorColumn', s:none, s:k.bg.column)

"  - Pmenu / Wild
call s:h('Pmenu', s:none, s:k.bg.popup)
call s:h('PmenuSel', s:none, s:k.bg.bright)
call s:h('PmenuSbar', s:none, s:k.bg.mid)
call s:h('PmenuThumb', s:none, s:k.bg.active)
call s:h('WildMenu', s:k.fg.inverse, s:k.bg.inverse, [s:a.bold])

"  - StatusLine
call s:h('StatusLine', s:k.fg.brighter, s:k.bg.active, [s:a.bold])
call s:h('StatusLineNC', s:k.fg.dim, s:k.bg.inactive, [s:a.italic])

"  - TabLine
call s:h('TabLine', s:k.fg.dim, s:k.bg.inactive, [s:a.italic])
call s:hl('TabLine', ['TabLineFill'])
call s:h('TabLineSel', s:k.fg.brighter, s:k.bg.active, [s:a.bold])

" Misc
call s:h('NvimInternalError', s:c.darker_red, s:c.light_red)
call s:h('Ignore', s:k.fg.ignore)
call s:hl('Ignore', ['FloatShadow', 'FloatShadowThrough'])
call s:h('Error', s:k.red.normal)
call s:h('Todo', s:k.fg.brighter, s:none, [s:a.bold])
call s:h('Underlined', s:none, s:none, [s:a.underline])
call s:h('Directory', s:c.light_cyan, s:none, [s:a.bold])

" Plugins
"  - MatchParen
call s:h('MatchParen', s:k.fg.inverse, s:c.light_blue)

" Languages Spec


" vim: sw=2:expandtab
