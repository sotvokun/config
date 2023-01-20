#===========================================================
#
# FishyPrompt.ps1 - fish-like prompt script
#
# Created:  2023-01-20
# Modified: 2023-01-20
#
#===========================================================

function Get-ShortLocation
{
    if ($ENV:OS -eq "Windows_NT") 
    {
        $splitSign = '\'
    }
    else 
    {
        $splitSign = '/'
    }

    if ((Get-Location).Path.Contains($ENV:USERPROFILE))
    {
        $fullPath = (Get-Location).Path.Replace($ENV:USERPROFILE, '~')
    }
    else
    {
        $fullPath = (Get-Location).Path
    }

    $eachPath = $fullPath.Split($splitSign)
    $result = ''

    For($i = 0; $i -lt $eachPath.Count; $i += 1)
    {
        # Root in path in Linux
        if ($i -eq 0 -and $splitSign -eq '/')
        {
            $result += '/'
            continue
        }

        # Drive in path in Windows
        if ($i -eq 0 -and $eachPath[$i] -ne '~' -and $splitSign -eq '\')
        {
            $result += (Get-Location).Drive.Root
            continue
        }

        # Last directory in path
        if ($i -eq $eachPath.Count - 1)
        {
            $result += $eachPath[$i]
            continue
        }

        # Other directories
        $result += $eachPath[$i][0]
        $result += $splitSign
    }
    return $result
}

function prompt
{
    $cmd = $ENV:USERNAME + '@' + $ENV:COMPUTERNAME
    Write-Host ($cmd) -NoNewline
    Write-Host (' ') -NoNewline
    Write-Host (Get-ShortLocation) -NoNewline -ForegroundColor Green
    Write-Host ('>') -NoNewline
    return ' '
}
