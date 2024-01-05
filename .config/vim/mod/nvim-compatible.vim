if has('nvim')
	finish
endif

" options
" ------------------------
filetype plugin indent on
syntax on
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set belloff=all
set commentstring=
set nocompatible
set complete-=i
set display=lastline
set encoding=utf-8
set fillchars=vert:\│,fold:\⋅
set formatoptions=tcqj
set nofsync
set hidden
set history=10000
set hlsearch
set incsearch
set nojoinspaces
set langnoremap
set laststatus=2
set listchars=tab:>\ ,trail:-,nbsp:+
set mouse=nvi
set mousemodel=popup_setpos
set nrformats=bin,hex
set ruler
set sessionoptions+=unix,slash
set sessionoptions-=options
set shortmess+=F
set shortmess-=S
set showcmd
set sidescroll=1
set smarttab
set nostartofline
set switchbuf=uselast
set tabpagemax=50
set tags=./tags;,tags
set ttimeoutlen=50
set ttyfast
set viewoptions+=unix,slash
set viewoptions-=options
set viminfo+=!
set wildmenu
set wildoptions=pum,tagfile

" mappings
" ------------------------
nnoremap Y y$
nnoremap <c-l> <cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
xnoremap * y/\V<c-r>"<cr>
xnoremap # y?\V<c-r>"<cr>
nnoremap & :&&<cr>
