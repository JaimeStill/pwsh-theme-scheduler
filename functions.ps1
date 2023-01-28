function Register-ThemeSchedule([string] $name, [DateTime] $time, [switch] $dark) {
    Unregister-ThemeSchedule $name;
    $action = Build-TaskAction -dark:$dark;
    $settings = Build-TaskSettings;
    $trigger = New-ScheduledTaskTrigger -Daily -At $time;
    $theme = if ($dark) { "dark" } else { "light" }

    Register-ScheduledTask -Action $action `
                           -Trigger $trigger `
                           -Settings $settings `
                           -TaskName $name `
                           -Description "Theme Scheduler: Set OS Theme to $theme" `
                           -Force
}

function Unregister-ThemeSchedule([string] $name) {
    if ($(Search-ThemeSchedule $name)) {
        Unregister-ScheduledTask -TaskName $name -Confirm:$false;
    }
}

function Search-ThemeSchedule([string] $name) {
    return Get-ScheduledTask | Where-Object {$_.TaskName -like $name }
}

function Build-TaskAction([switch] $dark) {
    return New-ScheduledTaskAction `
        -Execute 'pwsh.exe' `
        -Argument "-NoProfile -WindowStyle Hidden -Command $(Build-SystemThemeProperties -dark:$dark)";
}

function Build-TaskSettings {
    return New-ScheduledTaskSettingsSet -StartWhenAvailable `
                                        -RestartCount 3 `
                                        -RestartInterval ([TimeSpan]::FromMinutes(1))
}

function Build-SystemThemeProperties([switch] $dark) {
    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $system = "SystemUsesLightTheme"
    $apps = "AppsUseLightTheme"
    $value = if ($dark) { 0 } else { 1 }

    return "$(Build-SystemThemeValue $path $system $value);$(Build-SystemThemeValue $path $apps $value)"
}

function Build-SystemThemeValue([string] $path, [string] $name, [int] $value) {
    return "New-ItemProperty -Path $path -Name $name -Value $value -Type Dword -Force"
}