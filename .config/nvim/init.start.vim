" ------------------------------------------------
"  init-tiny.vim
"  Created:  2023-05-18
"  Modified: 2023-10-02
" ------------------------------------------------

let $VIMHOME = stdpath('config')

" Options
" - Faces
set termguicolors
set cursorline
set signcolumn=yes
set number
set list
set listchars=tab:\│\ ,extends:>,precedes:\<

colorscheme neosolarized
set statusline=%{%v:lua.require'statusline'.statusline()%}
set noshowmode
set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-lCursor,r-cr-o:hor20

" - File & Encoding
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,gbk,gb18030,big,euc-jp,latin1
set fileformat=unix
set fileformats=unix,dos,mac
set encoding=utf-8

" - Editing
set expandtab

" - Fold
set foldlevel=99
set foldlevelstart=99
set foldmethod=indent

" - Misc
set showbreak=↳\ 
set undofile
set noswapfile
set timeoutlen=400
set updatetime=250
set splitbelow
set splitright
set ignorecase
set smartcase
set wildignorecase
set exrc
set title

" Enable indent-heuristic to make vimdiff more closely match git diff
set diffopt+=indent-heuristic,linematch:60

" - Clipboard
set clipboard+=unnamedplus
if has('win32') || has('wsl')
    let s:win32yank = 'win32yank'
    if has('wsl')
        let s:win32yank_winpath = system('/mnt/c/Windows/System32/where.exe win32yank')
        let s:win32yank = 
            \ '/mnt/c' . trim(substitute(s:win32yank_winpath[2:], '\\', '/', 'g'))
    endif
    let g:clipboard = {
        \ 'name': 'win32yank',
        \ 'copy': { '+': s:win32yank .' -i --crlf', '*': s:win32yank .' -i --crlf' },
        \ 'paste': { '+': s:win32yank .' -o --lf', '*': s:win32yank .' -o --lf' },
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
" -- Moving on wrapped lines
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

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

" - Sensible
nnoremap ]q <cmd>cnext<cr>
nnoremap [q <cmd>cprev<cr>
nnoremap ]b <cmd>bn<cr>
nnoremap [b <cmd>bp<cr>
nnoremap ]t <cmd>tabnext<cr>
nnoremap [t <cmd>tabprev<cr>
nnoremap g. `I

" - Terminal
tnoremap <esc><esc> <c-\><c-n>

" - Misc
nnoremap d<c-w> <cmd>q<cr>
nnoremap d<c-t> <cmd>tabclose<cr>
nnoremap dq <cmd>bdelete<cr>
nnoremap dx <cmd>Bdelete<cr>
nnoremap <silent><esc> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:redraw<cr>
nnoremap zS <cmd>Inspect<cr>
nnoremap <leader>et <cmd>tabnew<cr>
nnoremap <leader>eb <cmd>enew<cr>


" Builtin Plugins and Component
" - netrw
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_winsize=20


" Autocmds
" - set nocursorline when switch window
augroup svim_init
        au!

        " open terminal and enter insert mode automatically
        autocmd TermOpen term://* startinsert

        " highlight yanked text
        autocmd TextYankPost * lua vim.highlight.on_yank {higroup="Visual", timeout=150, on_visual=true}

        " Show cursor only in current window
        autocmd WinEnter,FocusGained * set cursorline
        autocmd WinLeave,FocusLost * set nocursorline

        " mkdir before write file
        autocmd BufWritePre,FileWritePre * 
                \ if @% !~# '\(://\)' 
                \ | call mkdir(expand('<afile>:p:h'), 'p')
                \ | endif

        " quickly quit help and quickfix window
        autocmd FileType help nnoremap <buffer> q <cmd>quit<cr>
        autocmd FileType qf 
                \ nnoremap <buffer> q <cmd>quit<cr>
                \ | setlocal nonumber

        " save the last position that content changed
        autocmd InsertLeave * execute 'normal! mI'

augroup END


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
