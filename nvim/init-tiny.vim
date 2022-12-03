"===========================================================
"
" Svim Tiny - The basic configuration
"
" Created: 2022-11-22
" Modified: 2022-11-22
"
"===========================================================

" Options
" -----------------------------
" - Faces
set termguicolors
set cursorline
set signcolumn=yes
set number
set list
set listchars=tab:\|\ ,extends:>,precedes:\<
set title
colorscheme habamax

" - File & encoding
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,gb18030,big,euc-jp,latin1
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
set clipboard+=unnamedplus

filetype indent on

" - Windows
if has('win32') || has('wsl')
    let g:clipboard = { 
        \ 'name': 'win32yank',
        \ 'copy': { '+': 'win32yank.exe -i --crlf', '*': 'win32yank.exe -i --crlf' },
        \ 'paste': { '+': 'win32yank.exe -o --lf', '*': 'win32yank.exe -o --lf' },
        \ 'cache_enabled': 0
        \ }
endif


" Keymaps
" -----------------------------
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
xnoremap <a-j> :m '>+1<cr>gv-gv
xnoremap <a-k> :m '<-2<cr>gv-gv

" -- Cursor movement in insert-mode
inoremap <c-a> <c-o>0
inoremap <a-a> <c-o>^
inoremap <c-e> <c-o>$
inoremap <c-f> <right>
inoremap <c-b> <left>
inoremap <c-d> <del>
" --- Compatible with completion
inoremap <expr><c-n> pumvisible() ? "\<c-n>" : "\<down>"
inoremap <expr><c-p> pumvisible() ? "\<c-p>" : "\<up>"

" -- Curosr movement in commandline-mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" -- Scrolling in insert-mode
inoremap <a-e> <c-x><c-e>
inoremap <a-y> <c-x><c-y>

" -- Completion
" --- See 'Cursor movement in insert-mode'
inoremap <c-k> <c-n>
inoremap <c-s-k> <c-k>


" - Quick Setup
nnoremap <leader>qq :nohl<cr>
nnoremap <leader>qr :set relativenumber!<cr>
nnoremap <leader>qw :set wrap!<cr>
nnoremap <leader>qs :set spell!<cr>
nnoremap <leader>ql :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" - Improve ] and [
nnoremap ]q :cnext<cr>
nnoremap [q :cprev<cr>
nnoremap ]b :bn<cr>
nnoremap [b :bp<cr>

" - Terminal
tnoremap <esc> <c-\><c-n>

" - Scroll the previous window
nnoremap <a-e> <c-w>p<c-e><c-w>p
nnoremap <a-y> <c-w>p<c-y><c-w>p

" - Misc
nnoremap d<c-w> :q<cr>
nnoremap d<c-t> :tabclose<cr>
nnoremap dq :bdel<cr>
nnoremap dQ :bdel!<cr>
nnoremap <leader>et :tabnew<cr>
nnoremap <leader>en :enew<cr>
nnoremap <c-p> :


" Builtin Plugin and Component
" -----------------------------
" - netrw
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 20

" - statusline
function! StatuslineFilePath(path)
    if a:path == '' | return '[No Name]' | endif
    let l:path = fnamemodify(a:path, ':~:.')
    let l:path_len = strlen(l:path)
    if l:path_len == 0
        return '[No Name]'
    elseif l:path_len > 70
        return pathshorten(l:path)
    else
        return l:path
    endif
endfunction
set statusline=
set statusline+=%-{StatuslineFilePath(expand('%F'))}
set statusline+=\ %h%w%m%r
set statusline+=%=
set statusline+=\ %{&filetype}
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ %{&fileformat}
set statusline+=\ %8(%l,%c%V%)
set statusline+=\ %-P


" Autocmds
" -----------------------------
" - set nocursorline when switch window
augroup svim_cursorline
    au!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

" - mkdir for write file
function! s:mkdir_pre_write(path)
    echo a:path
    if isdirectory(a:path) == 0
        call mkdir(a:path, 'p')
    endif
endfunction
augroup svim_mkdir
    au!
    autocmd BufWritePre * call s:mkdir_pre_write(expand("<afile>:p:h"))
augroup END

" - FileType adjuestion
augroup svim_filetypes_group
    au!
    autocmd FileType qf setlocal nonumber
    autocmd FileType markdown setlocal wrap
    autocmd FileType text setlocal wrap
augroup END


" Command
" -----------------------------
" - Load the initialization file
command! -nargs=0 SourceInit source $MYVIMRC


" Function
" -----------------------------
function! SvimUnmapCompl()
    iunmap <expr><c-n>
    iunmap <expr><c-p>
    iunmap <c-k>
    iunmap <c-s-k>

    " Set them as default bebhaiour without compl
    inoremap <c-n> <down>
    inoremap <c-p> <up>
endfunction
