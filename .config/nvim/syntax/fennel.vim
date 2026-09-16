" Vim syntax file
" Language: FENNEL
" Original Maintainer: Calvin Rose

if exists("b:current_syntax")
	finish
endif

let s:cpo_sav = &cpo
set cpo&vim

if has("folding") && exists("g:fennel_fold") && g:fennel_fold > 0
	setlocal foldmethod=syntax
endif

syntax keyword FennelCommentTodo contained FIXME XXX TODO FIXME: XXX: TODO:

" FENNEL comments
syntax match FennelComment ";.*$" contains=FennelCommentTodo,@Spell

syntax match FennelStringEscape '\v\\%([abfnrtv'"\\]|x[[0-9a-fA-F]]\{2}|25[0-5]|2[0-4][0-9]|[0-1][0-9][0-9])' contained
syntax region FennelString matchgroup=FennelStringDelimiter start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=FennelStringEscape,@Spell

syntax keyword FennelConstant nil

syntax keyword FennelBoolean true
syntax keyword FennelBoolean false

" Fennel special forms
syntax keyword FennelSpecialForm #
syntax keyword FennelSpecialForm %
syntax keyword FennelSpecialForm *
syntax keyword FennelSpecialForm +
syntax keyword FennelSpecialForm -
syntax keyword FennelSpecialForm ->
syntax keyword FennelSpecialForm ->>
syntax keyword FennelSpecialForm -?>
syntax keyword FennelSpecialForm -?>>
syntax keyword FennelSpecialForm .
syntax keyword FennelSpecialForm ..
syntax keyword FennelSpecialForm /
syntax keyword FennelSpecialForm //
syntax keyword FennelSpecialForm :
syntax keyword FennelSpecialForm <
syntax keyword FennelSpecialForm <=
syntax keyword FennelSpecialForm =
syntax keyword FennelSpecialForm >
syntax keyword FennelSpecialForm >=
syntax keyword FennelSpecialForm ^
syntax keyword FennelSpecialForm accumulate
syntax keyword FennelSpecialForm and
syntax keyword FennelSpecialForm case
syntax keyword FennelSpecialForm case-try
syntax keyword FennelSpecialForm collect
syntax keyword FennelSpecialForm comment
syntax keyword FennelSpecialForm do
syntax keyword FennelSpecialForm doc
syntax keyword FennelSpecialForm doto
syntax keyword FennelSpecialForm each
syntax keyword FennelSpecialForm eval-compiler
syntax keyword FennelSpecialForm faccumulate
syntax keyword FennelSpecialForm fcollect
syntax keyword FennelSpecialForm fn
syntax keyword FennelSpecialForm for
syntax keyword FennelSpecialForm global
syntax keyword FennelSpecialForm hashfn
syntax keyword FennelSpecialForm icollect
syntax keyword FennelSpecialForm if
syntax keyword FennelSpecialForm import-macros
syntax keyword FennelSpecialForm include
syntax keyword FennelSpecialForm lambda conceal cchar=λ
syntax keyword FennelSpecialForm length
syntax keyword FennelSpecialForm let
syntax keyword FennelSpecialForm local
syntax keyword FennelSpecialForm lua
syntax keyword FennelSpecialForm macro
syntax keyword FennelSpecialForm macrodebug
syntax keyword FennelSpecialForm macros
syntax keyword FennelSpecialForm match
syntax keyword FennelSpecialForm match-try
syntax keyword FennelSpecialForm not
syntax keyword FennelSpecialForm not=
syntax keyword FennelSpecialForm or
syntax keyword FennelSpecialForm partial
syntax keyword FennelSpecialForm pick-args
syntax keyword FennelSpecialForm pick-values
syntax keyword FennelSpecialForm quote
syntax keyword FennelSpecialForm require-macros
syntax keyword FennelSpecialForm set
syntax keyword FennelSpecialForm set-forcibly!
syntax keyword FennelSpecialForm tset
syntax keyword FennelSpecialForm values
syntax keyword FennelSpecialForm var
syntax keyword FennelSpecialForm when
syntax keyword FennelSpecialForm while
syntax keyword FennelSpecialForm ~=
syntax keyword FennelSpecialForm with-open
syntax keyword FennelSpecialForm λ

