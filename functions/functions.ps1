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