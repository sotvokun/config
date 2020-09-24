
#======================
#       FUNCTIONS 
#======================
# Get INI file content
# https://devblogs.microsoft.com/scripting/use-powershell-to-work-with-any-ini-file/
# ---------------------
function Get-IniContent($filePath)
{
    $ini = @{}
    switch -regex -file $filePath
    {
        "^\[(.+)\]"
        {
            $section = $Matches[1]
            $ini[$section] = @{}
        }
        "(.+?)\s*=\s*(.*)"
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value
        }
    }
    return $ini
}

# Get current platform
# ---------------------
function Get-PlatformInformation()
{
    if (($PSVersionTable.Platform -eq "Win32NT") -or ($PSVersionTable.PSEdition -eq "Desktop")) 
    {
        return "nt"
    }
    elseif ($PSVersionTable.Platform -eq "Unix") 
    {
        return "unix"
    }
    else 
    {
        return ""
    }
}

# Get value of definition
# ---------------------
function Get-DefinitionValue($obj, $name)
{
    return $obj["define"][$name]
}

#======================
#     RUN FROM HERE 
#======================
$ini = Get-IniContent ./deploy.ini
switch (Get-PlatformInformation)
{
    "nt"   { $platform = "location.windows" }
    "unix" { $platform = "location.unix"    }
    ""     { throw "Unsupported operation system" }
}
foreach ($key in $ini[$platform].Keys)
{
    $src = $key
    $dst = $ini[$platform][$key]
    if ($key[0] -eq "@")
    {
        $src = Get-DefinitionValue -obj $ini -name $key
    }
    try
    {
        Copy-Item -Path $src -Destination $dst
    }
    catch
    {
        if ($dst[$dst.Length - 1] -eq "/" -or $dst[$dst.Length - 1] -eq "\\")
        {
            New-Item -Path $dst -ItemType Directory -Force
        }
        else
        {
            New-Item -Path $dst -ItemType File -Force
        }
        Copy-Item -Path $src -Destination $dst -Force
    }
}