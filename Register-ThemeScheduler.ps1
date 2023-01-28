#Requires -RunAsAdministrator

param(
    [DateTime]
    [Parameter()]
    $day = (Get-Date "8am"),
    [DateTime]
    [Parameter()]
    $night = (Get-Date "8pm")
)

. .\variables.ps1
. .\functions.ps1

Register-ThemeSchedule $lightName $day;
Register-ThemeSchedule $darkName $night -dark;