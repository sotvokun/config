This repository stored all configuration files of my frequent using softwares.

## USAGE
1. Editing `deploy.ini` make sure that all configuration files can be copy to corret distination.
2. Run the `deploy.ps1` script in the PowerShell Core or Windows PowerShell

## DEPLOY.INI
`deploy.ini` is a key-value configuration file, it has three sections in its content. The sections has some difference between themselves.
### Section `[define]`
In section `[define]` you can give the alias to some profiles, but alias must start with `@` symbol. You can define some cross-platform programs' profiles in this section, thereforce you don't need maintain two files to Windows or *nix.
```
@name = file_path
```

### Section `[location.*]`
In section `[location.windows]` or `[location.unix]` you need to define the path of profile and where its deploy desitination path is.
```
file_path_or_alias = distination_path
```
If the `distination_path` end with character `\` or `/` , the deploy script will copy the file into the distination folder. But if the `distination_path` end without the slash mark, the deploy script will copy into distination path and rename to the new name.

## CHANGELOG OF AUTODEPLOY SCRIPT
- 2019-12-16 First Release
- 2020-09-25 New version with readable deploying configuration

## KNOWN ISSUE OF AUTODEPLOY SCRIPT
_Unknown currently_