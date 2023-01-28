#Requires -RunAsAdministrator

. .\variables.ps1
. .\functions.ps1

Unregister-ThemeSchedule $lightName;
Unregister-ThemeSchedule $darkName;