" bundle/tool.vim - plugins bundle of tool
"


" Section: vim-floaterm
" -----------------------------------------------------------------------------
Plug 'voldikss/vim-floaterm'


let g:floaterm_opener = 'edit'
if has('win32')
	let g:floaterm_shell = executable('pwsh') ? 'pwsh -NoLogo' : 'powershell -NoLogo'
endif

function! s:select_floaterm()
	if has('nvim')
lua << EOF
		local term_list = vim.fn['floaterm#buflist#gather']()
		local term_list = vim.tbl_map(function(nr)
			return vim.fn['floaterm#config#get'](nr, 'name', string.format('#%d', nr))
		end, term_list)
		vim.ui.select(term_list, {
			prompt = 'Select floaterm: ',
		}, function(selected)
			if selected == nil then
				return
			end
			if string.match(selected, '#%d$') then
				selected = tonumber(({string.gsub(selected, '#', '')})[1])
				vim.cmd(string.format('%dFloatermShow', selected))
			else
				vim.cmd(string.format('FloatermShow %s', selected))
			end
		end)
EOF
		return
	endif

	let term_list = floaterm#buflist#gather()
	let term_list = map(term_list, {_, nr -> floaterm#config#get(nr, 'name', printf('#%d', nr))})
	let selected = inputlist(['Select floaterm:'] + term_list)
	if selected <= 0
		return
	endif
	let selected = term_list[selected]
	if selected =~# '\v#(\d+)$'
		let selected = str2nr(substitute(selected, '#', '', ''))
		execute printf('%dFloatermShow', selected)
	else
		execute printf('FloatermShow %s', selected)
	endif
endfunction
nnoremap <leader>t <cmd>call <SID>select_floaterm()<cr>


" Section: fzf-lua
" -----------------------------------------------------------------------------
" NOTE: setup fzf-lua after lazy loaded
"
Plug 'ibhagwan/fzf-lua', {'on': 'FzfLua'}

nnoremap <leader>f <cmd>FzfLua files<cr>
nnoremap <leader>o <cmd>FzfLua oldfiles<cr>
nnoremap <leader>b <cmd>FzfLua buffers<cr>
nnoremap <leader>% <cmd>FzfLua live_grep<cr>
augroup lazyload_fzflua
	autocmd!
	autocmd User fzf-lua runtime bundle/plugin/fzflua.lua | autocmd! lazyload_fzflua
augroup END


" Section: fern
" -----------------------------------------------------------------------------
"
Plug 'lambdalisue/vim-fern'
Plug 'lambdalisue/vim-fern-git-status'

let g:fern#renderer#default#leaf_symbol = ' '
let g:fern#renderer#default#collapsed_symbol = '▸ '
let g:fern#renderer#default#expanded_symbol = '▾ '
let g:fern#renderer#hide_cursor = 1
let g:fern#disable_default_mappings = 1

" Keymap

function! s:setup_fern_keymap()
	nnoremap <buffer> <c-l> <c-w>l
	nnoremap <buffer> q <c-w>q

	nnoremap <buffer> ga <Plug>(fern-action-choice)
	nnoremap <buffer> <c-p> <Plug>(fern-action-preview)
	nnoremap <buffer> R <Plug>(fern-action-reload)

	nnoremap <buffer> l <Plug>(fern-action-open-or-expand)
	nnoremap <buffer> h <Plug>(fern-action-collapse)
	nnoremap <buffer> r <Plug>(fern-action-rename)
	nnoremap <buffer> D <Plug>(fern-action-remove)

	nnoremap <buffer> y <Plug>(fern-action-copy)
	nnoremap <buffer> p <Plug>(fern-action-paste)

	nnoremap <buffer> v <Plug>(fern-action-open:vsplit)
	nnoremap <buffer> s <Plug>(fern-action-open:split)
	nnoremap <buffer> <cr> <Plug>(fern-action-open:select)

	nnoremap <buffer> a <Plug>(fern-action-new-file)
	nnoremap <buffer> A <Plug>(fern-action-new-dir)

	nnoremap <buffer> ! <Plug>(fern-action-hidden)
	nnoremap <buffer> m <Plug>(fern-action-mark)
endfunction

nnoremap <c-g>n <cmd>Fern . -width=40 -drawer -toggle -right<cr>
augroup setup_fern
	au!
	autocmd FileType fern
		\ setlocal nonumber
		\ | setlocal expandtab
		\ | setlocal conceallevel=2
		\ | setlocal concealcursor=nc
		\ | call s:setup_fern_keymap()
augroup END
