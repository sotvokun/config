" plugin\wt.vim
"
" COMMAND:
"   :Wt [subcommand] [options]
"
"   subcommand:
"      new-tab                 Open a new tab
"      split-pane              Split the current pane
"      focus-tab               Focus on a tab
"      move-focus              Move focus to another pane
"
"   options:
"     new-tab:
"      -d [directory]          Open in a specific directory
"     split-pane:
"      -H                      Split horizontally
"      -V                      Split vertically
"      -d [directory]          Open in a specific directory
"     focus-tab:
"      -p                      Focus on previous tab
"      -n                      Focus on next tab
"      -t [index]              Focus on tab with index
"     move-focus:
"      left                    Move focus to the left pane
"      right                   Move focus to the right pane
"      up                      Move focus to the up pane
"      down                    Move focus to the down pane
"

if has('win32') && !exists('$WT_SESSION')
	echoerr '[wt] current session is not in Windows Terminal'
endif

if exists('g:wt_loaded')
	finish
endif
let g:wt_loaded = 1


function s:wt(subcommand)
	execute 'silent !wt -w 0 ' . a:subcommand
endfunction

function s:wt_complete(A, L, P)
	let parts = split(a:L, '\s\+')
	if len(parts) <= 1
		return ['new-tab', 'split-pane', 'focus-tab', 'move-focus']
	endif
	let subcommand = parts[1]
	if subcommand == 'new-tab'
		return []
	elseif subcommand == 'split-pane'
		return ['-H', '-V']
	elseif subcommand == 'focus-tab'
		return ['-p', '-n', '-t']
	elseif subcommand == 'move-focus'
		return ['left', 'right', 'up', 'down']
	endif
endfunction

command! -nargs=+ -complete=customlist,s:wt_complete Wt call s:wt(<q-args>)
