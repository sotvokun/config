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
