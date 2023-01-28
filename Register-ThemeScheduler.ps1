param(
    [DateTime]
    [Parameter()]
    $DayTime = (Get-Date "8am"),
    [string]
    [Parameter(Mandatory)]
    $DayTheme,
    [switch]
    [Parameter()]
    $DaySystem,
    [DateTime]
    [Parameter()]
    $NightTime = (Get-Date "7pm"),
    [string]
    [Parameter(Mandatory)]
    $NightTheme,
    [switch]
    [Parameter()]
    $NightSystem
)

. .\variables.ps1
. .\functions.ps1

$DayUrl = "$(Get-ThemeUrlBase -System:$DaySystem)$DayTheme";
$NightUrl = "$(Get-ThemeUrlbase -System:$NightSystem)$NightTheme";

Register-ThemeSchedule $Day $DayTime $DayUrl;
Register-ThemeSchedule $Night $NightTime $NightUrl;