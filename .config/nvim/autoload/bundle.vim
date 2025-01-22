" vim-bundle: vim-plug companion
" ==============================
"

" if exists('g:loaded_bundle')
"   finish
" endif
" let g:loaded_bundle = 1

function! s:errmsg(msg)
  echohl ErrorMsg
  echom '[vim-bundle] '.a:msg
  echohl None
  return -1
endfunction

function! s:path(path)
  if has('win32')
    return trim(substitute(a:path, '/', '\', 'g'))
  else
    return trim(a:path)
  endif
endfunction

function! s:load(path)
  let bundle_name = fnamemodify(a:path, ':t')
  if fnamemodify(bundle_name, ':e') == 'lua'
    let bundle_name = substitute(bundle_name, '\.', '_', 'g')
  else
    let bundle_name = fnamemodify(bundle_name, ':t:r')
  endif
  execute printf('source %s', a:path)
  call add(g:bundles, bundle_name)
endfunction

function! bundle#load(...)
  if a:0 > 0
    let home = s:path(fnamemodify(expand(a:1), ':p'))
  elseif exists('g:bundle_home')
    let home = s:path(g:bundle_home)
  elseif has('nvim')
    let home = s:path(stdpath('config').'/bundle')
  elseif !empty(&rtp)
    let home = s:path((split(&rtp, ',')[0]).'/bundle')
  else
    return s:errmsg('Unable to determine bundle home. Try calling bundle#load() with a path argument.')
  endif

  if !exists(':Plug')
    return s:errmsg('Must call plug#begin() before this function.')
  endif

  let g:bundle_home = home
  let g:bundles = []

  let bundlefiles = glob(s:path(home.'/*.vim'), 0, 1)
  if has('nvim')
    let bundlefiles += glob(s:path(home.'/*.lua'), 0, 1)
  endif

  for f in bundlefiles
    let load_result = s:load(f)
    if load_result < 0
      return load_result
    endif
  endfor
  return 1
endfunction
