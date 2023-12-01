" Name:         neosolarized: colorscheme for neovim and truecolor
" Author:       Sotvokun <sotvokun@outlook.com>
" License:      UNLICENSED

hi clear

if exists('syntax_on')
        syntax reset
endif

let colors_name = "neosolarized"

" Color palette {{{
" ------------------------------------------------

" GUI
let s:gui_base04  = "#00262f"   " Darkest (non-std)
let s:gui_base03  = "#002b36"   " Darker
let s:gui_base02  = "#073642"   " Dark
let s:gui_base01  = "#586e75"
let s:gui_base00  = "#657b83"
let s:gui_base0   = "#839496"
let s:gui_base1   = "#93a1a1"
let s:gui_base2   = "#eee8d5"   " Bright
let s:gui_base3   = "#fdf6e3"   " Brighter
let s:gui_base4   = "#fefbf0"   " Brightest (non-std)
let s:gui_yellow  = "#b58900"
let s:gui_orange  = "#cb4b16"
let s:gui_red     = "#dc322f"
let s:gui_magenta = "#d33682"
let s:gui_violet  = "#6c71c4"
let s:gui_blue    = "#268bd2"
let s:gui_cyan    = "#2aa198"
let s:gui_green   = "#859900"
let s:gui_none    = "NONE"

" Term
let s:term_base04  = "8"
let s:term_base03  = "8"
let s:term_base02  = "0"
let s:term_base01  = "10"
let s:term_base00  = "11"
let s:term_base0   = "12"
let s:term_base1   = "14"
let s:term_base2   = "7"
let s:term_base3   = "15"
let s:term_base4   = "15"
let s:term_yellow  = "3"
let s:term_orange  = "9"
let s:term_red     = "1"
let s:term_magenta = "5"
let s:term_violet  = "13"
let s:term_blue    = "4"
let s:term_cyan    = "6"
let s:term_green   = "2"
let s:term_none    = "NONE"

let s:bg_none    = " guibg=" . s:gui_none    . " ctermbg=" . s:term_none
let s:bg_base04  = " guibg=" . s:gui_base04  . " ctermbg=" . s:term_base04
let s:bg_base03  = " guibg=" . s:gui_base03  . " ctermbg=" . s:term_base03
let s:bg_base02  = " guibg=" . s:gui_base02  . " ctermbg=" . s:term_base02
let s:bg_base01  = " guibg=" . s:gui_base01  . " ctermbg=" . s:term_base01
let s:bg_base00  = " guibg=" . s:gui_base00  . " ctermbg=" . s:term_base00
let s:bg_base0   = " guibg=" . s:gui_base0   . " ctermbg=" . s:term_base0
let s:bg_base1   = " guibg=" . s:gui_base1   . " ctermbg=" . s:term_base1
let s:bg_base2   = " guibg=" . s:gui_base2   . " ctermbg=" . s:term_base2
let s:bg_base3   = " guibg=" . s:gui_base3   . " ctermbg=" . s:term_base3
let s:bg_base4   = " guibg=" . s:gui_base4   . " ctermbg=" . s:term_base4
let s:bg_yellow  = " guibg=" . s:gui_yellow  . " ctermbg=" . s:term_yellow
let s:bg_orange  = " guibg=" . s:gui_orange  . " ctermbg=" . s:term_orange
let s:bg_red     = " guibg=" . s:gui_red     . " ctermbg=" . s:term_red
let s:bg_magenta = " guibg=" . s:gui_magenta . " ctermbg=" . s:term_magenta
let s:bg_violet  = " guibg=" . s:gui_violet  . " ctermbg=" . s:term_violet
let s:bg_blue    = " guibg=" . s:gui_blue    . " ctermbg=" . s:term_blue
let s:bg_cyan    = " guibg=" . s:gui_cyan    . " ctermbg=" . s:term_cyan
let s:bg_green   = " guibg=" . s:gui_green   . " ctermbg=" . s:term_green

