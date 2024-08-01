" -----------------------------------------------------------------------------
" mercury.vim - a simple colorscheme with low contrast
" Author:  Junchen Du <sotvokun#outlook.com>
" Created: 2022-12-27
" Updated: 2024-08-02
" License: UNLICENSE
" -----------------------------------------------------------------------------

" Documents -------------------------------------------------------------------
" Introduction: {{{
"
" Mercury is a colorscheme only uses colors from the 256 (Xterm) color palette.
"
" The colorscheme is inspired by the following colorschemes:
" - https://github.com/kkga/vim-envy
" - https://github.com/kkga/saturn.kak
"
" The code is inspired by:
" - https://github.com/dracula/vim
" - https://github.com/morhetz/gruvbox
"
" }}}
" Terminal Colors: {{{
"
" Name              Hex             256-colors-code
" ----------------------------------------------------
" black             #1C1C1C         234
" red               #870000           8
" green             #008700          28
" yellow            #AF5F00         130
" blue              #005FAF          25
" magenta           #8700AF          91
" cyan              #005F87          24
" white             #EEEEEE         255
" bright-black      #000000           0
" bright-red        #D70000         160
" bright-green      #5FAF00          70
" bright-yellow     #FFAF00         214
" bright-blue       #0087D0          32
" bright-magenta    #AF00FF         129
" bright-cyan       #00AFAF          37
" bright-white      #FFFFFF          15
"
" }}}
" Grayscale Colors: {{{
"
" Name          Hex                 256-color-code
" -------------------------------------------------------
" black-sp      #121212             233
" black         #000000               0
" darkest       #1C1C1C             234
" darker        #3A3A3A             237
" dark          #4E4E4E             239
" gray          #6C6C6C             242
" light         #A8A8A8             248
" lighter       #C6C6C6             251
" lightest-sp   #D0D0D0             252
" lightest      #E4E4E4             254
" white         #FFFFFF              15
" white-sp      #EEEEEE             255
"
" }}}
" Colorful Colors: {{{
"
" Family                  Hexs                      color-codes
"             DARKER  DARK    LIGHT   LIGHTER
" ---------------------------------------------------------------
" red         #5F0000 #870000 #D70000 #FFD7D7      52  88 160 224
" green       #005F00 #008700 #5FAF00 #87D787      22  28  70 114
" yellow      #875F00 #AF5F00 #FFAF00 #FFD787      94 130 214 221
" blue        #00005F #005FAF #0087D0 #87D7FF      17  25  32 117
" magenta     #5F0087 #8700AF #AF00FF #D7D7FF      54  91 129 189
"
" }}}


" Supporting Code -------------------------------------------------------------
" Initializations: {{{

if v:version > 580
  hi clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name = 'mercury'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  echoerr "'mercury' only supports 256-colors terminal and 'termguicolors' is enabled"
  finish
endif

" }}}
" Color Palette: {{{

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

" }}}
" Grayscale Color Palette: {{{

let s:mercury_grays = {}

let s:mercury_grays['black_sp']         = ['#121212', 233]
let s:mercury_grays['black']            = ['#000000',   0]
let s:mercury_grays['darkest']          = ['#1c1c1c', 234]
let s:mercury_grays['darker']           = ['#3a3a3a', 237]
let s:mercury_grays['dark']             = ['#4e4e4e', 239]
let s:mercury_grays['gray']             = ['#6c6c6c', 242]
let s:mercury_grays['light']            = ['#a8a8a8', 248]
let s:mercury_grays['lighter']          = ['#c6c6c6', 251]
let s:mercury_grays['lightest_sp']      = ['#d0d0d0', 252]
let s:mercury_grays['lightest']         = ['#e4e4e4', 254]
let s:mercury_grays['white']            = ['#ffffff',  15]
let s:mercury_grays['white_sp']         = ['#eeeeee', 255]

let s:g = s:mercury_grays

" }}}
" Attributes: {{{

let s:attrs = {
      \ 'bold'         : 'bold',
      \ 'italic'       : 'italic',
      \ 'underline'    : 'underline',
      \ 'undercurl'    : 'undercurl',
      \ 'inverse'      : 'inverse',
      \ 'strikethrough': 'strikethrough',
      \ 'none'         : 'NONE'
      \ }

let s:a = s:attrs

let s:none = ['NONE', 'NONE']

" }}}
" Utility Functions: {{{

function! s:H(group, fg, ...) " bg, attr_list
  let l:fg = copy(a:fg)
  let l:bg = get(a:, 1, ['NONE', 'NONE'])
  let l:attr_list = filter(get(a:, 2, ['NONE']), 'type(v:val) == 1')
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'

  let l:hi_string = [
        \ 'highlight', a:group,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . l:fg[1],
        \ 'guibg=' . l:bg[0], 'ctermbg=' . l:bg[1],
        \ 'gui=' . l:attrs, 'cterm=' . l:attrs
        \ ]
  execute join(l:hi_string, ' ')
