. .\functions\functions.ps1

function Register-ThemeModeSchedule([string] $Name, [DateTime] $Time, [switch] $Dark) {
    Unregister-Schedule $Name;
    $action = Build-ThemeModeAction -Dark:$Dark;
    $settings = Build-TaskSettings;
    $trigger = New-ScheduledTaskTrigger -Daily -At $Time;
    $theme = if ($Dark) { "dark" } else { "light" }

    Register-ScheduledTask -TaskName $Name `
                           -Action $action `
                           -Trigger $trigger `
                           -Settings $settings `
                           -Description "Theme Scheduler: Set OS Theme Mode to $theme" `
                           -Force
}
function Build-ThemeModeAction([switch] $Dark) {
    return New-ScheduledTaskAction `
        -Execute 'pwsh.exe' `
        -Argument "-NoProfile -WindowStyle Hidden -Command $(Build-ThemeModeProperties -Dark:$Dark)";
}

function Build-ThemeModeProperties([switch] $Dark) {
    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $system = "SystemUsesLightTheme"
    $apps = "AppsUseLightTheme"
    $value = if ($Dark) { 0 } else { 1 }

    return "$(Build-ThemeModeValue $path $system $value);$(Build-ThemeModeValue $path $apps $value)"
}

function Build-ThemeModeValue([string] $Path, [string] $Name, [int] $Value) {
    return "New-ItemProperty -Path $Path -Name $Name -Value $Value -Type Dword -Force"
}
