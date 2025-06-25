" init.vim - a minimal, separable vim/neovim rc file
"
" COMMAND:
"   :Load                       - Load a file in config home
"

if exists('g:loaded_vimrc')
	finish
endif
let g:loaded_vimrc = 1


" Section: special initialization
"    Part: vscode-nvim
if has('nvim') && exists('g:vscode')
	execute printf('source %s/init-vscode.vim', stdpath('config'))
	finish
endif


" Section: options
"    Part: modern vim
set nocompatible
set ttimeout
set ttimeoutlen=50
set display=lastline
set nostartofline
set mouse=nvi
set hlsearch
set incsearch
set smarttab
set backspace=indent,eol,start
set autoindent
set ruler
set autoread
set wildmenu
set wildoptions+=pum,tagfile
set modeline
set nofsync
set hidden

if has('multi_byte')
	set encoding=utf-8
	set fileencoding=utf-8
	set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1
endif

"    Part: window
set splitbelow
set splitright

"    Part: folding
set foldmethod=indent
set foldlevel=99
set foldlevelstart=99

"    Part: faces
set number
set list
set listchars=tab:\│\ ,extends:>,precedes:\<,trail:⋅
set cursorline
set scrolloff=1
set sidescrolloff=5
set signcolumn=yes

set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-lCursor,r-cr-o:hor20-lCursor,t:block-blinkon500-blinkoff500-TermCursor

if has('termguicolors')
	set termguicolors
	silent! colorscheme rsms
endif
if  get(g:, 'colors_name', '') ==# 'rsms'
	set cursorlineopt=number
endif

if has('syntax')
	syntax on
endif

