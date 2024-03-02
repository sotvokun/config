# Set POSIX like HOME variable
if ([Environment]::GetEnvironmentVariable("HOME") -eq $null) {
   [Environment]::SetEnvironmentVariable("HOME", $ENV:USERPROFILE, "User")
   $ENV:HOME = $ENV:USERPROFILE
}
