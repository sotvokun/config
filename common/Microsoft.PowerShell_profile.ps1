#======================================
#              SETTINGS
#======================================
Set-PSReadLineOption -Colors @{Parameter='white'}

#======================================
#                ALIAS
#======================================


#======================================
#                PROMPT
#======================================
function prompt
{
    $CMD = $ENV:USERNAME + "@" + $ENV:COMPUTERNAME
    Write-Host($CMD) -NoNewline
    Write-Host(" ") -NoNewline
    Write-Host(Get-ShortLocation) -NoNewline -ForegroundColor Green
    Write-Host(">") -NoNewline
    return " "
}

#======================================
#              UTILITIES
#======================================
function Get-ShortLocation
{
    if($ENV:OS -eq "Windows_NT") {$splitSign = '\'} else {$splitSign = '/'}
    if((Get-Location).Path.Contains($ENV:USERPROFILE)) {$fullPath = (Get-Location).Path.Replace($ENV:USERPROFILE,"~")} else {$fullPath = (Get-Location).Path}
    $eachPath = $fullPath.Split($splitSign)
    $RESPATH = ""

    For($i=0; $i -lt $eachPath.Count; $i += 1)
    {
        # Root in Path in Linux
        if($i -eq 0 -and $splitSign -eq '/')
        {
            $RESPath += '/'
            continue
        }

        # Last directory in Path
        if($i -eq $eachPath.Count - 1) 
        {
            $RESPATH += $eachPath[$i]
            continue
        }

        # Other directories
        $RESPATH += $eachPath[$i][0]
        $RESPATH += '/'
    }
    return $RESPATH
}