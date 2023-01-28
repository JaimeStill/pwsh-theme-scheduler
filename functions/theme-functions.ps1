. .\functions\functions.ps1

function Get-ThemeItems([string] $Directory, [switch] $Recurse) {
    return @(Get-ChildItem $Directory -Filter *.theme -Recurse:$Recurse | Select-Object -Property Name)
}

function Write-ThemeList([string] $Heading, [PSCustomObject[]] $Themes) {
    Write-Output $Heading
    Write-Output "---"
    $Themes | ForEach-Object {
        Write-Output $_.Name
    }
}

function Get-ThemeUrlBase([switch] $System) {
    if ($System) {
        return "$env:SystemRoot\Resources\Themes\"
    } else {
        return "$env:localappdata\Microsoft\Windows\Themes\"
    }
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