# Reference: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles

# PS> update-help -uiculture en-US
# PS> set-executionpolicy -executionpolicy bypass -scope localmachine

# PS5 WIN> new-item -itemtype directory -path "$HOME\Documents\WindowsPowerShell\"
# PS5 WIN> notepad "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

# PS7 WIN> new-item -itemtype directory -path "$HOME\Documents\PowerShell\"
# PS7 WIN> notepad "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# PS7 LINUX> mkdir -pv ~/.config/powershell/
# PS7 LINUX> nano ~/.config/powershell/Microsoft.Powershell_profile.ps1

# debug
# set-psdebug -trace 1
# commands
# set-psdebug -off

#######################################################################
# FUNCTIONS
#######################################################################
function adbopt { pet 'date; adb kill-server; adb shell cmd package bg-dexopt-job; date' }
function path { pet '$env:path -split ";"' }
function codewsl { pet 'code --remote wsl+ubuntu /home/tur1ngb0x/src'}
function datenow { pet '(get-date).tostring("yyyyMMdd-ddd-HHmmss")' }

function prompt {
	$pwsh_user = $env:username
	$pwsh_host = $env:computername.tolower()
	$pwsh_dir = get-location | select-object -expandproperty path
    Write-Host "`e[1m $pwsh_user@$pwsh_host `e[0m" -backgroundcolor green -foregroundcolor black -nonewline
    Write-Host " " -nonewline
    Write-Host "`e[1m $pwsh_dir `e[0m" -backgroundcolor blue -foregroundcolor black -nonewline
    return "`n $ "
}

function pet {
    param ([string]$command)
    write-host "# $command " -foregroundcolor black -backgroundcolor green
    invoke-expression $command
}

function power {
    param ([string]$action)
    switch ($action) {
        "shutdown" { stop-computer -confirm -force }
        "reboot" { restart-computer -confirm -force }
        "sleep" { rundll32.exe powrprof.dll,SetSuspendState 0,1,1 }
        "screen" {(Add-Type '[DllImport("user32.dll")]public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2) }
        default {
            $help = @"

options     summary

screen      switch off displays
sleep       switch to s3 sleep state
reboot      restart the computer
shutdown    power off the computer
"@
            write-host $help
        }
    }
}

function fix {
    param ([string]$action)
    switch ($action) {
        "disk" {
            pet 'cleanmgr /verylowdisk /sageset:420 | out-null'
            pet 'cleanmgr /verylowdisk /sagerun:420 | out-null'
            pet 'defrag c: /optimize /printprogress /verbose'
        }
        "network" {
            pet 'ipconfig /release'
            pet 'ipconfig /release6'
            pet 'ipconfig /flushdns'
            pet 'ipconfig /renew'
            pet 'ipconfig /renew6'
            pet 'ipconfig /registerdns'
        }
        "os" {
            pet 'dism /online /cleanup-image /restorehealth /norestart'
            pet 'sfc /scannow'
            pet 'dism /online /cleanup-image /startcomponentcleanup /resetbase /norestart'
        }
        default {
            $help = @"

options     summary

disk        clean junk, trim blocks
network     release ip, flush dns, renew dns, register dns
os          repair image, repair system, clean updates

"@
            write-host $help
        }
    }
}

function linux {
    param (
        [string]$action
    )
    switch ($action) {
        "backup" {
            pet 'wsl --export Ubuntu $HOME\desktop\Ubuntu-$((get-date).tostring("yyyymmdd-ddd-hhmmss")).tar'
        }
        "disable" {
            pet 'dism /online /disable-feature /featurename:microsoft-windows-subsystem-linux /all /norestart'
            pet 'dism /online /disable-feature /featurename:virtualmachineplatform /all /norestart'
        }
        "enable" {
            pet 'dism /online /enable-feature /featurename:microsoft-windows-subsystem-linux /all /norestart'
            pet 'dism /online /enable-feature /featurename:virtualmachineplatform /all /norestart'
        }
        "shutdown" {
            pet 'wsl --list --running'
            pet 'wsl --shutdown'
            pet 'start-sleep -seconds 15'
            pet 'wsl --list --running'
        }
        default {
            $help = @"

options     summary

backup      dump ubuntu image to desktop
disable     disable wsl for using virtualbox
enable      enable wsl for using wsl
shutdown    shutdown all running instances of wsl

"@
            write-host $help
        }
    }
}

function purge {
    param (
        [string]$action
    )
    switch ($action) {
        "brave" {
            pet 'taskkill /f /t /im brave.exe'
            pet 'remove-item -literalpath "$HOME\AppData\Local\BraveSoftware\Brave-Browser\User Data\" -confirm -force -recurse'
        }
        "chrome" {
            pet 'taskkill /f /t /im chrome.exe'
            pet 'remove-item -literalpath "$HOME\AppData\Local\Google\Chrome\User Data\" -confirm -force -recurse'
        }
        "edge" {
            pet 'taskkill /f /t /im msedge.exe'
            pet 'taskkill /f /t /im msedgewebview2.exe'
            pet 'remove-item -literalpath "$HOME\AppData\Local\Microsoft\Edge\User Data\" -confirm -force -recurse'
        }
        "firefox" {
            pet 'taskkill /f /t /im firefox.exe'
            pet 'remove-item -literalpath "$HOME\AppData\Local\Mozilla\Firefox\Profiles\" -confirm -force -recurse'
            pet 'remove-item -literalpath "$HOME\AppData\Roaming\Mozilla\Firefox\Profiles\" -confirm -force -recurse'
        }
        default {
            $help = @"

options     summary

brave       delete all brave user profiles
chrome      delete all chrome user profiles
edge        delete all edge user profiles
firefox     delete all firefox user profiles

"@
            write-host $help
        }
    }
}

#######################################################################
# MISC
#######################################################################
#if (get-command starship -erroraction silentlycontinue) { invoke-expression (&starship init powershell) }
#if (get-command scoop-search -erroraction silentlycontinue) { invoke-expression (&scoop-search --hook) }
#if (get-command pwsh -erroraction silentlycontinue) { invoke-expression (&oh-my-posh init pwsh) }
