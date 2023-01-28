. .\variables.ps1;
. .\functions\functions.ps1;
. .\functions\mode-functions.ps1;
. .\functions\theme-functions.ps1;

function Get-AvailableThemes {
    $system = Get-ThemeItems -Directory $env:SystemRoot\Resources\Themes
    $local = Get-ThemeItems -Directory $env:LOCALAPPDATA\Microsoft\Windows\Themes

    Write-ThemeList -Heading "System Themes:" -Themes $system
    Write-Output "`n"
    Write-ThemeList -Heading "User Themes:" -Themes $local
}

function Register-ModeScheduler {
    param(
        [DateTime]
        [Parameter()]
        $LightTime = (Get-Date "8am"),
        [DateTime]
        [Parameter()]
        $DarkTime = (Get-Date "8pm")
    )

    Register-ThemeModeSchedule $Light $LightTime;
    Register-ThemeModeSchedule $Dark $DarkTime -Dark;
}

function Unregister-ModeScheduler {
    Unregister-Schedule $Light;
    Unregister-Schedule $Dark;
}

function Register-ThemeScheduler {
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

    $DayUrl = "$(Get-ThemeUrlBase -System:$DaySystem)$DayTheme";
    $NightUrl = "$(Get-ThemeUrlbase -System:$NightSystem)$NightTheme";

    Register-ThemeSchedule $Day $DayTime $DayUrl;
    Register-ThemeSchedule $Night $NightTime $NightUrl;
}

function Unregister-ThemeScheduler {
    Unregister-Schedule $Day;
    Unregister-Schedule $Night;
}