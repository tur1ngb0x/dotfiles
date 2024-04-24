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

function adbopt { date; adb shell cmd package bg-dexopt-job; date }
function chkpath { $env:path -split ";" }
function codesrc { code "${HOME}"/src }
function datenow { (get-date).tostring("yyyyMMdd-ddd-HHmmss") }
function poweroff { stop-computer -confirm -force }
function prompt { "$env:USERNAME@$env:COMPUTERNAME $(get-location)`r`nλ " }
function reboot { restart-computer -confirm -force }
function wsl-backup { wsl --export "Ubuntu" "$HOME\Desktop\ubuntu-$(get-date -uformat '%Y%m%d-%H%M%S').tar" }
function wsl-shutdown { set-psdebug -trace 1; wsl --list --running; wsl --shutdown; wsl --list --running; set-psdebug -off }

function wsl-enable {
    write-output "`nEnabling WSL, Disabling Virtualbox`n"
    wsl --shutdown
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    wsl --shutdown
    write-output "`nReboot immediately for changes to take effect`n"
}

function wsl-disable {
    write-output "`nDisabling WSL, Enabling Virtualbox`n"
    wsl --shutdown    
    dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /all /norestart
    wsl --shutdown
    write-output "`nReboot immediately for changes to take effect`n"
}
    
function fix-os {
    dism /online /cleanup-image /restorehealth /norestart
    sfc /scannow
    dism /online /cleanup-image /startcomponentcleanup /resetbase /norestart
}

function fix-disk {
    cleanmgr /verylowdisk /sageset:420
    cleanmgr /verylowdisk /sagerun:420
    defrag c: /optimize /printprogress /verbose
}

#######################################################################
# MISC
#######################################################################

if (get-command starship -erroraction silentlycontinue) { invoke-expression (&starship init powershell) }
