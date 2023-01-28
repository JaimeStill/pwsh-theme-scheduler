param(
    [switch]
    [Parameter()]
    $Dark
)

. .\functions.ps1

Invoke-Expression $(Build-ThemeModeProperties -Dark:$Dark)