let s:fg_none    = " guifg=" . s:gui_none    . " ctermfg=" . s:term_none
let s:fg_base04  = " guifg=" . s:gui_base04  . " ctermfg=" . s:term_base04
let s:fg_base03  = " guifg=" . s:gui_base03  . " ctermfg=" . s:term_base03
let s:fg_base02  = " guifg=" . s:gui_base02  . " ctermfg=" . s:term_base02
let s:fg_base01  = " guifg=" . s:gui_base01  . " ctermfg=" . s:term_base01
let s:fg_base00  = " guifg=" . s:gui_base00  . " ctermfg=" . s:term_base00
let s:fg_base0   = " guifg=" . s:gui_base0   . " ctermfg=" . s:term_base0
let s:fg_base1   = " guifg=" . s:gui_base1   . " ctermfg=" . s:term_base1
let s:fg_base2   = " guifg=" . s:gui_base2   . " ctermfg=" . s:term_base2
let s:fg_base3   = " guifg=" . s:gui_base3   . " ctermfg=" . s:term_base3
let s:fg_base4   = " guifg=" . s:gui_base4   . " ctermfg=" . s:term_base4
let s:fg_yellow  = " guifg=" . s:gui_yellow  . " ctermfg=" . s:term_yellow
let s:fg_orange  = " guifg=" . s:gui_orange  . " ctermfg=" . s:term_orange
let s:fg_red     = " guifg=" . s:gui_red     . " ctermfg=" . s:term_red
let s:fg_magenta = " guifg=" . s:gui_magenta . " ctermfg=" . s:term_magenta
let s:fg_violet  = " guifg=" . s:gui_violet  . " ctermfg=" . s:term_violet
let s:fg_blue    = " guifg=" . s:gui_blue    . " ctermfg=" . s:term_blue
let s:fg_cyan    = " guifg=" . s:gui_cyan    . " ctermfg=" . s:term_cyan
let s:fg_green   = " guifg=" . s:gui_green   . " ctermfg=" . s:term_green

let s:attr_none   = " gui="   . "NONE"          . " cterm=" . "NONE"
let s:attr_bold   = " gui="   . "bold"          . " cterm=" . "bold"
let s:attr_italic = " gui="   . "italic"        . " cterm=" . "italic"
let s:attr_underl = " gui="   . "underline"     . " cterm=" . "underline"
let s:attr_undero = " gui="   . "undercurl"     . " cterm=" . "undercurl"
let s:attr_rever  = " gui="   . "reverse"       . " cterm=" . "reverse"
let s:attr_strik  = " gui="   . "strikethrough" . " cterm=" . "strikethrough"
let s:attr_reverb = " gui="   . "reverse,bold"  . " cterm=" . "reverse,bold"
let s:attr_underlb= " gui="   . "underline,bold". " cterm=" . "underline,bold"

let s:sp_none    = " guisp=" . s:gui_none
let s:sp_base04  = " guisp=" . s:gui_base04
let s:sp_base03  = " guisp=" . s:gui_base03
let s:sp_base02  = " guisp=" . s:gui_base02
let s:sp_base01  = " guisp=" . s:gui_base01
let s:sp_base00  = " guisp=" . s:gui_base00
let s:sp_base0   = " guisp=" . s:gui_base0
let s:sp_base1   = " guisp=" . s:gui_base1
let s:sp_base2   = " guisp=" . s:gui_base2
let s:sp_base3   = " guisp=" . s:gui_base3
let s:sp_base4   = " guisp=" . s:gui_base4
let s:sp_yellow  = " guisp=" . s:gui_yellow
let s:sp_orange  = " guisp=" . s:gui_orange
let s:sp_red     = " guisp=" . s:gui_red
let s:sp_magenta = " guisp=" . s:gui_magenta
let s:sp_violet  = " guisp=" . s:gui_violet
let s:sp_blue    = " guisp=" . s:gui_blue
let s:sp_cyan    = " guisp=" . s:gui_cyan
let s:sp_green   = " guisp=" . s:gui_green

if &background == "dark"
        let s:bg_dim      = s:bg_base04
        let s:bg          = s:bg_base03
        let s:bg_hl       = s:bg_base02

        let s:fg_dim      = s:fg_base01
        let s:fg          = s:fg_base0
        let s:fg_emphasis = s:fg_base1
else
        let s:bg_dim      = s:bg_base4
        let s:bg          = s:bg_base3
        let s:bg_hl       = s:bg_base2

        let s:fg_dim      = s:fg_base1
        let s:fg          = s:fg_base00
        let s:fg_emphasis = s:fg_base01
endif

" }}}

" Basic Syntax highlightings {{{
" ------------------------------------------------
exe "hi! Normal"                . s:attr_none   . s:fg         . s:bg

