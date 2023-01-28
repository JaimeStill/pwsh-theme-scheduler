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

$system = Get-ThemeItems -Directory $env:SystemRoot\Resources\Themes
$local = Get-ThemeItems -Directory $env:LOCALAPPDATA\Microsoft\Windows\Themes

Write-ThemeList -Heading "System Themes:" -Themes $system
Write-Output $([System.String]::Empty)
Write-ThemeList -Heading "User Themes:" -Themes $local