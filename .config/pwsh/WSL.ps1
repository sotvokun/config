function Get-WSLDistro()
{
    $result = (wsl.exe --list)
    $result = $result -split '\n' | Select -Skip 1

    $pattern = '^([a-zA-Z0-9]+)\s*(?:\(Default\))?$'
    for ($i = 0; $i -lt $result.Length; $i += 1)
    {
        $result[$i] = $result[$i].Trim()
        $groups = [RegEx]::Matches($result[$i], $pattern).groups
        if ($groups -eq $NULL)
        {
            continue
        }
        $result[$i] = $groups[1].value
    }
    return $list
}

function Import-WSLDistro()
{
    param(
        [string] $Distro,
        [string] $InstallPath,
        [string] $FilePath
    )

    wsl.exe --import "$Distro" "$InstallPath" "$FilePath"
}

function Unregister-WSLDistro()
{
    param(
        [string] $Distro
    )

    wsl.exe --unregister "$Distro"
}

function Set-WSLDefaultVersion()
{
    param(
        [Int32] $Version
    )

    wsl.exe --set-default-version $Version
}

# --------------------
#  Initialization
# --------------------

function Initialize-WSLDistro()
{
    param(
        [Parameter(Mandatory=$TRUE, Position=0, ValueFromPipeline=$TRUE)]
        [ValidateNotNullOrEmpty()]
        [string] $Distro,

        [Parameter(Mandatory=$TRUE)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Fedora', 'Void')]
        [string] $DistroType
    )

    $USERNAME = $ENV:USERNAME
    $ROOT = "\\wsl.localhost\$Distro"
    $UTF8ENC = New-Object System.Text.UTF8Encoding $FALSE 
    $Script:WSL_CONF = ""

    function Set-WSLDistroUser()
    {
        $USERNAME = $USERNAME.ToLower()
        $passwd = (wsl.exe --user root -d $Distro -e cat /etc/passwd)
        if (($passwd | Select-String -Pattern $USERNAME).Length -lt 1)
        {
            wsl.exe --user root -d $Distro -- useradd -m -G wheel -s /bin/bash $USERNAME
        }
        $Script:WSL_CONF = ($Script:WSL_CONF + "[user]`ndefault=$USERNAME`n`n")
    }

    function Set-WSLDistroPassword()
    {
        $USERNAME = $USERNAME.ToLower()
        wsl.exe --user root -d $Distro -- passwd $USERNAME
    }

    function Set-WSLConfInterop()
    {
        $Script:WSL_CONF = ($Script:WSL_CONF + "[interop]`nenabled=true`nappendWindowsPath=false`n`n")
    }

    function Set-WSLConfSystemd()
    {
        $Script:WSL_CONF = ($Script:WSL_CONF + "[boot]`nsystemd=true`n`n")
    }

    function Write-WSLConf()
    {
        param(
            [string]$Content
        )
        if ($Content -eq "" -or $Content -eq $NULL)
        {
            $Content = $Script:WSL_CONF
        }
        $path = "$ROOT/etc/wsl.conf"
        [System.IO.File]::WriteAllLines($path, $Content, $UTF8ENC)
    }

    function Write-WSLSudoer()
    {
        param(
            [string]$Group
        )
        if ($Group -eq "" -or $Group -eq $NULL)
        {
            $Group = "wheel"
        }
        $content = "%$Group ALL=(ALL:ALL) ALL"
        $path = "$ROOT/etc/sudoers.d/$Group"
        [System.IO.File]::WriteAllLines($path, $content, $UTF8ENC)
    }

    switch ($DistroType)
    {
        "Fedora" {
            # Handle dnf.conf
            $dnf_conf = (wsl.exe -d $Distro -u root -e cat /etc/dnf/dnf.conf) `
                        | Select-String -Pattern 'tsflags=nodocs' -NotMatch `
                        | Out-String
            $dnf_conf = $dnf_conf.Trim()
            [System.IO.File]::WriteAllLines("$ROOT/etc/dnf/dnf.conf", $dnf_conf, $UTF8ENC)

            # Minimal Install
            wsl.exe --user root -d $Distro -e dnf groupinstall -y "Core"

            # Fix password not working
            wsl.exe --user root -d $Distro -e dnf install -y cracklib-dicts

            Set-WSLDistroUser
            Set-WSLDistroPassword

            Set-WSLConfSystemd
        }

        "Void" {
            wsl.exe --user root -d $Distro -e xbps-install -Syu xbps

            Set-WSLDistroUser
            Set-WSLDistroPassword

            $Script:WSL_CONF = ($Script:WSL_CONF + "[boot]`ncommand=""/etc/runit/1 && /etc/runit/2 && /etc/runit/3""`n`n")
        }
    }

    Set-WSLConfInterop
    Write-WSLConf

    Write-WSLSudoer -Group wheel

    wsl.exe --terminate $Distro
}
