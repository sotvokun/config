# nvim_remote_edit.ps1
# REFERENCE: https://github.com/jesseduffield/lazygit/issues/3467#issuecomment-3393095703

param(
	[Parameter(Mandatory=$true, Position=0)]
	[string]$FileName,

	[Parameter(Mandatory=$false, Position=1)]
	[int]$LineNumber
)

if (Test-Path Env:NVIM) {
	# The script may stop when the floating terminal closes, so send every step at once.
	$vimFileName = $FileName.Replace("'", "''")
	$commands = @(
		"<c-\><c-n><cmd>q<cr>"
		"<cmd>execute 'edit ' . fnameescape('$vimFileName')<cr>"
	)
	if ($LineNumber -gt 0) {
		$commands += "<cmd>call cursor($LineNumber, 1)<cr>"
	}
	nvim --server $env:NVIM --remote-send ($commands -join '')
}
else {
	$nvimFileArgs = @()
	if ($LineNumber -gt 0) {
		$nvimFileArgs += "+$LineNumber"
	}
	$nvimFileArgs += $FileName
	nvim $nvimFileArgs
}