exe "hi! Comment"               . s:attr_italic . s:fg_dim     . s:bg_none
"       *Comment                any comment

exe "hi! Constant"              . s:attr_none   . s:fg_cyan    . s:bg_none
"       *Constant               any constant
"        String                 a string constant: "this is a string"
"        Character              a character constant: 'c', '\n'
"        Boolean                a boolean constant: TRUE, false

exe "hi! Number"                . s:attr_none   . s:fg_magenta . s:bg_none
"       *Number                 a number constant: 234, 0xff
"        Float                  a floating point constant: 2.3e10

exe "hi! Identifier"            . s:attr_none   . s:fg_blue    . s:bg_none
"       *Identifier             any variable name
"        Function               function name (also: methods for classes)

exe "hi! Statement"             . s:attr_none   . s:fg_green   . s:bg_none
"       *Statement              any statement
"        Conditional            if, then, else, endif, switch, etc.
"        Repeat                 for, do, while, etc.
"        Label                  case, default, etc.
"        Operator               "sizeof", "+", "*", etc.
"        Keyword                any other keyword
"        Exception              try, catch, throw

exe "hi! PreProc"               . s:attr_none   . s:fg_orange  . s:bg_none
"       *PreProc                generic Preprocessor
"        Include                preprocessor #include
"        Define                 preprocessor #define
"        Macro                  same as Define
"        PreCondit              preprocessor #if, #else, #endif, etc.

exe "hi! Type"                  . s:attr_none   . s:fg_yellow  . s:bg_none
"       *Type                   int, long, char, etc.
"        StorageClass           static, register, volatile, etc.
"        Structure              struct, union, enum, etc.
"        Typedef                A typedef

exe "hi! Special"               . s:attr_none   . s:fg_red     . s:bg_none
"       *Special                any special symbol
"        SpecialChar            special character in a constant
"        Tag                    you can use CTRL-] on this
"        Delimiter              character that needs attention
"        SpecialComment         special things inside a comment
"        Debug                  debugging statements

exe "hi! Underlined"            . s:attr_underl . s:fg_violet  . s:bg_none
"       *Underlined             text that stands out, HTML links

exe "hi! Ignore"                . s:attr_none   . s:fg_none    . s:bg_none
"       *Ignore                 left blank, hidden

exe "hi! Error"                 . s:attr_bold   . s:fg_red     . s:bg_none
"       *Error                  any erroneous construct

exe "hi! Todo"                  . s:attr_bold   . s:fg_magenta . s:bg_none
"       *Todo                   anything that needs extra attention; mostly the
"                               keywords TODO FIXME and XXX

" }}}

" Basic UI highlightings {{{
" ------------------------------------------------

exe "hi! NonText"               . s:attr_none   . s:fg_dim     . s:bg_none
exe "hi! SpecialKey"            . s:attr_none   . s:fg_dim     . s:bg_none
exe "hi! VertSplit"             . s:attr_none   . s:fg_dim     . s:bg_none
exe "hi! Title"                 . s:attr_none   . s:fg_orange  . s:bg_none
exe "hi! Directory"             . s:attr_none   . s:fg_blue    . s:bg_none

exe "hi! Search"                . s:attr_reverb . s:fg_yellow  . s:bg_none
exe "hi! IncSearch"             . s:attr_reverb . s:fg_orange  . s:bg_none

exe "hi! ErrorMsg"              . s:attr_reverb . s:fg_red     . s:bg_none
exe "hi! WarningMsg"            . s:attr_bold   . s:fg_red     . s:bg_none
exe "hi! MoreMsg"               . s:attr_none   . s:fg_blue    . s:bg_none
exe "hi! ModeMsg"               . s:attr_none   . s:fg_blue    . s:bg_none
exe "hi! Question"              . s:attr_bold   . s:fg_cyan    . s:bg_none

exe "hi! TabLine"               . s:attr_rever  . s:fg_dim     . s:bg_hl
exe "hi! TabLineFill"           . s:attr_none   . s:fg         . s:bg_hl
exe "hi! TabLineSel"            . s:attr_bold   . s:fg_emphasis. s:bg
exe "hi! StatusLine"            . s:attr_bold   . s:fg_emphasis. s:bg_hl
exe "hi! StatusLineNC"          . s:attr_italic . s:fg_dim     . s:bg_dim
exe "hi! LineNr"                . s:attr_none   . s:fg_dim     . s:bg_hl

