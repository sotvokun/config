" .vimrc - a minimal vim/neovim rc file
"
" This file provides a minimal vim/neovim configuration. It has several ways to
" use it with vim and neovim.
"
" For Vim:
"    Copy this file in your *.vimrc* path, it will work well
"
" For Neovim:
"    Use command `nvim --cmd "$HOME/.vimrc", it will copy itself into
"    `$HOME/.config/nvim/mod/preference.vim`. Add a source in neovim configuration
"    to make neovim setup the following settings
"

if exists('g:loaded_vimrc')
	finish
endif
let g:loaded_vimrc = 1

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

if has('termguicolors')
	set termguicolors
	set background=dark
	silent! colorscheme darkblue
	silent! colorscheme lunaperche
else
	silent! colorscheme habamax
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


" Section: keymap
"    Part: window
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

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

"    Part: unimpaired
nnoremap <expr> ]b '<cmd>' . v:count1 . 'bnext<cr>'
nnoremap <expr> [b '<cmd>' . v:count1 . 'bprevious<cr>'
nnoremap <expr> ]t '<cmd>+' . v:count1 . 'tabnext<cr>'
nnoremap <expr> [t '<cmd>-' . v:count1 . 'tabnext<cr>'
nnoremap <expr> [q '<cmd>' . v:count1 . 'cnext<cr>'
nnoremap <expr> ]q '<cmd>' . v:count1 . 'cprevious<cr>'

"    Part: better indenting
vnoremap < <gv
vnoremap > >gv

"    Part: misc

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

" neovim compatible
nnoremap Y y$
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
xnoremap * y/\V<c-r>"<cr>
xnoremap # y?\V<c-r>"<cr>
nnoremap & :&&<cr>


" Section: Autocmd
augroup init
	au!

	" show cursor line only current window
	autocmd WinEnter,FocusGained * set cursorline
	autocmd WinLeave,FocusLost * set nocursorline

	" mkdir before write file
	autocmd BufWritePre,FileWritePre *
		\ if @% !~# '\(://\)'
		\ | call mkdir(expand('<afile>:p:h'), 'p')
		\ | endif
augroup END


" Section: netrw
let g:netrw_banner=0


" Section: built-in packages
silent! packadd! editorconfig


" Section: Advanced
"    Part: 1. make current vimrc file as a module for neovim configuration
"          2. neovim does not need the following settings
let s:nvim_cfg_path = $HOME . '/.config/nvim'
if has('nvim')
	let s:nvim_mod_preference_path = printf("%s/%s", s:nvim_cfg_path, '/mod/preference.vim')
	call mkdir(fnamemodify(s:nvim_mod_preference_path, ':p:h'), 'p')
	call writefile(
		\ readfile(fnamemodify(expand('<sfile>'), ':p')),
		\ fnamemodify(s:nvim_mod_preference_path, ':p'))
	finish
endif

"   Part: reset vim runtimepath
if has('win32')
	set runtimepath-=$HOME/vimfiles
	set runtimepath-=$HOME/vimfiles/after
	set packpath-=$HOME/vimfiles
	set packpath-=$HOME/vimfiles/after

	let s:vim_data_path = $LOCALAPPDATA . '/vim-data'
	execute printf('setglobal runtimepath^=%s/site', s:vim_data_path)
	execute printf('setglobal runtimepath+=%s/site/after', s:vim_data_path)
	execute printf('setglobal packpath^=%s/site', s:vim_data_path)
	execute printf('setglobal packpath+=%s/site/after', s:vim_data_path)
endif
if has('unix')
	let s:is_darwin = system('uname -s') =~ 'Darwin'
	if !s:is_darwin
		set runtimepath-=$HOME/.vim
		set runtimepath-=$HOME/.vim/after
		set packpath-=$HOME/.vim
		set packpath-=$HOME/.vim/after
	endif
	let s:vim_data_path = $HOME . '/.local/share/vim'
	execute printf('setglobal runtimepath^=%s/site', s:vim_data_path)
	execute printf('setglobal runtimepath+=%s/site/after', s:vim_data_path)
	execute printf('setglobal packpath^=%s/site', s:vim_data_path)
	execute printf('setglobal packpath+=%s/site/after', s:vim_data_path)
endif
execute printf('setglobal runtimepath^=%s', s:nvim_cfg_path)
execute printf('setglobal runtimepath+=%s/after', s:nvim_cfg_path)
if !isdirectory(s:vim_data_path)
	call mkdir(s:vim_data_path, 'p')
endif

"   Part: set viminfofile
execute printf('setglobal viminfofile=%s/viminfo', s:vim_data_path)

"   Part: set vim functional directories
for s:dir in ['view', 'undo', 'backup']
	let s:dir_path = printf('%s/%s', s:vim_data_path, s:dir)
	if !isdirectory(s:dir_path)
		call mkdir(s:dir_path, 'p')
	endif
	execute printf('setglobal %sdir=%s', s:dir, s:dir_path)
endfor

"   Part: set stdpath
let $VIM_STDPATH_CONFIG = s:nvim_cfg_path
let $VIM_STDPATH_DATA = s:vim_data_path

"   Part: integrate to neovim
if filereadable(fnamemodify(s:nvim_cfg_path, ':p:h') . '/init-vim.vim')
	execute printf('source %s/%s', s:nvim_cfg_path, 'init-vim.vim')
endif
