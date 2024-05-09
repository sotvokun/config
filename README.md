POSIX
```shell
git clone --bare https://github.com/sotvokun/config <local-path>
alias dotfiles='git --work-tree=$HOME --git-dir=<local-path>'
echo "*" > $HOME/.gitignore
```

Microsoft Windows
```powershell
git clone --bare https://github.com/sotvokun/config <local-path>
function dotfiles { iex "git --work-tree=$($env:USERPROFILE) --git-dir=<local-path> $($args -join ' ')" }
echo "*" > $env:USERPROFILE/.gitignore
```
