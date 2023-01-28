param(
    [DateTime]
    [Parameter()]
    $LightTime = (Get-Date "8am"),
    [DateTime]
    [Parameter()]
    $DarkTime = (Get-Date "8pm")
)

. .\variables.ps1
. .\functions.ps1

Register-ThemeModeSchedule $Light $LightTime;
Register-ThemeModeSchedule $Dark $DarkTime -Dark;