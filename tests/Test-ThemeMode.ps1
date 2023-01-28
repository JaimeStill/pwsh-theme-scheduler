param(
    [switch]
    [Parameter()]
    $Dark
)

. .\mode\mode-functions.ps1

Invoke-Expression $(Build-ThemeModeProperties -Dark:$Dark)