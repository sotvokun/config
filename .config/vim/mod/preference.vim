silent! colorscheme neosolarized

" Section: Options
"    Part: Window and Windows
set splitbelow
set splitright

"   Part: Folding and comments
set foldmethod=indent
set foldlevel=99
set foldlevelstart=99
set formatoptions+=j

"   Part: Faces
set termguicolors
set number
set list
set signcolumn=yes
set listchars=tab:\│\ ,extends:>,precedes:\<,trail:⋅
set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:block-lCursor,r-cr-o:hor20
set linebreak
set breakindent
set showbreak=\\\ 
set cursorline
set scrolloff=1
set sidescrolloff=5

"   Part: Misc
set autoread
set autowrite
set confirm
set exrc
set nolazyredraw
set undofile
set noswapfile
set ignorecase
set smartcase
set wrap
set fileencodings=ucs-bom,utf-8,gbk,gb18030,big,euc-jp,latin1
set updatetime=500
set timeoutlen=500
set noshowmode
set sessionoptions+=localoptions

"   Part: grep
if executable('rg')
	set grepprg=rg\ --vimgrep\ --no-heading\ --no-ignore-vcs\ --hidden\ --glob=!.git/
	set grepformat=%f:%l:%c:%m
endif


" Section: Keymap
"    Part: Leader
nnoremap <space> <nop>
let g:mapleader=' '

"    Part: Window
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

"    Part: Cursor Moving
" moving on wrapped lines
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

"    Part: Editting
" cut all after cursor
inoremap <c-z> <c-o>D

" insert-mode cursor moving
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-f> <right>
inoremap <c-b> <left>
inoremap <expr> <c-n> pumvisible() ? "\<c-n>" : "\<down>"
inoremap <expr> <c-p> pumvisible() ? "\<c-p>" : "\<up>"
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>

" fallback setup
inoremap <c-x>n <c-n>
inoremap <c-x>p <c-p>
cnoremap <c-x><c-a> <c-a>
cnoremap <c-x><c-f> <c-f>

"    Part: Unimpaired
nnoremap <expr> ]b '<cmd>' . v:count1 . 'bnext<cr>'
nnoremap <expr> [b '<cmd>' . v:count1 . 'bprevious<cr>'
nnoremap <expr> ]t '<cmd>+' . v:count1 . 'tabnext<cr>'
nnoremap <expr> [t '<cmd>-' . v:count1 . 'tabnext<cr>'
nnoremap <expr> ]q '<cmd>' . v:count1 . 'cnext<cr>'
nnoremap <expr> [q '<cmd>' . v:count1 . 'cprevious<cr>'
nnoremap ]B <cmd>blast<cr>
nnoremap [B <cmd>bfirst<cr>

"    Part: better indenting
vnoremap < <gv
vnoremap > >gv

"    Part: formatting
nnoremap gqq mzgggqG`z
nnoremap gq? <cmd>set formatprg?<cr>

"    Part: Misc

" replay @q macro
nnoremap Q @q

" <esc> disable highlight and redraw
nnoremap <silent> <esc> <cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>redraw<cr>

" mark search position
nnoremap / ms/
nnoremap ? ms?

" quit terminal mode with dobule <esc>
tnoremap <esc><esc> <c-\><c-n>

" powerful <c-g>
" nnoremap <c-g><c-g> <cmd>file<cr>
nnoremap <c-g> <nop>
nnoremap <c-g><c-g> <cmd>file<cr>

if has('nvim')
	" inspect stuff under cursor
	nnoremap zS <cmd>Inspect<cr>
	" quickly insert lua command
	nnoremap g: :=
endif


" Section: Autocmd
augroup init
	au!
	
	" show cursor only current window
	autocmd WinEnter,FocusGained * set cursorline
	autocmd WinLeave,FocusLost * set nocursorline

	" mkdir before write file
	autocmd BufWritePre,FileWritePre *
		\ if @% !~# '\(://\)'
		\ | call mkdir(expand('<afile>:p:h'), 'p')
		\ | endif

	if has('nvim')
		" Enter insert mode automatically
		autocmd TermOpen term://* setlocal nonumber | startinsert
	endif
augroup END
