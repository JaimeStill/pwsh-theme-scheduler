Not necessary here, but the following added to the top of a script file requires the script to be run as admin:

```PowerShell
#Requires -RunAsAdministrator
```

Build out the ability to change the Windows theme vs. color theme:

```PowerShell
$env:localappdata\Microsoft\Windows\Themes
$env:SystemRoot\Resources\Themes
```