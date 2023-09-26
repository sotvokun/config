Function Ensure-Symlink {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Target,

        [Parameter(Mandatory=$true)]
        [string]$Link
    )

    if (Test-Path $Link) {
        if ((Get-Item $Link).Attributes -notcontains 'ReparsePoint') {
            return
        }
    } else {
        New-Item -ItemType SymbolicLink -Path $Link -Value $Target
    }
}

Function Ensure-Junction {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Target,

        [Parameter(Mandatory=$true)]
        [string]$Link
    )

    if (Test-Path $Link) {
        if ((Get-Item $Link).Attributes -notcontains 'ReparsePoint') {
            return
        }
    } else {
        New-Item -ItemType Junction -Path $Link -Value $Target
    }
}

# -------------------------------------------------------------------

Ensure-Junction -Target "~/.config/nvim" $ENV:LOCALAPPDATA/nvim
