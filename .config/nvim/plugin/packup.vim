" packup.vim
"
" packup.vim is a simple plugin manager for Vim and Neovim.
"
" VARIABLES:
"   g:packup_manifest          - path to the plugin manifest file
"   g:packup_home              - package directory containing start/ and opt/
"
" COMMANDS:
"   :Packup                    - synchronize installed plugins with the manifest
"   :Packup install            - install missing plugins
"   :Packup update             - update installed plugins and move start/opt
"   :Packup clean              - remove plugins absent from the manifest
"
" MANIFEST FORMAT:
"   host/owner/repository [start|opt] [branch|-]
"   Blank lines and lines beginning with # are ignored.
"   branch names an origin branch to install or switch to (not a tag).
"   Omit branch or use - to keep the current branch on update.

if exists('g:loaded_packup')
  finish
endif

if !exists('g:packup_manifest') || !exists('g:packup_home')
  echoerr '[packup] g:packup_manifest and g:packup_home must be set'
  finish
endif

let g:loaded_packup = 1
let s:home = expand(g:packup_home)

function! s:run(args) abort
  if has('nvim')
    let output = systemlist(a:args)
  else
    let command = join(map(copy(a:args), 'shellescape(v:val)'), ' ')
    let output = systemlist(command . ' 2>&1')
  endif
  return [v:shell_error, output]
endfunction

function! s:show(lines) abort
  for line in a:lines
    echomsg line
  endfor
endfunction

function! s:read_manifest() abort
  let plugins = []

  for line in readfile(expand(g:packup_manifest))
    let line = trim(line)
    if empty(line) || line[0] ==# '#'
      continue
    endif

    let fields = split(line)
    let url = 'https://' . fields[0]
    let name = substitute(fnamemodify(url, ':t'), '\.git$', '', '')
    let type = get(fields, 1, 'start')
    let branch = get(fields, 2, '-')

    call add(plugins, {
          \ 'name': name,
          \ 'url': url,
          \ 'type': type,
          \ 'branch': branch ==# '-' ? '' : branch,
          \ 'path': s:home . '/' . type . '/' . name,
          \ })
  endfor

  return plugins
endfunction

" Synchronize submodules and generate help tags after installation or update.
function! s:after(plugin) abort
  if filereadable(a:plugin.path . '/.gitmodules')
    echomsg '[packup] synchronizing submodules for ' . a:plugin.name
    for command in [
          \ ['submodule', 'sync', '--recursive'],
          \ ['submodule', 'update', '--init', '--recursive', '--depth=1']]
      let [status, output] = s:run(['git', '-C', a:plugin.path] + command)
      if status
        call s:show(output)
        throw '[packup] failed to synchronize submodules for ' . a:plugin.name
      endif
    endfor
  endif
  if isdirectory(a:plugin.path . '/doc')
    execute 'helptags ' . fnameescape(a:plugin.path . '/doc')
  endif
endfunction

function! s:other_path(plugin) abort
  let type = a:plugin.type ==# 'start' ? 'opt' : 'start'
  return s:home . '/' . type . '/' . a:plugin.name
endfunction

" Install only missing plugins; an existing copy in the other type counts.
function! s:install(plugins) abort
  for plugin in a:plugins
    if isdirectory(plugin.path) || isdirectory(s:other_path(plugin))
      continue
    endif
    call mkdir(fnamemodify(plugin.path, ':h'), 'p')
    echomsg '[packup] cloning ' . plugin.name
    let command = ['git', 'clone', '--quiet', '--recurse-submodules',
          \ '--shallow-submodules', '--depth=1']
    if !empty(plugin.branch)
      call extend(command, ['--branch', plugin.branch])
    endif
    call extend(command, [plugin.url, plugin.path])
    let [status, output] = s:run(command)
    if status
      call s:show(output)
      throw '[packup] failed to install ' . plugin.name
    endif
    call s:after(plugin)
  endfor
endfunction

