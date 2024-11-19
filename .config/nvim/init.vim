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

if has('termguicolors')
	set termguicolors
	set background=dark
	silent! colorscheme lunaperche
	silent! colorscheme mercury
endif

if has('syntax')
	syntax on
endif

"    Part: misc
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

"    Part: grep
if executable('rg')
	set grepprg=rg\ --vimgrep\ --no-heading\ --no-ignore-vcs\ --hidden\ --glob=!.git/
	set grepformat=%f:%l:%c:%m
endif

"    Part: clipboard
if has('nvim')
	set clipboard=unnamedplus
elseif !has('nvim') && has('unnamedplus')
	set clipboard=unnamedplus
else
	set clipboard=unnamed
endif


"    Part: builtin package
"       A: netrw
let g:netrw_banner = 0

"       A: editorconfig (for vim)
silent! packadd! editorconfig


" Section: keymap
"    Part: Leader
nnoremap <space> <nop>
let g:mapleader = ' '

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
inoremap <m-f> <s-left>
inoremap <m-b> <s-right>

inoremap <expr> <c-n> pumvisible() ? "\<c-n>" : "\<down>"
inoremap <expr> <c-p> pumvisible() ? "\<c-p>" : "\<up>"

cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <m-f> <s-left>
cnoremap <m-b> <s-right>

"    Part: fallback setup
inoremap <c-x>n <c-n>
inoremap <c-x>p <c-p>
cnoremap <c-x><c-a> <c-a>
cnoremap <c-x><c-f> <c-f>

"    Part: misc
" unimpaired
nnoremap <expr> ]b '<cmd>' . v:count1 . 'bnext<cr>'
nnoremap <expr> [b '<cmd>' . v:count1 . 'bprevious<cr>'
nnoremap <expr> ]t '<cmd>+' . v:count1 . 'tabnext<cr>'
nnoremap <expr> [t '<cmd>-' . v:count1 . 'tabnext<cr>'
nnoremap <expr> [q '<cmd>' . v:count1 . 'cnext<cr>'
nnoremap <expr> ]q '<cmd>' . v:count1 . 'cprevious<cr>'

" better indenting
vnoremap < <gv
vnoremap > >gv

" terminal
tnoremap <esc> <c-\><c-n>

" replay @q macro
nnoremap Q @q

" <esc> disable highlight and redraw
nnoremap <silent> <esc> <cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>redraw<cr>

" mark search position
nnoremap / ms/
nnoremap ? ms?

" free <c-g>
nnoremap <c-g> <nop>
nnoremap <c-g><c-g> <cmd>file<cr>

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
endif

if has('nvim')
	nnoremap zI <cmd>Inspect<cr>
endif

" Section: Autocmd
"
augroup init
	au!

	" show cursor line only current window
	autocmd WinEnter,FocusGained * set cursorline
	autocmd WinLeave,FocusLost * set nocursorline
	
	" set nonumber for terminal mode
	if has('nvim')
		autocmd TermOpen * setlocal nonumber
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

	" filetype: help, qf
	autocmd FileType help,qf
		\ setlocal nowrap
		\ | nnoremap <buffer> q <cmd>quit<cr>
augroup END


" COMMAND: Load
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 Load execute printf('source %s/<args>', s:home)


" Section: Load module

silent! Load module/pkg.vim
silent! Load module/lsp.vim

if has('nvim') && exists('g:neovide')
	silent! Load module/neovide.vim
endif
