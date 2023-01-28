function Get-ThemeUrlBase([switch] $System) {
    if ($System) {
        return "$env:SystemRoot\Resources\Themes\"
    } else {
        return "$env:localappdata\Microsoft\Windows\Themes\"
    }
}

function Build-TaskSettings {
    return New-ScheduledTaskSettingsSet -StartWhenAvailable `
                                        -RestartCount 3 `
                                        -RestartInterval ([TimeSpan]::FromMinutes(1))
}

function Unregister-Schedule([string] $Name) {
    if ($(Search-Schedule $Name)) {
        Unregister-ScheduledTask -TaskName $Name -Confirm:$false;
    }
}

function Search-Schedule([string] $Name) {
    return Get-ScheduledTask | Where-Object {$_.TaskName -like $Name }
}

function Register-ThemeSchedule([string] $Name, [DateTime] $Time, [string] $Theme) {
    Unregister-Schedule $Name;
    $action = Build-ThemeAction -Theme $Theme;
    $settings = Build-TaskSettings;
    $trigger = New-ScheduledTaskTrigger -Daily -At $Time;
    
    Register-ScheduledTask -TaskName $Name `
                           -Action $action `
                           -Trigger $trigger `
                           -Settings $settings `
                           -Description "Theme Scheduler: Set OS Theme to $Theme" `
                           -Force
}

function Build-ThemeAction([string] $Theme) {
    return New-ScheduledTaskAction `
        -Execute 'pwsh.exe' `
        -Argument "-NoProfile -WindowStyle Hidden -Command $(Build-ThemeProcess $Theme)"
}

function Build-ThemeProcess([string] $Theme) {
    return "Start-Process -FilePath $Theme"
}

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
