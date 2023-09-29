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

# neovim
Ensure-Junction -Target "~/.config/nvim" $ENV:LOCALAPPDATA/nvim

# vscode
Ensure-Symlink `
    -Target "~/.config/vscode/settings.json" `
    -Link "~/scoop/apps/vscode/current/data/user-data/User/settings.json"

Ensure-Symlink `
    -Target "~/.config/vscode/keybindings.json" `
    -Link "~/scoop/apps/vscode/current/data/user-data/User/keybindings.json"