" Move existing plugins if needed, then fetch and update their branches.
function! s:update(plugins) abort
  for plugin in a:plugins
    if !isdirectory(plugin.path)
      let other = s:other_path(plugin)
      if !isdirectory(other)
        continue
      endif
      call mkdir(fnamemodify(plugin.path, ':h'), 'p')
      echomsg '[packup] moving ' . plugin.name . ' to ' . plugin.type
      if rename(other, plugin.path)
        throw '[packup] failed to move ' . plugin.name
      endif
    endif

    echomsg '[packup] fetching ' . plugin.name
    let command = ['git', '-C', plugin.path, 'fetch', '--quiet']
    if !empty(plugin.branch)
      " Shallow clones normally fetch only their initial branch.
      call extend(command, ['origin', '+refs/heads/' . plugin.branch
            \ . ':refs/remotes/origin/' . plugin.branch])
    endif
    let [status, output] = s:run(command)
    if status
      call s:show(output)
      throw '[packup] failed to fetch ' . plugin.name
    endif

    let switched = !empty(plugin.branch) ? s:branch(plugin) : 0

    " Detached HEADs and branches without an upstream are left unchanged.
    let [status, output] = s:run(
          \ ['git', '-C', plugin.path, 'rev-parse', '--verify', '@{u}'])
    if status
      continue
    endif

    let [status, output] = s:run(
          \ ['git', '-C', plugin.path, 'rev-list', '--count', 'HEAD..@{u}'])
    if status
      call s:show(output)
      throw '[packup] failed to inspect ' . plugin.name
    endif
    if str2nr(get(output, 0, '0')) == 0
      if switched
        call s:after(plugin)
      endif
      continue
    endif

    let [diverged, output] = s:run(
          \ ['git', '-C', plugin.path, 'merge-base', '--is-ancestor',
          \  'HEAD', '@{u}'])
    if diverged > 1
      call s:show(output)
      throw '[packup] failed to inspect ' . plugin.name
    endif
    if diverged
      if input('[packup] ' . plugin.name . ' diverged. Force update? [y/N] ') !~? '^y$'
        throw '[packup] update cancelled for ' . plugin.name
      endif
      let [status, output] = s:run(
            \ ['git', '-C', plugin.path, 'reset', '--hard', '@{u}'])
    else
      echomsg '[packup] updating ' . plugin.name
      let [status, output] = s:run(
            \ ['git', '-C', plugin.path, 'merge', '--ff-only', '@{u}'])
    endif
    if status
      call s:show(output)
      throw '[packup] failed to update ' . plugin.name
    endif
    call s:after(plugin)
  endfor
endfunction

" Select the requested branch and keep ordinary fetch/upstream updates working
" after switching away from the branch used by a single-branch clone.
function! s:branch(plugin) abort
  let git = ['git', '-C', a:plugin.path]
  let branch = a:plugin.branch
  let [status, output] = s:run(git + ['symbolic-ref', '--quiet', '--short', 'HEAD'])
  let switched = status || get(output, 0, '') !=# branch

  if switched
    echomsg '[packup] switching ' . a:plugin.name . ' to ' . branch
    let [status, output] = s:run(git + ['show-ref', '--verify', '--quiet',
          \ 'refs/heads/' . branch])
    if status > 1
      call s:show(output)
      throw '[packup] failed to inspect branch for ' . a:plugin.name
    endif
    let command = status
          \ ? ['switch', '--no-track', '-c', branch, 'refs/remotes/origin/' . branch]
          \ : ['switch', '--no-guess', branch]
    let [status, output] = s:run(git + command)
    if status
      call s:show(output)
      throw '[packup] failed to switch branch for ' . a:plugin.name
    endif
  endif

  for command in [
        \ ['remote', 'set-branches', 'origin', branch],
        \ ['branch', '--set-upstream-to=origin/' . branch, branch]]
    let [status, output] = s:run(git + command)
    if status
      call s:show(output)
      throw '[packup] failed to set upstream for ' . a:plugin.name
    endif
  endfor
  return switched
endfunction

" Keep declared plugins in either type so clean alone cannot delete a
" plugin waiting to be moved by update.
function! s:clean(plugins) abort
  let wanted = {}
  for plugin in a:plugins
    let wanted[plugin.name] = 1
  endfor
  for type in ['start', 'opt']
    for path in glob(s:home . '/' . type . '/*', 0, 1)
      let name = fnamemodify(path, ':t')
      if isdirectory(path) && !has_key(wanted, name)
        echomsg '[packup] removing ' . name
        if delete(path, 'rf')
          throw '[packup] failed to remove ' . name
        endif
      endif
    endfor
  endfor
endfunction

function! s:packup(action) abort
  let actions = empty(a:action) ? ['install', 'update', 'clean'] : [a:action]
  if index(['install', 'update', 'clean'], get(actions, 0, '')) < 0
    echoerr '[packup] expected install, update or clean'
    return
  endif
  if a:action !=# 'clean' && !executable('git')
    echoerr '[packup] git is not executable'
    return
  endif

  try
    let plugins = s:read_manifest()
    for action in actions
      call call(function('s:' . action), [plugins])
    endfor
    echomsg '[packup] done'
  catch
    echoerr v:exception
  endtry
endfunction

function! s:complete(lead, line, pos) abort
  return filter(['install', 'update', 'clean'], 'stridx(v:val, a:lead) == 0')
endfunction

command! -nargs=? -complete=customlist,<SID>complete Packup call <SID>packup(<q-args>)
