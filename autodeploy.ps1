
#======================
#     FILE - PATH
#======================

# INTRO STRUCTURE:
# Key       - The name of file in the repostory
# Value[0]  - The destination path of configuration deployment
# Value[1]  - The name while copy file to the destination path

# INTRO VARIABLE:
# If one profile/configuration needs saved into different location between Windows or Unix,
# you need add them into $FILEPATH_WIN and $FILEPATH_UNIX. If one profile/configuration is saved
# into a same location in Windows or Unix, you can add them into $FILEPATH.
#
# $FILEPATH         - The same location is in Windows or Unix
# $FILEPATH_WIN     - The special location in Windows
# $FILEPATH_UNIX    - The special location in Unix

$FILEPATH = @{
    "init.vim" = @("~/.config/nvim/");
}

$FILEPATH_WIN = @{
    "profiles.json"                    = @("~/AppData/Local/Microsoft/'Windows Terminal'"); # Speicial processing while running with OS info
    "Microsoft.PowerShell_profile.ps1" = @("~/Documents/PowerShell/");
    "settings.json"                    = @("~/AppData/Roaming/Code/User/");
}

$FILEPATH_UNIX = @{
    ".tmux.conf" = @("~/");
}


#======================
#       FUNCTIONS 
#======================

function Autodeploy-CopyItem {
    param(
        [System.Collections.DictionaryEntry]$Item,
        [string]$Folder
    )
    try {
        Copy-Item -Path "$($Folder + $Item.Key)" -Destination "$($Item.Value[0])"
    }
    catch {
        New-Item -Path "$($Item.Value[0])" -ItemType Directory -Force
        Copy-Item -Path "$($Folder + $Item.Key)" -Destination "$($Item.Value[0])"
    }
}

function Autodeploy-RenameItem {
    param(
        [System.Collections.DictionaryEntry]$Item
    )
    Rename-Item -Path "$($Item.Value[0] + $Item.Key)" -NewName $Item.Value[1]
}

function Autodeploy-Item {
    param(
        [System.Collections.DictionaryEntry]$Item
    )
    Autodeploy-CopyItem -Item $Item -Folder "./"
    if ($Item.Value.Count -gt 1) {
        Autodeploy-RenameItem -Item $Item
    }
} 

#======================
#     RUN FROM HERE 
#======================
$List = @{ }
if (($PSVersionTable.Platform -eq "Win32NT") -or ($PSVersionTable.PSEdition -eq "Desktop")) {
    
    #    Speicial Path
    #----------------------

    #     List Combine
    #----------------------
    $List = $FILEPATH + $FILEPATH_WIN
}
elseif ($PSVersionTable.Platform -eq "Unix") {
    
    #    Speicial Path
    #----------------------

    #     List Combine
    #----------------------
    $List = $FILEPATH + $FILEPATH_UNIX
}
else {
    Write-Error "Sorry, the autodeploy script doesn't support ``$($PSVersionTable.Platform)' yet."
}

foreach ($i in $List.GetEnumerator()) {
    Autodeploy-Item -Item $i;
}