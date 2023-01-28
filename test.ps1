param(
    [switch]
    [Parameter()]
    $dark
)

. .\functions.ps1

Invoke-Expression $(Build-SystemThemeProperties -dark:$dark)