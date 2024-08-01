function! statusline#dissession#component()
	if !exists('g:loaded_dissession')
		return ""
	endif
	if g:dissession_ready && v:this_session == ''
		return '%#DissessionReady#' . '○ ' . '%*'
	elseif g:dissession_ready && v:this_session != ''
		return '%#DissessionLoaded#' . '● ' . '%*'
	else
		return ""
	endif
endfunction
