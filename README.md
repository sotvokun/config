This repository contains some program profiles that I using frequently.

## Requires
To deploy profile automatically, the following programs are necessary:
- `lua` `version >= 5.2`

For Microsoft Windows, you should promise PowerShell is available.

## Usage
```
> lua deploy.lua
```

## Custom
Open `deploy.lua` file with favorite text editor, then edit the `deploy_list`.

To define a new deployment, the two arguments are necessary: the profile path in the repository and the target path. The deployment procedure will link or copy the first to the second.
```lua
{"windows/terminal.json", "~/AppData/Local/Microsoft/Windows Terminal/settings.json"}
```

By default, the deployment procedure will deploy the file or folder to the second path on any OS. But for some programs, the content of profile is compatible on any OS, but the path is different. We can specify the path for Microsoft Windows (`win`) or all others (`unix`).
```lua
{
    'windows/Microsoft.PowerShell_profile.ps1',
    {
        win = '~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1',
        unix = '~/.config/powershell/Microsoft.PowerShell_profile.ps1'
    }
},
```

Some programs are special OS only, to ignore on another OS, just define the path for which OS that program running on.
```lua
{'unix/.bashrc', {unix='~/.bashrc'}}
```

Some programs profiles is complicated, like the emacs or vim, we also can deploy the foler. Just set the folder option.
```lua
{'nvim', {unix = '~/.config/nvim'}, folder=true}
```

The default deployment action is linking, but sometimes we do not have permission to create the symbolic link. We set the deployment action is copy.
```lua
{
    'common/vscode_settings.json',
    {win = '~/AppData/Roaming/Code/User/settings.json'}
    copy=true
},
```

**WINDOWS 10 DISABLED THE PERMISSION TO CREATE SYMBOLIC LINK AS NORMAL USER. FOR COMPATIBLE, PLEASE USE COPY FOR MOST SUITATIONS**

### Ignore deployment
There are too many reason that we can stop use a software, we also can ignore a deployment if we do not need it.

The easiest way is to delete it in the `deploy_list`.

If we just pause using temporarily, we can set the target path to empty table or empty string, or set the ignore option.
```lua
{'unix/.bashrc', {}}
-- equavalent
{'unix/.bashrc', ""}
-- equavalent
{'unix/.bashrc', {unix='~/.bashrc'}, ignore=true}
```
