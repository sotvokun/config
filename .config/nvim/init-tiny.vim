" ------------------------------------------------
"  init-tiny.vim
"  Created:  2023-05-18
"  Modified: 2023-09-30
" ------------------------------------------------

" Options
" - Faces
set termguicolors
set cursorline
set signcolumn=yes
set number
set list
set listchars=tab:\|\ ,extends:>,precedes:\<
set title
colorscheme darkblue
silent! colorscheme neosolarized


" - File & Encoding
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,gbk,gb18030,big,euc-jp,latin1
set fileformat=unix
set fileformats=unix,dos,mac
set encoding=utf-8

" - Editing
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smartindent

" - Fold
set foldlevel=99
set foldlevelstart=99
set foldenable
set foldmethod=indent

" - Misc
set nowrap
set lazyredraw
set undofile
set timeoutlen=400
set updatetime=750
set splitbelow
set splitright
set ignorecase
set smartcase

" - Clipboard
set clipboard+=unnamedplus
if has('win32') || has('wsl')
	let g:clipboard = {
		\ 'name': 'win32yank',
		\ 'copy': { '+': 'win32yank.exe -i --crlf', '*': 'win32yank.exe -i --crlf' },
		\ 'paste': { '+': 'win32yank.exe -o --lf', '*': 'win32yank.exe -o --lf' },
		\ 'cache_enabled': 0
		\ }
endif

" - Grep
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case
    set grepformat=%f:%l:%c:%m
endif

" Keymaps
" - Leader key
nnoremap <space> <nop>
let g:mapleader=' '

" - Window movement
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" - Editing
" -- Better indenting
vnoremap < <gv
vnoremap > >gv

" -- Move selected line and block
xnoremap <a-j> <cmd>m '>+1<cr>gv-gv
xnoremap <a-k> <cmd>m '<-2<cr>gv-gv

" -- Cursor movement in insert-mode
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$
inoremap <a-a> <c-o>^
inoremap <c-f> <right>
inoremap <c-b> <left>
inoremap <expr><c-n> pumvisible() ? "\<c-n>" : "\<down>" 
inoremap <expr><c-p> pumvisible() ? "\<c-p>" : "\<up>"

" -- Cursor movement in commandline-mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>

" - Completion
" -- See 'cursor movement in insert-mode'
inoremap <c-k> <c-n>
inoremap <c-s-k> <c-k>

" - [MODE] Quick Setup
nnoremap <leader>qq <cmd>nohl<cr>
nnoremap <leader>qr <cmd>set relativenumber!<cr>
nnoremap <leader>qw <cmd>set wrap!<cr>
nnoremap <leader>qs <cmd>set spell!<cr>
nnoremap <leader>ql :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:redraw<cr>

" - Sensible
nnoremap ]q <cmd>cnext<cr>
nnoremap [q <cmd>cprev<cr>
nnoremap ]b <cmd>bn<cr>
nnoremap [b <cmd>bp<cr>
nnoremap ]t <cmd>tabnext<cr>
nnoremap [t <cmd>tabprev<cr>
nnoremap gb <cmd>b#<cr>

" - Terminal
tnoremap <esc> <c-\><c-n>

" - [MODE] New Mode
nnoremap <leader>et <cmd>tabnew<cr>
nnoremap <leader>ee <cmd>enew<cr>

" - Misc
nnoremap <c-p> :
nnoremap d<c-w> <cmd>q<cr>
nnoremap d<c-t> <cmd>tabclose<cr>
nnoremap dq <cmd>bdel<cr>
nnoremap <silent><esc> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:redraw<cr>


" Builtin Plugins and Component
" - netrw
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_winsize=20


" Autocmds
" - set nocursorline when switch window
augroup svim_cursorline
    au!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

" - mkdir for write file
function! s:mkdir_pre_write(path)
    if isdirectory(a:path) == 0
        call mkdir(a:path, 'p')
    endif
endfunction
augroup svim_mkdir
    au!
    autocmd BufWritePre * call s:mkdir_pre_write(expand('<afile>:p:h'))
augroup END


" Commands
command! -nargs=0 SourceInit source $MYVIMRC


" Functions
function! SvimUnmapCompl()
  iunmap <expr><c-n>
  iunmap <expr><c-p>
  iunmap <c-k>
  iunmap <c-s-k>

  " set them as defalut behavior without completion
  inoremap <c-n> <down>
  inoremap <c-p> <up>
endfunction
