" Name:         rsms
" Description:  a port of rasmus' sublime-text colorscheme
" Author:       Junchen Du <sotvokun#outlook.com>
" License:      UNLICENSE
" Last Updated: 2025-1-23
"


if !(has('termguicolors') && &termguicolors)
	echoerr 'rsms: can not be set without termguicolors'
	finish
endif


highlight clear

let g:colors_name = 'rsms'

if empty(&background)
	set background=dark
endif


"#< Terminal Colors -----------------------------------------------------------
"
let g:terminal_ansi_colors = [
	\ '#1a1a19', '#c27770', '#70c299', '#c2a870', '#7099c2', '#c270a7', '#70c2c2', '#dedede',
	\ '#000000', '#ff1500', '#00db6e', '#ffbb00', '#0080ff', '#ff00aa', '#00ffff', '#ffffff']
for i in range(g:terminal_ansi_colors->len())
	if &background ==# 'light'
		let j = i
		if i == 0 | let j = 7
		elseif i == 7 | let j = 0
		elseif i == 8 | let j = 15
		elseif i == 15 | let j = 8
		endif
		let g:terminal_color_{i} = g:terminal_ansi_colors[j]
	else
		let g:terminal_color_{i} = g:terminal_ansi_colors[i]
	endif
endfor
"#>

"#< Quickvars -----------------------------------------------------------------
"
" - Attributes
"
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

" - NONE
"
let s:none = 'NONE'
"#>

"#< Utility Functions ---------------------------------------------------------
"
function! s:HI(group, fg, ...)
						" bg, attr_list, sp, blend
	let fg = a:fg
	let bg = get(a:, 1, s:none)
	let attr_list = filter(get(a:, 2, []), 'type(v:val) == 1')
	let attrs = len(attr_list) > 0 ? join(attr_list, ',') : 'NONE'
	let sp = get(a:, 3, v:false)
	let blend = get(a:, 4, v:false)

	let cmd = printf('highlight %s guifg=%s guibg=%s gui=%s cterm=%s', a:group, fg, bg, attrs, attrs)
	if type(sp) == 1
		let cmd .= ' guisp='.sp
	endif
	if type(blend) == 0
		let cmd .= ' blend='.blend
	endif
	execute cmd
endfunction

function! s:LI(src, dsts)
	let cmd = join(map(a:dsts, {_, val -> printf('hi! link %s %s', val, a:src)}), ' | ')
	execute cmd
endfunction

function! s:LR(dsts, src)
	let cmd = join(map(a:dsts, {_, val -> printf('hi! link %s %s', val, a:src)}), ' | ')
	execute cmd
endfunction

function! s:CL(group)
	let cmd = printf('highlight clear %s', a:group)
	execute cmd
endfunction
"#>

"#< Basic Syntax Highlightings ------------------------------------------------
"
" - backgkround: light
"
if &background ==# 'light'
	call s:HI('Comment', '#868686')

	call s:HI('Constant', '#750054')
	call s:LI('Constant', ['Number', 'Boolean', 'Float'])
	call s:HI('String', '#116432')
	call s:LI('String', ['Character'])

	call s:CL('Identifier')
	call s:HI('Function', s:none, s:none, [s:a.bold])

	call s:HI('Keyword', '#656565')
	call s:HI('Statement', '#5454a2')
	call s:LI('Statement', ['Conditional', 'Repeat', 'Label', 'Exception'])
	call s:HI('Operator', '#656565')

	call s:HI('PreProc', '#745c44')
	call s:LI('PreProc', ['Include', 'Define', 'Macro', 'PreCondit'])

	call s:HI('Type', '#334e5b')
	call s:LI('Type', ['StorageClass', 'Structure'])
	call s:HI('Typedef', '#0043a8')

	call s:HI('Special', '#333333')
	call s:LI('Special', ['SpecialChar', 'Tag', 'SpecialComment', 'Debug'])
	call s:HI('Delimiter', '#86869e')

	call s:HI('Underlined', s:none, s:none, [s:a.underline])
	call s:CL('Ignore')
	call s:HI('Error', '#000000', '#d11100', [s:a.bold])
	call s:HI('Todo', '#f06c00', s:none, [s:a.bold])