endfunction

function! s:L(src, dst)
  for l:hl in a:dst
    let l:hil_string = ['hi!', 'link', l:hl, a:src]
    execute join(l:hil_string, ' ')
  endfor
endfunction

" }}}
" Color Definitions As K: {{{

let s:k = {}

if &background ==# 'dark'
  " dark
  let s:k['fg'] = {
        \ 'normal'  : s:g.lightest_sp,
        \ 'brighter': s:g.white,
        \ 'bright'  : s:g.white_sp,
        \ 'dim'     : s:g.light,
        \ 'dimmer'  : s:g.darker,
        \ 'ignore'  : s:g.darkest,
        \ 'mid'     : s:g.gray,
        \ 'inverse' : s:g.black_sp
        \ }
  let s:k['bg'] = {
        \ 'normal'     : s:g.black_sp,
        \ 'popup'      : s:g.black,
        \ 'inactive'   : s:g.dark,
        \ 'active'     : s:g.darker,
        \ 'separator'  : s:g.darker,
        \ 'bright'     : s:g.dark,
        \ 'mid'        : s:g.gray,
        \ 'inverse'    : s:g.lightest,
        \ 'column'     : s:g.darkest,
        \ 'unimportant': s:g.darkest,
        \ 'cursorline' : s:g.darkest
        \ }
  " let s:k['fg'] = {
  "       \ 'normal'  : s:g.lightest,
  "       \ 'brighter': s:g.white,
  "       \ 'bright'  : s:g.white_sp,
  "       \ 'dim'     : s:g.light,
  "       \ 'dimmer'  : s:g.darker,
  "       \ 'ignore'  : s:g.darkest,
  "       \ 'mid'     : s:g.gray,
  "       \ 'inverse' : s:g.darkest
  "       \ }
  " let s:k['bg'] = {
  "       \ 'normal'     : s:g.darkest,
  "       \ 'popup'      : s:g.black,
  "       \ 'inactive'   : s:g.dark,
  "       \ 'active'     : s:g.darker,
  "       \ 'separator'  : s:g.darker,
  "       \ 'bright'     : s:g.dark,
  "       \ 'mid'        : s:g.gray,
  "       \ 'inverse'    : s:g.light,
  "       \ 'column'     : s:g.black_sp,
  "       \ 'unimportant': s:g.black_sp,
  "       \ 'cursorline' : s:g.darker
  "       \ }
  let s:k['red']     = { 'normal': s:c.light_red,     'bright': s:c.lighter_red,     'dim': s:c.dark_red }
  let s:k['green']   = { 'normal': s:c.light_green,   'bright': s:c.lighter_green,   'dim': s:c.dark_green }
  let s:k['yellow']  = { 'normal': s:c.light_yellow,  'bright': s:c.lighter_yellow,  'dim': s:c.dark_yellow }
  let s:k['blue']    = { 'normal': s:c.light_blue,    'bright': s:c.lighter_blue,    'dim': s:c.dark_blue }
  let s:k['magenta'] = { 'normal': s:c.light_magenta, 'bright': s:c.lighter_magenta, 'dim': s:c.dark_magenta }
  let s:k['cyan']    = { 'normal': s:c.light_cyan,                                   'dim': s:c.dark_cyan }
else
  " light
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
        \ 'normal'     : s:g.white_sp,
        \ 'popup'      : s:g.white,
        \ 'inactive'   : s:g.light,
        \ 'active'     : s:g.lighter,
        \ 'separator'  : s:g.lighter,
        \ 'bright'     : s:g.light,
        \ 'mid'        : s:g.gray,
        \ 'inverse'    : s:g.darkest,
        \ 'column'     : s:g.lightest,
        \ 'unimportant': s:g.lightest,
        \ 'cursorline' : s:g.lightest
        \ }
  let s:k['red']     = { 'normal': s:c.dark_red,     'bright': s:c.darker_red,     'dim': s:c.light_red }
  let s:k['green']   = { 'normal': s:c.dark_green,   'bright': s:c.darker_green,   'dim': s:c.light_green }
  let s:k['yellow']  = { 'normal': s:c.dark_yellow,  'bright': s:c.darker_yellow,  'dim': s:c.light_yellow }
  let s:k['blue']    = { 'normal': s:c.dark_blue,    'bright': s:c.darker_blue,    'dim': s:c.light_blue }
  let s:k['magenta'] = { 'normal': s:c.dark_magenta, 'bright': s:c.darker_magenta, 'dim': s:c.light_magenta }
  let s:k['cyan']    = { 'normal': s:c.dark_cyan,                                  'dim': s:c.light_cyan }