exe "hi! Pmenu"                 . s:attr_none   . s:fg         . s:bg_dim
exe "hi! PmenuSel"              . s:attr_none   . s:fg         . s:bg_hl
exe "hi! PmenuSbar"             . s:attr_none   . s:fg_none    . s:bg_dim
exe "hi! PmenuThumb"            . s:attr_none   . s:fg_none    . s:bg_hl
exe "hi! WildMenu"              . s:attr_none   . s:fg         . s:bg

exe "hi! Visual"                . s:attr_rever  . s:fg_dim     . s:bg
exe "hi! VisualNOS"             . s:attr_rever  . s:fg_dim     . s:bg_hl

exe "hi! Folded"                . s:attr_none   . s:fg_dim     . s:bg_hl
exe "hi! FoldColumn"            . s:attr_none   . s:fg_dim     . s:bg_hl

exe "hi! CursorColumn"          . s:attr_none   . s:fg_none    . s:bg_hl
exe "hi! CursorLine"            . s:attr_none   . s:fg_none    . s:bg_hl
exe "hi! CursorLineNr"          . s:attr_none   . s:fg_none    . s:bg_hl
exe "hi! Cursor"                . s:attr_none   . s:fg_none    . s:bg_red
exe "hi! ColorColumn"           . s:attr_none   . s:fg_none    . s:bg_hl
exe "hi! SignColumn"            . s:attr_none   . s:fg         . s:bg_none
exe "hi! link lCursor Cursor"

exe "hi! MatchParen"            . s:attr_bold   . s:fg_red     . s:bg_hl

exe "hi! DiffAdd"               . s:attr_none   . s:fg_green   . s:bg_none . s:sp_green
exe "hi! DiffChange"            . s:attr_none   . s:fg_yellow  . s:bg_none . s:sp_yellow
exe "hi! DiffDelete"            . s:attr_none   . s:fg_red     . s:bg_none . s:sp_red
exe "hi! DiffText"              . s:attr_none   . s:fg_blue    . s:bg_none . s:sp_blue

exe "hi! SpellBad"              . s:attr_undero . s:fg_none    . s:bg_none . s:sp_red
exe "hi! SpellCap"              . s:attr_undero . s:fg_none    . s:bg_none . s:sp_violet
exe "hi! SpellLocal"            . s:attr_undero . s:fg_none    . s:bg_none . s:sp_yellow
exe "hi! SpellRare"             . s:attr_undero . s:fg_none    . s:bg_none . s:sp_cyan

exe "hi! link NormalFloat Pmenu"
exe "hi! FloatBorder"           . s:attr_none   . s:fg_dim     . s:bg_dim

" }}}

" Diagnostic highlightings {{{
" ------------------------------------------------
exe "hi! DiagnosticUnnecessary"         . s:attr_underl . s:fg_dim     . s:bg_none
" }}}

" Terminal colors {{{
" ------------------------------------------------

let g:terminal_color_0 = s:gui_base03
let g:terminal_color_1 = s:gui_red
let g:terminal_color_2 = s:gui_green
let g:terminal_color_3 = s:gui_yellow
let g:terminal_color_4 = s:gui_blue
let g:terminal_color_5 = s:gui_magenta
let g:terminal_color_6 = s:gui_cyan
let g:terminal_color_7 = s:gui_base2

" }}}

" Language specific highlightings {{{
" ------------------------------------------------

" Common
exe "hi! NeosolarizedParen"     . s:attr_none   . s:fg         . s:bg_none
exe "hi! NeosolarizedKeyword"   . s:attr_bold   . s:fg_emphasis. s:bg_none
exe "hi! NeosolarizedIdentifier". s:attr_none   . s:fg_blue    . s:bg_none

" fennel
exe "hi! link FennelParen NeosolarizedParen"
exe "hi! link FennelSpecialForm NeosolarizedKeyword"
exe "hi! link LuaSpecialValue NeosolarizedKeyword"

" vim
exe "hi! link vimSep NeosolarizedParen"
exe "hi! link vimParenSep NeosolarizedParen"
exe "hi! vimContinue"           . s:attr_none   . s:fg_dim     . s:bg_none
exe "hi! link vimUserFunc NONE"

" lua
exe "hi! link luaFunction NeosolarizedKeyword"

" javascript
exe "hi! link javaScriptBraces NeosolarizedParen"
exe "hi! link javaScriptIdentifier NeosolarizedKeyword"
exe "hi! link javaScriptFunction NeosolarizedKeyword"