" - backgkround: dark
"
else
	call s:HI('Comment', '#6a6a69')

	call s:HI('Constant', '#94d1b3')
	call s:LI('Constant', ['String', 'Character', 'Number', 'Boolean', 'Float'])

	call s:CL('Identifier')
	call s:HI('Function', s:none, s:none, [s:a.bold])

	call s:HI('Statement', '#94b3d1')
	call s:HI('Operator', '#ffc799')

	call s:HI('PreProc', '#94b3d1')
	call s:LI('PreProc', ['Include', 'Define', 'Macro', 'PreCondit'])

	call s:HI('Type', '#94b3d1')
	call s:LI('Type', ['StorageClass', 'Structure'])
	call s:HI('Typedef', '#f7ac6e')

	call s:HI('Special', '#6c9380')
	call s:LI('Special', ['SpecialChar', 'Tag', 'SpecialComment', 'Debug'])
	call s:HI('Delimiter', '#767675')

	call s:HI('Underlined', s:none, s:none, [s:a.underline])
	call s:CL('Ignore')
	call s:HI('Error', '#000000', '#d11100', [s:a.bold])
	call s:HI('Todo', '#f06c00', s:none, [s:a.bold])
endif

call s:HI('Added', '#007f40')
call s:HI('Changed', '#d68800')
call s:HI('Removed', '#d11100')

"#>

"#< Basic Interface Highlightings ---------------------------------------------
"
" - background: light
"
if &background ==# 'light'
	call s:HI('Normal', '#000000', '#fdfdfc')
	call s:HI('NormalNC', s:none, '#f8f8f7')
	call s:HI('Cursor', '#ffffff', '#0044ff')
	call s:HI('Visual', s:none, '#d2ecfe')
	call s:HI('VisualNOS', s:none, '#e8f5fd')
	call s:HI('LineNr', '#cccccc')
	call s:HI('SignColumn', s:none, s:none)
	call s:HI('CursorLine', s:none, '#fefeae')
	call s:HI('CursorLineNr', '#000000', '#fefeae')
	call s:HI('CursorLineSign', s:none, '#fefeae')
	call s:HI('CurSearch', '#000000', '#ffe642')
	call s:HI('Search', '#403910', '#fef7ce')
	call s:HI('MatchParen', '#0044ff', s:none, [s:a.bold])
	call s:HI('NonText', '#eeeeed')
	call s:HI('ColorColumn', s:none, '#eeeeed')
	call s:HI('Conceal', '#7e7e7e')
	call s:HI('TermCursor', '#fdfdfc', '#000000')
	call s:HI('Folded', '#7e7e7e', '#eeeeed')

	call s:HI('Directory', '#678fff')

	call s:HI('StatusLine', s:none, '#cfcfcf')
	call s:HI('StatusLineNC', '#7e7e7e', '#e4e4e3')
	call s:HI('TabLine', s:none, '#e4e4e3')
	call s:HI('TabLineSel', '#000000', '#ffffff')

	call s:HI('NormalFloat', '#000000', '#f0f0ef')
	call s:HI('Pmenu', s:none, '#f0f0ef')
	call s:HI('PmenuSel', s:none, '#cccccc')
	call s:HI('PmenuSbar', s:none, '#d8d8d7')
	call s:HI('PmenuThumb', s:none, '#acacac')

	call s:HI('DiffAdd', s:none, '#a4f1ca')
	call s:HI('DiffChange', s:none, '#feefab')
	call s:HI('DiffDelete', '#febcb6', s:none, [s:a.bold])
	call s:HI('DiffText', s:none, '#fed7b6')