endif

" }}}


" Vanilla Colorscheme ---------------------------------------------------------
" Terminal: {{{

let g:terminal_ansi_colors = [
      \ s:c.black[0],        s:c.dark_red[0],      s:c.dark_green[0],  s:c.dark_yellow[0],
      \ s:c.dark_blue[0],    s:c.dark_magenta[0],  s:c.dark_cyan[0],   s:c.white[0],
      \ s:c.bright_black[0], s:c.light_red[0],     s:c.light_green[0], s:c.light_yellow[0],
      \ s:c.light_blue[0],   s:c.light_magenta[0], s:c.light_cyan[0],  s:c.bright_white[0]
      \ ]

if has('nvim')
  for s:tci in range(16)
    let g:terminal_color_{s:tci} = g:terminal_ansi_colors[s:tci]
  endfor
endif

" }}}
" Basic Syntax Highlightings: {{{

call s:H('Normal', s:k.fg.normal, s:k.bg.normal)
call s:L('Normal', ['Identifier', 'Constant', 'Operator', 'Special', 'Debug'])
"        *Normal
"         Identifier             any variable name
"         Constant               any constant
"         Operator               "sizeof", "+", "*", etc.
"         Special                any special symbol
"         Debug                  debugging statements

call s:H('Comment', s:k.fg.mid)
call s:L('Comment', ['SpecialComment'])
"        *Comment                any comment
"         SpecialComment         special things inside a comment

call s:H('String', s:k.green.normal)
call s:L('String', ['SpecialChar', 'Character'])
"        *String                 a string constant: "this is a string"
"         SpecialChar            special character in a constant
"         Character              a character constant: 'c', '\n'

call s:H('Boolean', s:k.blue.normal, s:none, [s:a.bold])
"         Boolean                a boolean constant: TRUE, false

call s:H('Number', s:k.blue.normal)
"        *Number                 a number constant: 234, 0xff
"         Float                  a floating point constant: 2.3e10

call s:H('Function', s:k.fg.brighter, s:none, [s:a.bold])
"        *Function               function name (also: methods for classes)

call s:H('Statement', s:k.fg.brighter, s:none, [s:a.bold])
call s:L('Statement', ['PreProc', 'Include', 'Define', 'PreCondit'])
"        *Statement              any statement
"         Conditional            if, then, else, endif, switch, etc.
"         Repeat                 for, do, while, etc.
"         Label                  case, default, etc.
"         Keyword                any other keyword
"         Exception              try, catch, throw
"         PreProc                generic Preprocessor
"         Include                preprocessor #include
"         Define                 preprocessor #define
"         PreCondit              preprocessor #if, #else, #endif, etc.

call s:H('Macro', s:k.magenta.normal, s:none, [s:a.bold])
"        *Macro                  same as Define

call s:H('Type', s:k.fg.brighter, s:none, [s:a.bold])
"        *Type                   int, long, char, etc.
"         StorageClass           static, register, volatile, etc.
"         Structure              struct, union, enum, etc.
"         Typedef                A typedef

call s:H('Tag', s:k.fg.bright, s:none, [s:a.underline, s:a.bold])
"        *Tag                    you can use CTRL-] on this

call s:H('Delimiter', s:k.fg.dim)
"         Delimiter              character that needs attention

call s:H('Todo', s:k.yellow.normal, s:none, [s:a.bold])
"        *Todo                   anything that needs extra attention; mostly
"                                the keywords TODO FIXME and XXX

call s:H('Error', s:k.red.normal)
"        *Error                  any erroneous construct

call s:H('Ignore', s:k.fg.ignore)
"        *Ignore                 left blank, hidden

call s:H('Underlined', s:none, s:none, [s:a.underline])
"        *Underlined             text that stands out, HTML links

call s:H('Added', s:k.green.dim)
"        *Added                  added line in a diff

call s:H('Changed', s:k.yellow.dim)
"        *Changed                changed line in a diff

call s:H('Removed', s:k.red.dim)
"        *Removed                removed line in a diff

" }}}
" Popup Menu: {{{

call s:H('Pmenu', s:none, s:k.bg.popup)
call s:H('PmenuSel', s:none, s:k.bg.bright)
call s:H('PmenuSbar', s:none, s:k.bg.mid)
call s:H('PmenuThumb', s:none, s:k.bg.active)
call s:H('WildMenu', s:k.fg.inverse, s:k.bg.inverse, [s:a.bold])

" }}}
" Columns: {{{

