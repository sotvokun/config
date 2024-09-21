# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs -BellStyle Visual


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


# vfox intergarte
if (Get-Command "vfox.exe" -ErrorAction SilentlyContinue)
{
	Invoke-Expression "$(vfox activate pwsh)"
}


# Local Profile
$local_path = "$(Split-Path -Parent $PROFILE)\Microsoft.PowerShell_profile.local.ps1"
if (Test-Path $local_path)
{
	. "${local_path}"
}
