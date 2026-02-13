# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs -BellStyle Visual


# Environment Variable
$ENV:MSYS="winsymlinks:nativestrict"
$ENV:CYGWIN="winsymlinks:nativestrict"
$ENV:GOPATH="${env:LOCALAPPDATA}\go"


# Alias
Set-Alias -Name open -Value Explorer.exe


# Prompt
function prompt
{
	$cmd = "${env:USERNAME}@${env:COMPUTERNAME}"
	Write-Host "${env:USERNAME}@${env:COMPUTERNAME} " -NoNewline -ForegroundColor White
	Write-Host (Get-Location).Path.Replace($env:USERPROFILE, '~') -NoNewline -ForegroundColor Green
	Write-Host "`n>" -NoNewline
	return ' '
}


# mise-en-place Integration
if ($PSVersionTable.PSVersion.Major -ge 7 -and (Get-Command 'mise.exe' -ErrorAction SilentlyContinue))
{
	mise activate pwsh | Out-String | Invoke-Expression
}
else
{
	Write-Host "mise is not installed or PowerShell version is less than 7." -ForegroundColor Yellow
}


# Windows Terminal Integration
if ($env:WT_SESSION)
{
	Remove-PSReadLineKeyHandler -Chord 'Ctrl+a'
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,Ctrl+a' -Function BeginningOfLine
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,c' -ScriptBlock { wt.exe -w 0 new-tab -d "$PWD" }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,]' -ScriptBlock { wt.exe -w 0 focus-tab -n }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,[' -ScriptBlock { wt.exe -w 0 focus-tab -p }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,|' -ScriptBlock { wt.exe -w 0 split-pane -V -d "$PWD" }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,-' -ScriptBlock { wt.exe -w 0 split-pane -H -d "$PWD" }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,h' -ScriptBlock { wt.exe -w 0 move-focus left }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,j' -ScriptBlock { wt.exe -w 0 move-focus down }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,k' -ScriptBlock { wt.exe -w 0 move-focus up }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,l' -ScriptBlock { wt.exe -w 0 move-focus right }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,0' -ScriptBlock { wt.exe -w 0 focus-tab -t 0 }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,1' -ScriptBlock { wt.exe -w 0 focus-tab -t 1 }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,2' -ScriptBlock { wt.exe -w 0 focus-tab -t 2 }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,3' -ScriptBlock { wt.exe -w 0 focus-tab -t 3 }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,4' -ScriptBlock { wt.exe -w 0 focus-tab -t 4 }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,5' -ScriptBlock { wt.exe -w 0 focus-tab -t 5 }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,6' -ScriptBlock { wt.exe -w 0 focus-tab -t 6 }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,7' -ScriptBlock { wt.exe -w 0 focus-tab -t 7 }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,8' -ScriptBlock { wt.exe -w 0 focus-tab -t 8 }
	Set-PSReadLineKeyHandler -Chord 'Ctrl+a,9' -ScriptBlock { wt.exe -w 0 focus-tab -t 9 }
}


# Local Profile
$local_path = "$(Split-Path -Parent $PROFILE)\Microsoft.PowerShell_profile.local.ps1"
if (Test-Path $local_path)
{
	. "${local_path}"
}