call s:H('LineNr', s:k.fg.mid, s:k.bg.column)
call s:H('CursorLineNr', s:k.fg.dim, s:k.bg.column, [s:a.bold])
call s:H('SignColumn', s:none, s:k.bg.column)
call s:L('SignColumn', ['FoldColumn'])
call s:H('ColorColumn', s:none, s:k.bg.column)

" }}}
" Cursor: {{{

call s:H('Cursor', s:k.fg.normal, s:k.bg.normal, [s:a.inverse])
call s:L('Cursor', ['lCursor', 'CursorIM'])
call s:H('CursorLine', s:none, s:k.bg.cursorline)
call s:L('CursorLine', ['CursorColumn'])

" }}}
" Status Bar: {{{

call s:H('StatusLine', s:k.fg.brighter, s:k.bg.active, [s:a.bold])
call s:H('StatusLineNC', s:k.fg.dim, s:k.bg.inactive, [s:a.italic])

" }}}
" Tab Line: {{{

call s:H('TabLine', s:k.fg.dim, s:k.bg.inactive, [s:a.italic])
call s:L('TabLine', ['TabLineFill'])
call s:H('TabLineSel', s:k.fg.brighter, s:k.bg.active, [s:a.bold])

" }}}
" Overlay: {{{

call s:H('CurSearch', s:k.fg.inverse, s:k.yellow.bright)
call s:H('Search', s:k.fg.inverse, s:c.light_yellow)
call s:L('Search', ['IncSearch'])
call s:H('Visual', s:none, s:k.bg.active)

" }}}
" NonText: {{{

call s:H('NonText', s:k.fg.dimmer)
call s:L('NonText', ['SpecialKey', 'Conceal'])

" }}}
" Editor: {{{

call s:H('WinSeparator', s:k.bg.separator)
call s:H('Folded', s:k.fg.dimmer, s:k.bg.unimportant, [s:a.italic])

" }}}
" Messages And Text: {{{

call s:H('Title', s:k.fg.brighter, s:none, [s:a.bold])
call s:H('Question', s:k.green.dim, s:none, [s:a.bold])
call s:H('ErrorMsg', s:k.fg.bright, s:k.red.dim, [s:a.bold])
call s:H('WarningMsg', s:k.red.normal)
call s:H('ModeMsg', s:none, s:none, [s:a.bold])
call s:H('MoreMsg', s:k.green.dim, s:none, [s:a.bold])
call s:H('Directory', s:c.light_cyan, s:none, [s:a.bold])

" }}}
" Spell: {{{

call s:H('SpellBad', s:k.red.normal, s:none, [s:a.undercurl])
call s:H('SpellCap', s:k.yellow.normal, s:none, [s:a.undercurl])
call s:H('SpellRare', s:k.yellow.bright, s:none, [s:a.undercurl])
call s:H('SpellLocal', s:k.yellow.bright, s:none, [s:a.underline])

" }}}
" Diff: {{{

call s:H('DiffAdd', s:k.fg.normal, s:k.green.dim)
call s:H('DiffChange', s:k.fg.normal, s:k.yellow.dim)
call s:H('DiffDelete', s:k.fg.normal, s:k.red.dim)
call s:H('DiffText', s:k.fg.inverse, s:k.yellow.bright, [s:a.underline])

" }}}
" Nvim: {{{

call s:H('NvimInternalError', s:c.darker_red, s:c.light_red)

" }}}
" FloatWindow: {{{
"
call s:H('NormalFloat', s:none, s:k.bg.popup)
"
" }}}


" Extensions ------------------------------------------------------------------
" MatchParen: {{{

call s:H('MatchParen', s:k.fg.inverse, s:k.yellow.bright)

" }}}
" Diagnostic: {{{

call s:H('DiagnosticError', s:k.red.normal)
call s:H('DiagnosticWarn', s:k.yellow.normal)
call s:H('DiagnosticInfo', s:k.cyan.normal)
call s:H('DiagnosticHint', s:k.fg.brighter)
call s:H('DiagnosticUnderlineError', s:k.red.normal, s:none, [s:a.underline])
call s:H('DiagnosticUnderlineWarn', s:k.yellow.normal, s:none, [s:a.underline])
call s:H('DiagnosticUnderlineInfo', s:k.cyan.normal, s:none, [s:a.underline])
call s:H('DiagnosticUnderlineHint', s:k.fg.brighter, s:none, [s:a.underline])

" }}}
" Sneak: {{{
call s:H('Sneak', s:g.darkest, s:k.yellow.normal)
call s:H('SneakLabel', s:g.darkest, s:k.yellow.normal)
call s:H('SneakLabelMask', s:k.yellow.normal)
" }}}


" vim: sw=2 ts=2 et fdm=marker fdls=99
