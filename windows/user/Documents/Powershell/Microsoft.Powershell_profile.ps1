# Reference: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles

# PS> update-help -uiculture en-US
# PS> set-executionpolicy -executionpolicy bypass -scope localmachine

# PS5 WIN> new-item -itemtype directory -path "$HOME\Documents\WindowsPowerShell\"
# PS5 WIN> notepad "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

# PS7 WIN> new-item -itemtype directory -path "$HOME\Documents\PowerShell\"
# PS7 WIN> notepad "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# PS7 LINUX> mkdir -pv ~/.config/powershell/
# PS7 LINUX> nano ~/.config/powershell/Microsoft.Powershell_profile.ps1

#######################################################################
# FUNCTIONS
#######################################################################

function adbopt    { adb shell cmd package bg-dexopt-job }
function chkpath   { $env:path -split ";" }
function codesrc   { code "${HOME}"/src }
function datenow   { (get-date).tostring("yyyyMMdd-ddd-HHmmss") }
function poweroff  { stop-computer -confirm -force }
function reboot    { restart-computer -confirm -force }
function wslbackup { wsl --export "Ubuntu" "$HOME\Desktop\ubuntu-$(get-date -uformat '%Y%m%d-%H%M%S').tar" }
function wsloff    { set-psdebug -trace 1; wsl --list --running; wsl --shutdown; wsl --list --running; set-psdebug -off }


#######################################################################
# PROMPT
#######################################################################

function prompt    { "$env:USERNAME@$env:COMPUTERNAME $(get-location)`r`nλ " }


#######################################################################
# MISC
#######################################################################

if (get-command starship -erroraction silentlycontinue) { invoke-expression (&starship init powershell) }