exe "hi! @include.javascript"   . s:attr_none   . s:fg_green   . s:bg_none

exe "hi! link @constant.javascript NeosolarizedIdentifier"

exe "hi! link @parameter.javascript NONE"

exe "hi! javaScript.ext.SecondaryKeyword"
                        \       . s:attr_bold   . s:fg_green   . s:bg_none
exe "hi! link @keyword.return.javascript javaScript.ext.SecondaryKeyword"
exe "hi! link @keyword.operator.javascript javaScript.ext.SecondaryKeyword"

exe "hi! link @type.javascript NeosolarizedIdentifier"

exe "hi! link @tag.javascript NeosolarizedIdentifier"
exe "hi! link @tag.delimiter.javascript htmlTag"
exe "hi! link @tag.attribute.javascript htmlArg"

" typescript
exe "hi! link typescriptVariable NeosolarizedKeyword"
exe "hi! link typescriptFuncKeyword NeosolarizedKeyword"
exe "hi! link typescriptParens NeosolarizedParen"
exe "hi! link typescriptBraces NeosolarizedParen"
exe "hi! link typescriptImport Operator"
exe "hi! link typescriptExport Operator"
exe "hi! link typescriptTernaryOp Operator"
exe "hi! typescriptBoolean"     . s:attr_none   . s:fg_yellow  . s:bg_none
exe "hi! link typescriptIdentifierName NeosolarizedIdentifier"
exe "hi! link typescriptVariableDeclaration NeosolarizedIdentifier"
exe "hi! link typescriptTypeReference Type"
exe "hi! link typescriptArrowFunc NONE"
exe "hi! link typescriptObjectLabel NONE"
exe "hi! link typescriptAsyncFuncKeyword NeosolarizedKeyword"

" sql
exe "hi! link sqlKeyword Statement"
exe "hi! link sqlType NeosolarizedKeyword"

" php
exe "hi! link phpDefine NeosolarizedKeyword"
exe "hi! link phpParent NeosolarizedParen"
exe "hi! link phpStructure NeosolarizedKeyword"
exe "hi! link phpStorageClass NeosolarizedKeyword"
exe "hi! link phpMemberSelector Operator"
exe "hi! phpBoolean"            . s:attr_none   . s:fg_magenta . s:bg_none

" json
exe "hi! link jsonBraces NeosolarizedParen"
exe "hi! link jsonQuote NeosolarizedParen"

" yaml
exe "hi! link yamlKeyValueDelimiter NONE"
exe "hi! yamlBool"              . s:attr_none   . s:fg_yellow  . s:bg_none

" html
exe "hi! htmlTag"               . s:attr_none   . s:fg_dim     . s:bg_none
exe "hi! link htmlEndTag htmlTag"
exe "hi! htmlTagName"           . s:attr_none   . s:fg_blue    . s:bg_none
exe "hi! link htmlSpecialTagName htmlTagName"
exe "hi! link htmlTagN htmlTagName"
exe "hi! link htmlArg NONE"
exe "hi! link javaScript NONE"

" vue
exe "hi! link @tag.vue NeosolarizedIdentifier"
exe "hi! link @tag.delimiter.vue htmlTag"
exe "hi! link @tag.attribute.vue htmlArg"
exe "hi! link @method.vue @tag.attribute.vue"

" css
exe "hi! link cssBraces NeosolarizedParen"
exe "hi! link cssAtRule NeosolarizedParen"
exe "hi! link cssElementName NONE"
exe "hi! link cssClassName cssElementName"
exe "hi! link cssClassNameDot cssElementName"
exe "hi! link cssIdentifier cssElementName"
exe "hi! cssTagName"            . s:attr_none   . s:fg_blue    . s:bg_none
exe "hi! link cssUnitDecorators Operator"
exe "hi! link cssSelectorOp NONE"
exe "hi! link cssAttrComma NONE"
exe "hi! link cssAttributeSelector cssElementName"
exe "hi! cssMediaType"          . s:attr_none   . s:fg_blue    . s:bg_none
exe "hi! @punctuation.delimiter.css"
                        \       . s:attr_bold   . s:fg         . s:bg_none
" exe "hi! link @property.css @punctuation.delimiter.css"

