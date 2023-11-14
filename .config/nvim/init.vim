" Section: VSCode prediction

if exists('g:vscode')
    runtime vscode/*.vim
    finish
endif


" Section: Options
"    Part: Face
set termguicolors
set number
set list
set signcolumn=yes
set listchars=tab:\│\ ,extends:>,precedes:\<,trail:·
set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-lCursor,r-cr-o:hor20
set linebreak
set breakindent
set showbreak=\\\ 
set cursorline
set scrolloff=1
set sidescrolloff=5
colorscheme neosolarized

"    Part: Windowing and Window
set splitbelow
set splitright
set title

"    Part: Folding and comments
set foldmethod=indent
set foldlevel=99
set foldlevelstart=99
set formatoptions+=j

"    Part: Misc
set autoread
set autowrite
set confirm
set exrc
set lazyredraw
set undofile
set noswapfile
set ignorecase
set smartcase
set wildignorecase
set wrap
set fileencodings=utf-8,ucs-bom,gbk,gb18030,big,euc-jp,latin1
set updatetime=250
set noshowmode

"    Part: Clipboard
set clipboard+=unnamedplus
if has('win32') || has('wsl')
    let s:win32yank = 'win32yank'
    if has('wsl')
        let s:win32yank_winpath =
            \ system('/mnt/c/Windows/System32/where.exe win32yank')
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


" Section: Keymap
"    Part: Leader-Key
nnoremap <space> <nop>
let g:mapleader=' '

"    Part: Window
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

"    Part: Editing
" moving on wrapped lines
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

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

" - fallback setup
cnoremap <c-x><c-a> <c-a>
cnoremap <c-x><c-f> <c-f>
inoremap <c-x>n <c-n>
inoremap <c-x>p <c-p>

"    Part: Unimpaired
nnoremap <expr> ]b '<cmd>' . v:count1 . 'bnext<cr>'
nnoremap <expr> [b '<cmd>' . v:count1 . 'bprevious<cr>'
nnoremap <expr> ]t '<cmd>+' . v:count1 . 'tabnext<cr>'
nnoremap <expr> [t '<cmd>-' . v:count1 . 'tabnext<cr>'

"    Part: better indenting
vnoremap < <gv
vnoremap > >gv

"    Part: Misc
" <esc> refresh, dsiable highlight
nnoremap <silent> <esc> <cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>syntax sync fromstart<cr><cmd>redraw<cr>

" goto last insert position (see autocmd for storage last insert)
nnoremap g. `I

" save file with ctrl-s
inoremap <c-s> <cmd>update<cr>

" mark search position
nnoremap / ms/
nnoremap ? ms?

" quit terminal mode with double <esc>
tnoremap <esc><esc> <c-\><c-n>

" insepct undert cursor
nnoremap zS <cmd>Inspect<cr>

" quickly insert lua command
nnoremap g: :=


" Section: Autocommands

augroup init
    au!

    " open terminal and start insert mode automatically
    autocmd TermOpen term://* startinsert

    " highlight yanked text
    autocmd TextYankPost * lua vim.highlight.on_yank({higroup="Visual", timeout=150, on_visual=true})

    " show cursor only in current window
    autocmd WinEnter,FocusGained * set cursorline
    autocmd WinLeave,FocusLost * set nocursorline

    " mkdir before write file
    autocmd BufWritePre,FileWritePre *
            \ if @% !~# '\(://\)'
            \ | call mkdir(expand('<afile>:p:h'), 'p')
            \ | endif

    " quickly quit help and quickfix window with <esc> and `q`
    autocmd FileType help,qf
            \ nnoremap <buffer> q <cmd>quit<cr>
            \ | setlocal nonumber

    " save the last position that content changed
    autocmd InsertLeave * execute 'normal! mI'
augroup END

" Section: Optional Plugins

augroup post_init
    au!
    autocmd VimEnter * PkgAdd copilot.vim
augroup END

" vim: expandtab shiftwidth=4
