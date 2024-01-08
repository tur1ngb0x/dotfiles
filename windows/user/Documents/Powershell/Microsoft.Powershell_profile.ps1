# Reference: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles

# PS> update-help -uiculture en-US
# PS> set-executionpolicy -executionpolicy bypass -scope localmachine

# PS5 WIN> new-item -itemtype directory -path "$HOME\Documents\WindowsPowerShell\"
# PS5 WIN> notepad "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

# PS7 WIN> new-item -itemtype directory -path "$HOME\Documents\PowerShell\"
# PS7 WIN> notepad "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# PS7 LINUX> mkdir -pv ~/.config/powershell/
# PS7 LINUX> nano ~/.config/powershell/Microsoft.Powershell_profile.ps1

function adb-opt { date; adb shell cmd package bg-dexopt-job; date }
function poweroff { stop-computer -confirm -force }
function prompt { "$env:USERNAME@$env:COMPUTERNAME $(get-location)`r`n-> " }
function reboot { restart-computer -confirm -force }
function wsl-backup { wsl --export "Ubuntu" "$HOME\Desktop\ubuntu-$(get-date -uformat '%Y%m%d-%H%M%S').tar" }
function wsl-off { set-psdebug -trace 1; wsl --list --running; wsl --shutdown; start-sleep 20; wsl --list --running; set-psdebug -off }

if (get-command starship -erroraction silentlycontinue) { invoke-expression (&starship init powershell) }
