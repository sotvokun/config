" init.vim
"
" COMMAND:
"   :Import                             - Load a file (vim, lua, fnl)
"
" FUNCTIONS:
"   Stdpath                             - neovim compatible function for vim
"

if exists('g:loaded_vimrc')
	finish
endif
let g:loaded_vimrc = 1


" Section: commands
"
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 Import execute printf("source %s/<args>", s:home)

command! -nargs=0 SudoWrite
	\ if !has('win32')
	\ | execute 'w !sudo tee ' . expand('%')
	\ | else
	\ | w!
	\ | endif


" Section: functions
"
function! g:Stdpath(name)
	if has('nvim')
		return stdpath(a:name)
	endif
	if a:name == 'config'
		return s:home
	endif
endfunction


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
set list
set listchars=tab:\|\ ,extends:>,precedes:\<,trail:~
set scrolloff=1
set sidescrolloff=5
set signcolumn=yes
set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-lCursor,r-cr-o:hor20-lCursor,t:block-blinkon500-blinkoff500-TermCursor

if has('termguicolors')
	set termguicolors
endif

if has('syntax')
	syntax on
endif

if has('nvim')
	set winborder=none
endif

"    Part: misc
"
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

"    REFERENCES:
"      * Cannot open file with a name or folder has parenthesis "(" on Windows
"      |- https://github.com/neovim/neovim/issues/24542
"      |- `set isfname+=(,)` is work, but it will broke `helpgrep` command
"      |- `set noshellslash` is work too, but it will broke some plugin
if has('win32')
	set noshellslash
endif

"    Part: grep
"
if executable('rg')
	set grepprg=rg\ --vimgrep\ --no-heading\ --no-ignore-vcs\ --hidden\ --glob=!.git/
	set grepformat=%f:%l:%c:%m
endif


" Section: keymap
"    Part: leader key
nnoremap <space> <nop>
let g:mapleader = ' '

"    Part: release some keybindings
"          make <c-x> as the secondary leader
"          fallback setup
nnoremap <c-g> <nop>
nnoremap <c-x> <nop>
nnoremap <c-x><c-g> <cmd>:file<cr>
nnoremap <c-x><c-a> <c-a>
nnoremap <c-x><c-x> <c-x>

"    Part: window
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

"    Part: tabpage
nnoremap <c-x>et <cmd>tabnew<cr>

"    Part: buffer
nnoremap <c-x>eb <cmd>enew<cr>

"    Part: cursor
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

"    Part: emacs-like keymap on typing mode
"          fallback <c-n> and <c-p> in insert mode
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
cnoremap <c-k> <c-\>e getcmdline()[:getcmdpos()-2]<cr>

inoremap <c-x>n <c-n>
inoremap <c-x>p <c-p>
cnoremap <c-x><c-f> <c-f>

"    Part: misc
"  unimpaired
nnoremap <expr> ]t '<cmd>+'.v:count1.'tabnext<cr>'
nnoremap <expr> [t '<cmd>-'.v:count1.'tabnext<cr>'

"  better indenting
vnoremap < <gv
vnoremap > >gv

" replay @q macro
nnoremap Q @q

" <esc> disable highlight and redraw
nnoremap <silent> <esc> <cmd>nohlsearch<bar>diffupdate<bar>redraw<cr>

" mark search position
nnoremap / ms/
nnoremap ? ms?

" others
" - remove some unuseful neovim keybinding
" - setup some neovim builtin keybindings for vim
if has('nvim')
	nnoremap <c-x>I <cmd>Inspect<cr>
	lua vim.keymap.del('n', 'grn')
	lua vim.keymap.del('n', 'grr')
	lua vim.keymap.del('n', 'gri')
	lua vim.keymap.del('n', 'gra')
else
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


" Section: autocmd
"
augroup init
	au!

	" mkdir before write file
	autocmd BufWritePre,FileWritePre *
		\ if @% !~# '\(://\)'
		\ | call mkdir(expand('<afile>:p:h'), 'p')
		\ | endif

	" setup for some special filetype:
	"   help, qf, query, checkhealth
	autocmd FileType help,qf,query,checkhealth
		\ setlocal nowrap
		\ | nnoremap <buffer> q <cmd>quit<cr>

	" bigfile experience optimizing
	autocmd BufWinEnter *
		\ if getfsize(@%) > 1000000
		\ | setlocal syntax=OFF
		\ | setlocal nowrap
		\ | endif
augroup END


" Section: Builtin plugins
"    Part: netrw
let g:netrw_banner = 0
let g:netrw_preview = 1
let g:netrw_alto = 0
let g:netrw_winsize = 40

"    Part: editorconfig
silent! packadd! editorconfig


" Section: Load Plugins
"
call bundle#begin()
call bundle#load()
call bundle#end()
