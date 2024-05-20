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
function prompt { "$env:USERNAME@$(hostname) $(get-location)`r`n$ " }
function reboot { restart-computer -confirm -force }

#######################################################################
# TASKS
#######################################################################

function wsl-backup {
	set-psdebug -trace 1
	wsl --export "Ubuntu" "$HOME\Desktop\ubuntu-$(get-date -uformat '%Y%m%d-%H%M%S').tar"
	set-psdebug -off
}

function wsl-shutdown {
	set-psdebug -trace 1
	wsl --list --running
	wsl --shutdown
	wsl --list --running
	set-psdebug -off
}

function wsl-enable {
	set-psdebug -trace 1
    write-output "`nEnabling WSL, Disabling Virtualbox`n"
    wsl --shutdown
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    wsl --shutdown
    write-output "`nReboot immediately for changes to take effect`n"
	set-psdebug -off
}

function wsl-disable {
	set-psdebug -trace 1
    write-output "`nDisabling WSL, Enabling Virtualbox`n"
    wsl --shutdown
    dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /all /norestart
    wsl --shutdown
    write-output "`nReboot immediately for changes to take effect`n"
	set-psdebug -off
}

function fix-os {
	set-psdebug -trace 1
    dism /online /cleanup-image /restorehealth /norestart
    sfc /scannow
    dism /online /cleanup-image /startcomponentcleanup /resetbase /norestart
	set-psdebug -off
}

function fix-disk {
	set-psdebug -trace 1
	cleanmgr /verylowdisk /tuneup:420 | Out-Null
    defrag c: /optimize /printprogress /verbose
	set-psdebug -off
}

function fix-network {
	set-psdebug -trace 1
	ipconfig /release
	ipconfig /release6
	ipconfig /flushdns
	ipconfig /renew
	ipconfig /renew6
	ipconfig /registerdns
	set-psdebug -off
}

function clean-chrome {
	set-psdebug -trace 1
    taskkill /f /t /im chrome.exe
    remove-item -literalpath $HOME\AppData\Local\Google\Chrome\ -confirm -force -recurse
	set-psdebug -off
}

function clean-edge {
	set-psdebug -trace 1
    taskkill /f /t /im msedge.exe
	taskkill /f /t /im msedgewebview2.exe
	remove-item -literalpath $HOME\AppData\Local\Microsoft\Edge\ -confirm -force -recurse
	set-psdebug -off
}

function clean-firefox {
	set-psdebug -trace 1
    taskkill /f /t /im firefox.exe
    remove-item -literalpath $HOME\AppData\Local\Mozilla\Firefox\ -confirm -force -recurse
    remove-item -literalpath $HOME\AppData\Roaming\Mozilla\Firefox\ -confirm -force -recurse
	set-psdebug -off
}

#######################################################################
# MISC
#######################################################################

if (get-command starship -erroraction silentlycontinue) { invoke-expression (&starship init powershell) }
