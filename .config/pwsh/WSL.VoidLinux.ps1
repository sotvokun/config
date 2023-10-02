function Get-VoidLinuxRootfs()
{
    param(
        [string] $CLib,
        [string] $OutFile
    )

    $sha256sum = ((Invoke-WebRequest -Uri https://repo-default.voidlinux.org/live/current/sha256sum.txt).Content -split '\n')

    function Get-VoidLinuxRootfsPattern()
    {
        $arch = 'x86_64'
        if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64')
        {
            $arch = 'aarch64'
        }

        $select_clib = ''
        if ($CLib -eq 'musl')
        {
            $select_clib = 'musl'
        }

        $pattern = 'void-' + $arch + '-'
        if ($select_clib -eq 'musl')
        {
            $pattern += $select_clib + '-'
        }
        $pattern += 'ROOTFS-.*\.tar.xz'

        return $pattern
    }

    function Get-VoidLinuxRootfsManifest()
    {
        $line = $sha256sum | Select-String -Pattern (Get-VoidLinuxRootfsPattern) | Select -First 1
        $pattern = '^SHA256 \(([^\)]+)\) = ([a-z0-9]+)$'

        $groups = [RegEx]::Matches($line, $pattern).groups
        return @{
            Name = $groups[1].value
            Sha256 = $groups[2].value
            Uri = "https://repo-default.voidlinux.org/live/current/" + $groups[1].value
        }
    }

    $manifest = Get-VoidLinuxRootfsManifest
    function Get-VoidLinuxRootfsFile()
    {
        if ($OutFile -eq "")
        {
            $OutFile = "$HOME\Downloads\" + $manifest.Name
        }

        if (Test-Path $OutFile -PathType Leaf)
        {
            return $OutFile
        }
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $manifest.Uri -OutFile $OutFile -UseBasicParsing
        $ProgressPreference = 'Continue'
        return $OutFile
    }

    $outfilePath = Get-VoidLinuxRootfsFile
    $outfileSha256 = (Get-FileHash -Path $outfilePath).Hash.ToLower()

    return [PSCustomObject]@{
        Name = $manifest.Name
        RemotePath = $manifest.Uri
        RemoteSha256 = $manifest.Sha256
        LocalPath = $outfilePath
        LocalSha256 = $outfileSha256
        Sha256CheckResult = ($outfileSha256 -eq $manifest.Sha256)
    }
}

function Import-VoidLinux()
{
    param(
        [Parameter(
            Mandatory=$true,
            Position=0,
            ValueFromPipeline=$true
        )]
        $RootfsPath,
        [string] $InstallPath,
        [string] $Distro
    )
    if ($RootfsPath.GetType() -ne "String")
    {
        $RootfsPath = ($RootfsPath).LocalPath
    }

    if ($Distro -eq "")
    {
        $Distro = "VoidLinux"
    }

    if ($InstallPath -eq "")
    {
        $InstallPath = "$ENV:LOCALAPPDATA\WSL\$Distro"
    }
    if (-not (Test-Path -Type Container -Path $InstallPath))
    {
        New-Item -Type Directory -Path $InstallPath
    }
    Write-Output @($InstallPath, $RootfsPath)
    Import-WSLDistro -Distro "$Distro" -InstallPath "$InstallPath" -FilePath "$RootfsPath"

    return $Distro
}

function Initialize-VoidLinux()
{
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [string] $Distro
    )

    wsl --user root -d $Distro -e xbps-install -Syu xbps

    $USERNAME = (Read-Host -Prompt "Please enter username ($Distro)")

    wsl --user root -d $Distro -- useradd -m -G wheel -s /bin/bash $USERNAME
    wsl --user root -d $Distro -- passwd $USERNAME

    $WSLCONF = "[user]
default=$USERNAME

[interop]
enabled=true
appendWindowsPath=false

[boot]
command=""/etc/runit/1 && /etc/runit/2 && /etc/runit/3""
"
    $ROOT = "\\wsl.localhost\$Distro"
    $ENC = New-Object System.Text.UTF8Encoding $false

    [System.IO.File]::WriteAllLines("$ROOT/etc/wsl.conf", $WSLCONF, $ENC)

    $WHEEL_SUDO = "%wheel ALL=(ALL:ALL) ALL"
    [System.IO.File]::WriteAllLines("$ROOT/etc/sudoers.d/wheel", $WHEEL_SUDO, $ENC)

    wsl --terminate $Distro
}