" - background: dark
"
else
	call s:HI('Normal', '#dedede', '#1a1a19')
	call s:HI('NormalNC', s:none, '#171717')
	call s:HI('Cursor', '#000000', '#f76ec9')
	call s:HI('Visual', s:none, '#314c5e')
	call s:HI('VisualNOS', s:none, '#484847')
	call s:HI('LineNr', '#555554')
	call s:HI('SignColumn', s:none, s:none)
	call s:HI('CursorLine', s:none, '#353535')
	call s:HI('CursorLineNr', '#dedede', '#353535')
	call s:HI('CursorLineSign', s:none, '#353535')
	call s:HI('CurSearch', '#000000', '#ffff00')
	call s:HI('Search', '#e6e6a7', '#535313')
	call s:HI('MatchParen', '#f76ec9', s:none, [s:a.bold])
	call s:HI('NonText', '#282827')
	call s:HI('ColorColumn', s:none, '#282827')
	call s:HI('Conceal', '#8c8c8c')
	call s:HI('TermCursor', '#1a1a19', '#dedede')
	call s:HI('Folded', '#8c8c8c', '#282827')

	call s:HI('Directory', '#faa9de')

	call s:HI('StatusLine', s:none, '#0d0d0d')
	call s:HI('StatusLineNC', '#8c8c8c', '#000000')
	call s:HI('TabLine', s:none, '#000000')
	call s:HI('TabLineFill', s:none, '#000000')
	call s:HI('TabLineSel', '#ffffff', '#1a1a19')

	call s:HI('NormalFloat', '#dedede', '#252525')
	call s:HI('Pmenu', s:none, '#262625')
	call s:HI('PmenuSel', s:none, '#515151')
	call s:HI('PmenuSbar', s:none, '#3b3b3a')
	call s:HI('PmenuThumb', s:none, '#626261')

	call s:HI('DiffAdd', s:none, '#115e37')
	call s:HI('DiffChange', s:none, '#6a5b18')
	call s:HI('DiffDelete', '#6a2922', s:none, [s:a.bold])
	call s:HI('DiffText', s:none, '#6a4322')
endif

" - common setup
"
call s:LI('Cursor', ['lCursor', 'CursorIM'])
call s:LI('LineNr', ['LineNrAbove', 'LineNrBelow'])
call s:LI('SignColumn', ['FoldColumn'])
call s:LI('CursorLine', ['CursorColumn'])
call s:LI('CursorLineSign', ['CursorLineFold'])
call s:LI('CurSearch', ['IncSearch', 'QuickFixLine'])
call s:LI('Search', ['Substitute'])
call s:LI('NonText', ['EndOfBuffer', 'Whitespace', 'SpecialKey', 'WinSeparator', 'SnippetTabstop'])
call s:LI('StatusLine', ['MsgSeparator', 'StatusLineTerm', 'WinBar'])
call s:LI('StatusLineNC', ['StatusLineTermNC', 'WinBarNC'])
call s:LI('TabLine', ['TabLineFill'])
call s:LI('NormalFloat', ['FloatBorder'])
call s:LI('Title', ['FloatTitle', 'FloatFooter'])
call s:LI('Pmenu', ['PmenuKind', 'PmenuExtra'])
call s:LI('PmenuSel', ['PmenuKindSel', 'PmenuExtraSel', 'WildMenu'])
call s:HI('PmenuMatch', s:none, s:none, [s:a.bold])
call s:LI('PmenuMatch', ['PmenuMatchSel'])
call s:CL('ComplMatchIns')

call s:HI('Title', s:none, s:none, [s:a.bold])

call s:HI('WarningMsg', '#e5cf00', s:none, [s:a.bold])
call s:HI('ErrorMsg', '#d11100', s:none, [s:a.bold])
call s:HI('ModeMsg', '#000000', '#f06c00', [s:a.bold])
call s:HI('MoreMsg', '#008945', s:none, [s:a.bold])
call s:LI('MoreMsg', ['Question'])
call s:CL('MsgArea')

call s:HI('SpellBad', s:none, s:none, [s:a.undercurl], '#d11100')
call s:HI('SpellCap', s:none, s:none, [s:a.undercurl], '#f06c00')
call s:HI('SpellLocal', s:none, s:none, [s:a.undercurl], '#d600c4')
call s:HI('SpellRare', s:none, s:none, [s:a.undercurl], '#0080ff')
"#>

"#< Builtin Plugin ------------------------------------------------------------
"
" - netrw
	call s:LR(['netrwTreeBar', 'netrwClassify'], 'NonText')

"#>

"#< Thirdparty Plugins --------------------------------------------------------
"
" - vim-gitgutter
call s:LR(['GitGutterAdd', 'diffAdded'], 'Added')
call s:LR(['GitGutterChange', 'diffChanged'], 'Changed')
call s:LR(['GitGutterDelete', 'diffRemoved'], 'Removed')

"#>

" vim: cc=80,100 ts=4 sw=4 foldmethod=marker foldlevelstart=99 foldmarker=#<,#>