" editorconfig
exe "hi! dosiniHeader"          . s:attr_bold   . s:fg_orange  . s:bg_none
exe "hi! editorconfigProperty"  . s:attr_none   . s:fg_green   . s:bg_none

" cmake
exe "hi! link cmakeCommand Statement"
exe "hi! link cmakeVariable NONE"
exe "hi! cmakeVariableValue"    . s:attr_bold   . s:fg         . s:bg_none
exe "hi! cmakeGeneratorExpressions"
                        \       . s:attr_none   . s:fg_blue    . s:bg_none

" }}}

" Tree-sitter highlightings {{{
" ------------------------------------------------
exe "hi! link @punctuation NONE"
exe "hi! link @keyword NeosolarizedKeyword"
" }}}

" Extensions highlightings {{{
" ------------------------------------------------
" git
exe "hi! gitDiff"               . s:attr_none   . s:fg_dim       . s:bg_none
exe "hi! gitKeyword"            . s:attr_bold   . s:fg_emphasis  . s:bg_none
exe "hi! link gitIdentityKeyword gitKeyword"
exe "hi! gitHash"               . s:attr_none   . s:fg_blue      . s:bg_none
exe "hi! gitIdentity"           . s:attr_underlb. s:fg           . s:bg_none
exe "hi! gitEmail"              . s:attr_underl . s:fg           . s:bg_none
exe "hi! link gitEmailDelimiter gitEmail"
exe "hi! gitDate"               . s:attr_none   . s:fg_dim       . s:bg_none

" diff
exe "hi! diffFile"              . s:attr_reverb . s:fg           . s:bg_hl
exe "hi! link diffAdded DiffAdd"
exe "hi! diffOldFile"           . s:attr_bold   . s:fg_dim       . s:bg_none
exe "hi! diffNewFile"           . s:attr_bold   . s:fg           . s:bg_none
exe "hi! diffIndexLine"         . s:attr_none   . s:fg_blue      . s:bg_none
exe "hi! diffLine"              . s:attr_bold   . s:fg_orange    . s:bg_none
exe "hi! diffSubname"           . s:attr_none   . s:fg           . s:bg_none

" fugitive
exe "hi! link fugitiveHeader gitKeyword"
exe "hi! link fugitiveHeading fugitiveHeader"
exe "hi! link fugitiveStagedHeading fugitiveHeader"
exe "hi! link fugitiveUnstagedHeading fugitiveHeader"
exe "hi! link fugitiveUntrackedHeading fugitiveHeader"
exe "hi! fugitiveHelpTag"       . s:attr_none  . s:fg_dim       . s:bg
exe "hi! fugitiveSymbolicRef"   . s:attr_none  . s:fg_cyan      . s:bg_none

" statusline
exe "hi! StatusLineModeVisual"  . s:attr_reverb. s:fg           . s:bg_hl
exe "hi! StatusLineModeInsert"  . s:attr_reverb. s:fg_orange    . s:bg_hl
exe "hi! StatusLineModeReplace" . s:attr_reverb. s:fg_orange    . s:bg_hl
exe "hi! StatusLineModeCommand" . s:attr_reverb. s:fg_red       . s:bg_hl
exe "hi! StatusLineModeShell"   . s:attr_reverb. s:fg_red       . s:bg_hl
exe "hi! StatusLineModeTerminal". s:attr_reverb. s:fg_blue      . s:bg_hl

" vim-sneak
exe "hi! Sneak"                 . s:attr_reverb. s:fg_magenta   . s:bg_hl
exe "hi! SneakLabel"            . s:attr_reverb. s:fg_magenta   . s:bg_hl
exe "hi! link SneakLabelMask Normal"
exe "hi! SneakLabelMask"        . s:attr_none  . s:fg_none      . s:bg_none

" floaterm
exe "hi! link Floaterm Normal"
exe "hi! Floaterm"              . s:attr_none  . s:fg           . s:bg_dim
exe "hi! link FloatermNC Floaterm"

" copilot
exe "hi! link CopilotSuggestion Comment"

" fern
exe "hi! FernRootText"          . s:attr_bold  . s:fg_magenta   . s:bg_none
exe "hi! FernRootSymbol"        . s:attr_bold  . s:fg_magenta   . s:bg_none

exe "hi! link FernLeafSymbol NonText"

" IndentMini
exe "hi! link IndentLine Comment"

" }}}

" vim: foldmethod=marker foldlevel=0 expandtab
