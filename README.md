Configuration File Repository for Windows and Unix-like Systems

**USAGE**<br/>
1. copy or clone this repository in somewhere you like.
2. execute powershell script for windows, or shell script for unix-like system.

**FOR SHELL SCRIPTS**<br/>
```sh
# for unix-like shells
for filename in $HOME/.config/bash/*.sh; do
    . "$filename"
done
```

```ps1
# for powershell in windows
Foreach ($item in (Get-ChildItem "$ENV:USERPROFILE/.config/pwsh"))
{
    . "$($item.FullName)"
}
```

