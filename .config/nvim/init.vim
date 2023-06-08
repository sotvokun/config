" ------------------------------------------------ 
"  init.vim
"  Created:  2023-05-18
"  Modified: 2023-05-27
" ------------------------------------------------

command! -nargs=1 -complete=file
	\ RequireSource
	\ execute 'source ' . fnameescape(stdpath('config') . '/<args>')

RequireSource init-tiny.vim

" Initialize fennel
lua require('moonwalk').add_loader('fnl', function(src, path)
    \ return require('fennel').compileString(src, { filename = path })
    \ end)

" Initial for neovim w/o vscode
if !exists('g:vscode')
    lua require('lsp')
end
