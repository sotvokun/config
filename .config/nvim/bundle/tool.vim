" bundle/tool.vim - plugins bundle of tool
"


" Section: vim-floaterm
" -----------------------------------------------------------------------------
Plug 'voldikss/vim-floaterm'


let g:floaterm_opener = 'edit'
if has('win32')
	let g:floaterm_shell = 'powershell'
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
