
highlight link Floaterm FloatermBorder

"    Part: lf wrapper
nnoremap <silent> <leader>xf <cmd>FloatermNew --title=lf --width=0.8 --height=0.8 --opener=edit lf<cr>
nnoremap <silent> <leader>xF <cmd>FloatermNew --title=lf --width=0.8 --height=0.8 --opener=edit lf -command='set hidden!' .<cr>

"    Part: lazygit wrapper
function! s:lazygit_wrapper()
	let l:config_path = trim(system('lazygit -cd'))
	let l:config_file = has('win32') ? 'config.nvim.win32.yml' : 'config.nvim.yml'
	let l:command = printf('lazygit -ucf %s/config.yml,%s/%s', l:config_path, l:config_path, l:config_file)
	execute(printf('FloatermNew --title=lazygit --width=0.9 --height=0.9 %s', l:command))
endfunction
nnoremap <silent> <leader>gi <cmd>call <SID>lazygit_wrapper()<cr>