" Lua keywords
syntax keyword LuaSpecialValue
	\ _G
	\ _VERSION
	\ assert
	\ collectgarbage
	\ dofile
	\ error
	\ getmetatable
	\ ipairs
	\ load
	\ loadfile
	\ next
	\ pairs
	\ pcall
	\ print
	\ rawequal
	\ rawget
	\ rawlen
	\ rawset
	\ require
	\ select
	\ setmetatable
	\ tonumber
	\ tostring
	\ type
	\ xpcall
	\ coroutine
	\ coroutine.create
	\ coroutine.isyieldable
	\ coroutine.resume
	\ coroutine.running
	\ coroutine.status
	\ coroutine.wrap
	\ coroutine.yield
	\ debug
	\ debug.debug
	\ debug.gethook
	\ debug.getinfo
	\ debug.getlocal
	\ debug.getmetatable
	\ debug.getregistry
	\ debug.getupvalue
	\ debug.getuservalue
	\ debug.sethook
	\ debug.setlocal
	\ debug.setmetatable
	\ debug.setupvalue
	\ debug.setuservalue
	\ debug.traceback
	\ debug.upvalueid
	\ debug.upvaluejoin
	\ io
	\ io.close
	\ io.flush
	\ io.input
	\ io.lines
	\ io.open
	\ io.output
	\ io.popen
	\ io.read
	\ io.stderr
	\ io.stdin
	\ io.stdout
	\ io.tmpfile
	\ io.type
	\ io.write
	\ math
	\ math.abs
	\ math.acos
	\ math.asin
	\ math.atan
	\ math.ceil
	\ math.cos
	\ math.deg
	\ math.exp
	\ math.floor
	\ math.fmod
	\ math.huge
	\ math.log
	\ math.max
	\ math.maxinteger
	\ math.min
	\ math.mininteger
	\ math.modf
	\ math.pi
	\ math.rad
	\ math.random
	\ math.randomseed
	\ math.sin
	\ math.sqrt
	\ math.tan
	\ math.tointeger
	\ math.type
	\ math.ult
	\ os
	\ os.clock
	\ os.date
	\ os.difftime
	\ os.execute
	\ os.exit
	\ os.getenv
	\ os.remove
	\ os.rename
	\ os.setlocale
	\ os.time
	\ os.tmpname
	\ package
	\ package.config
	\ package.cpath
	\ package.loaded
	\ package.loadlib
	\ package.path
	\ package.preload
	\ package.searchers
	\ package.searchpath
	\ string
	\ string.byte
	\ string.char
	\ string.dump
	\ string.find
	\ string.format
	\ string.gmatch
	\ string.gsub
	\ string.len
	\ string.lower
	\ string.match
	\ string.pack
	\ string.packsize
	\ string.rep
	\ string.reverse
	\ string.sub
	\ string.unpack
	\ string.upper
	\ table
	\ table.concat
	\ table.insert
	\ table.move
	\ table.pack
	\ table.remove
	\ table.sort
	\ table.unpack
	\ utf8
	\ utf8.char
	\ utf8.charpattern
	\ utf8.codepoint
	\ utf8.codes
	\ utf8.len
	\ utf8.offset

" Fennel Symbols
let s:symcharnodig = '\!\$%\&\#\*\+\-./:<=>?A-Z^_a-z|\x80-\U10FFFF'
let s:symchar = '0-9' . s:symcharnodig
execute 'syntax match FennelSymbol "\v<%([' . s:symcharnodig . '])%([' . s:symchar . '])*>"'
execute 'syntax match FennelKeyword "\v:%([' . s:symchar . '])*>"'
unlet! s:symchar s:symcharnodig

syntax match FennelQuote "`"
syntax match FennelQuote ","

" Fennel numbers
syntax match FennelNumber "\v\c<[-+]?\d*\.?\d*%([eE][-+]?\d+)?>"
syntax match FennelNumber "\v\c<[-+]?0x[0-9A-F]*\.?[0-9A-F]*>"

" Grammar root
syntax cluster FennelTop contains=@Spell,FennelComment,FennelConstant,FennelQuote,FennelKeyword,LuaSpecialValue,FennelSymbol,FennelNumber,FennelString,FennelList,FennelArray,FennelTable,FennelSpecialForm,FennelBoolean

syntax region FennelList matchgroup=FennelParen start="("  end=")" contains=@FennelTop fold
syntax region FennelArray matchgroup=FennelParen start="\[" end="]" contains=@FennelTop fold
syntax region FennelTable matchgroup=FennelParen start="{"  end="}" contains=@FennelTop fold

" Highlight superfluous closing parens, brackets and braces.
syntax match FennelError "]\|}\|)"

syntax sync fromstart

" Highlighting
hi def link FennelComment Comment
hi def link FennelSymbol Identifier
hi def link FennelNumber Number
hi def link FennelConstant Constant
hi def link FennelKeyword Keyword
hi def link FennelSpecialForm Special
hi def link LuaSpecialValue Special
hi def link FennelString String
hi def link FennelBuffer String
hi def link FennelStringDelimiter String
hi def link FennelBoolean Boolean

hi def link FennelQuote SpecialChar
hi def link FennelParen Delimiter

let b:current_syntax = "fennel"

let &cpo = s:cpo_sav
unlet! s:cpo_sav