"    Part: misc
"    REFERENCES:
"     * Cannot open file whose filename or folder name has parenthesis "(" on Windows
"     |-  https://github.com/neovim/neovim/issues/24542
"     |- `set isfname+=(,)` is work, but it will broke `helpgrep` command
"     |- `set noshellslash` is work too, but it will broke some plugin
set autoread
set autowrite
set confirm
set exrc
set nolazyredraw
set undofile
set noswapfile
set ignorecase
set smartcase
set sessionoptions-=options
set sessionoptions+=localoptions
set modeline
set laststatus=2
set updatetime=750
set title
if has('win32')
	set noshellslash
endif

"    Part: grep
if executable('rg')
	set grepprg=rg\ --vimgrep\ --no-heading\ --no-ignore-vcs\ --hidden\ --glob=!.git/
	set grepformat=%f:%l:%c:%m
endif


" Section: keymap
"    Part: Leader
nnoremap <space> <nop>
let g:mapleader = ' '

"    Part: <c-g> - as secondary leader
nnoremap <c-g> <nop>
nnoremap <c-g><c-g> <cmd>file<cr>

"    Part: window
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

"    Part: tabpage
nnoremap <c-w>t <cmd>tabnew<cr>

"    Part: buffer
nnoremap <c-w>b <cmd>enew<cr>

"    Part: cursor
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

"    Part: emacs-like keymap
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-f> <right>
inoremap <c-b> <left>
inoremap <c-n> <down>
inoremap <c-p> <up>
inoremap <m-f> <s-right>
inoremap <m-b> <s-left>

cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <m-f> <s-right>
cnoremap <m-b> <s-left>

"    Part: fallback setup
inoremap <c-x>n <c-n>
inoremap <c-x>p <c-p>
cnoremap <c-x><c-a> <c-a>
cnoremap <c-x><c-f> <c-f>

"    Part: misc
" unimpaired
nnoremap <expr> ]t '<cmd>+' . v:count1 . 'tabnext<cr>'
nnoremap <expr> [t '<cmd>-' . v:count1 . 'tabnext<cr>'

" better indenting
vnoremap < <gv
vnoremap > >gv

" terminal
function! s:open_terminal(...)
	let shell = ''
	if has('win32')
		let shell = executable('pwsh') ? 'pwsh -NoLogo' : 'powershell -NoLogo'
	endif
	if a:0 == 0
		execute printf('terminal %s', shell)
	elseif a:0 == 1 && a:1 == 'v'
		execute printf('vsplit | terminal %s', shell)
	elseif a:0 == 1 && a:1 == 's'
		execute printf('split | terminal %s', shell)
	endif
endfunction
tnoremap <esc> <c-\><c-n>
nnoremap <c-g>! <cmd>call <SID>open_terminal()<cr>
nnoremap <c-g>s! <cmd>call <SID>open_terminal('s')<cr>
nnoremap <c-g>v! <cmd>call <SID>open_terminal('v')<cr>

" replay @q macro
nnoremap Q @q

" <esc> disable highlight and redraw
nnoremap <silent> <esc> <cmd>nohlsearch<bar>diffupdate<bar>redraw<cr>


" mark search position
nnoremap / ms/
nnoremap ? ms?

" delete multiple spaces but keep one
nnoremap dz<space> ciw<space><esc>

" others
if !has('nvim')
	nnoremap Y y$
	inoremap <c-u> <c-g>u<c-u>
	inoremap <c-w> <c-g>u<c-w>
	xnoremap * y/\V<c-r>"<cr>
	xnoremap # y?\V<c-r>"<cr>
	nnoremap & :&&<cr>

	nnoremap <expr> ]b '<cmd>' . v:count1 . 'bnext<cr>'
	nnoremap <expr> [b '<cmd>' . v:count1 . 'bprevious<cr>'
	nnoremap <expr> ]q '<cmd>' . v:count1 . 'cnext<cr>'
	nnoremap <expr> [q '<cmd>' . v:count1 . 'cprevious<cr>'
	nnoremap <expr> ]l '<cmd>' . v:count1 . 'lnext<cr>'
	nnoremap <expr> [l '<cmd>' . v:count1 . 'lprevious<cr>'
endif

if has('nvim')
	nnoremap zI <cmd>Inspect<cr>
	lua vim.keymap.del('n', 'grn')
	lua vim.keymap.del('n', 'grr')
	lua vim.keymap.del('n', 'gri')
	lua vim.keymap.del('n', 'gra')
endif


" Section: Autocmd
"
augroup init
	au!

	" show cursor line only current window
	autocmd WinEnter,FocusGained * set cursorline
	autocmd WinLeave,FocusLost * set nocursorline
	
	" set nonumber for terminal mode
	" neovim defaultly disable number for terminal buffer from 0.11.0
	if has('nvim')
		autocmd TermOpen term://* startinsert
	else
		autocmd TerminalWinOpen * setlocal nonumber
	endif

	" mkdir before write file
	autocmd BufWritePre,FileWritePre *
		\ if @% !~# '\(://\)'
		\ | call mkdir(expand('<afile>:p:h'), 'p')
		\ | endif

	" disable line number for terminal buffer
	autocmd BufEnter term://*
		\ setlocal nonumber

	" filetype: help, qf, query, checkhealth
	autocmd FileType help,qf,query,checkhealth
		\ setlocal nowrap
		\ | nnoremap <buffer> q <cmd>quit<cr>

	" filetype: vimscript
	autocmd FileType vim
		\ setlocal commentstring=\"\ %s

	" autocmd for bigfile
	autocmd BufWinEnter *
		\ if getfsize(@%) > 1000000
		\ | setlocal syntax=OFF
		\ | setlocal nowrap
		\ | endif

	if has('nvim')
		autocmd FileType vim lua vim.treesitter.start()
	endif
augroup END


" COMMAND: Load
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 Load execute printf('source %s/<args>', s:home)


" Section: Builtin Plugin Options
"    Part: fnlw
"
if has('nvim')
	let g:fnlw_subdirs = ['plugin', 'ftplugin', 'lsp', 'bundle']
	silent lua vim.g.fnlw_hook_precompile = function(src) return '(require-macros :init-macros)' .. src end
	silent lua vim.g.fnlw_hook_ignorecompile = function(src) return {'fnl/init-macros.fnl'} end
	silent lua vim.g.fnlw_macro_path = {vim.fs.joinpath(vim.fn.stdpath('config'), 'fnl', 'init-macros.fnl')}
endif

"    Part: netrw
let g:netrw_banner = 0
let g:netrw_preview = 1
let g:netrw_alto = 0
let g:netrw_winsize = 40

nnoremap <expr> <c-g>e &filetype=='netrw'?"\<c-^>":"<cmd>Explore<cr>"


"    Part: editorconfig (for vim)
silent! packadd! editorconfig


" Section: Load Plugins
"
call plug#begin()
call bundle#load()
call plug#end()


" Section: Enable LSP Clients
"
if has('nvim')
	lua vim.lsp.enable({'tsserver', 'gopls', 'intelephense'})
endif
