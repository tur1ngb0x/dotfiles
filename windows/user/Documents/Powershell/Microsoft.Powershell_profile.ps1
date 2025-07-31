# Reference: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles

# CMD> setx PROMPT "$P$G"
# CMD> setx PROMPT "%USERNAME%@%COMPUTERNAME% $P$_$$ "

# PS> Update-Help -UICulture en-US
# PS> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

# PS5 WIN> New-Item -ItemType Directory -Path "$HOME\Documents\WindowsPowerShell\"
# PS5 WIN> Notepad "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

# PS7 WIN> New-Item -ItemType Directory -Path "$HOME\Documents\PowerShell\"
# PS7 WIN> Notepad "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# PS7 LINUX> mkdir -pv ~/.config/powershell/
# PS7 LINUX> nano ~/.config/powershell/Microsoft.Powershell_profile.ps1

# Debug
# Set-PSDebug -Trace 1
# Commands
# Set-PSDebug -Off

# Get History
# Get-PSReadlineOption

#######################################################################
# FUNCTIONS
#######################################################################
function adb-opt { date; pet 'adb kill-server; adb shell cmd package bg-dexopt-job'; date }
function path { pet '$env:Path -split ";"' }
function env { Get-ChildItem Env: | ForEach-Object { "`$env:$($_.Name)`n$($_.Value)`n" } }
function code-wsl { pet 'code --remote wsl+ubuntu /home/tur1ngb0x/src' }
function datenow { pet '(Get-Date).ToString("yyyyMMdd-ddd-HHmmss")' }


# function prompt {
#     # Data
#     $pwshUser = $env:USERNAME
#     $pwshHost = $env:COMPUTERNAME.ToLower()
#     $pwshDir  = (Get-Location).Path

#     Write-Host "$pwshUser@$pwshHost" -ForegroundColor Green -NoNewline
#     Write-Host " "                   -NoNewline
#     Write-Host "$pwshDir"            -ForegroundColor Cyan  -NoNewline

#     if ($NestedPromptLevel -ge 1) {
#         return "`n$NestedPromptLevel→ "
#     }
#     else {
#         return "`n→ "
#     }
# }

function prompt {
    $pwshUser = $env:USERNAME
    $pwshHost = $env:COMPUTERNAME.ToLower()
    $pwshDir  = (Get-Location).Path
    Write-Host "$pwshUser@$pwshHost" -ForegroundColor Green -NoNewline
    Write-Host " "                  -NoNewline
    Write-Host "$pwshDir"           -ForegroundColor Cyan  -NoNewline

    if ($NestedPromptLevel -ge 1) {
        return "`n$NestedPromptLevel→ "
    }
    else {
        return "`n→ "
    }
}

function pet {
    Param ([String]$Command)
    Write-Host " # $Command " -ForegroundColor Black -BackgroundColor Green
    Invoke-Expression $Command
}

function power {
    Param ([String]$Action)
    Switch ($Action) {
        "reboot" { Shutdown /R /F /T 0 }
        "screen" { (Add-Type '[DllImport("user32.dll")]public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name A -Pas)::SendMessage(-1,0x0112,0xF170,2) }
        "shutdown" { Shutdown /S /F /T 0 }
        "sleep" { Rundll32 powrprof.dll,SetSuspendState 0,1,1 }
        default {
            $help = @"
OPTIONS     SUMMARY
reboot      restart the computer
screen      switch off displays
shutdown    power off the computer
sleep       switch to s3 sleep state
"@
            Write-Host $help
        }
    }
}

function fix {
    Param ([String]$Action)
    Switch ($Action) {
        "disk" {
            pet 'cleanmgr.exe /verylowdisk /sageset:420 | Out-Null'
            pet 'cleanmgr.exe /verylowdisk /sagerun:420 | Out-Null'
            pet 'defrag c: /optimize /printprogress /verbose'
        }
        "explorer" {
            pet 'taskkill.exe /F /T /IM explorer.exe'
            pet 'timeout.exe /T 2'
            pet 'start explorer.exe'
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
OPTIONS     SUMMARY
disk        clean junk, trim blocks
explorer    restart explorer.exe
network     release ip, flush dns, renew dns, register dns
os          repair image, repair system, clean updates
"@
            Write-Host $help
        }
    }
}

function linux {
    Param ([String]$Action)
    Switch ($Action) {
        "backup" {
            pet 'wsl --export Ubuntu $HOME\Desktop\Ubuntu-$((Get-Date).ToString("yyyyMMdd-ddd-HHmmss")).tar'
        }
        "disable" {
            pet 'dism /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart'
            pet 'dism /online /disable-feature /featurename:VirtualMachinePlatform /all /norestart'
        }
        "enable" {
            pet 'dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart'
            pet 'dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart'
        }
        "shutdown" {
            pet 'wsl --list --running'
            pet 'wsl --shutdown'
            pet 'Start-Sleep -Seconds 15'
            pet 'wsl --list --running'
        }
        default {
            $help = @"
OPTIONS     SUMMARY
backup      dump ubuntu image to desktop
disable     disable wsl for using virtualbox
enable      enable wsl for using wsl
shutdown    shutdown all running instances of wsl
"@
            Write-Host $help
        }
    }
}

function purge {
    Param ([String]$Action)
    Switch ($Action) {
        "brave" {
            pet 'taskkill /F /T /IM brave.exe'
            pet 'Remove-Item -LiteralPath "$HOME\AppData\Local\BraveSoftware\Brave-Browser\User Data\" -Confirm -Force -Recurse'
        }
        "chrome" {
            pet 'taskkill /F /T /IM chrome.exe'
            pet 'Remove-Item -LiteralPath "$HOME\AppData\Local\Google\Chrome\User Data\" -Confirm -Force -Recurse'
        }
        "edge" {
            pet 'taskkill /F /T /IM msedge.exe'
            pet 'taskkill /F /T /IM msedgewebview2.exe'
            pet 'Remove-Item -LiteralPath "$HOME\AppData\Local\Microsoft\Edge\User Data\" -Confirm -Force -Recurse'
        }
        "firefox" {
            pet 'taskkill /F /T /IM firefox.exe'
            pet 'Remove-Item -LiteralPath "$HOME\AppData\Local\Mozilla\Firefox\Profiles\" -Confirm -Force -Recurse'
            pet 'Remove-Item -LiteralPath "$HOME\AppData\Roaming\Mozilla\Firefox\Profiles\" -Confirm -Force -Recurse'
        }
        default {
            $help = @"
OPTIONS     SUMMARY
brave       delete all brave user profiles
chrome      delete all chrome user profiles
edge        delete all edge user profiles
firefox     delete all firefox user profiles
"@
            Write-Host $help
        }
    }
}

#######################################################################
# MISC
#######################################################################
# If (Get-Command starship -ErrorAction SilentlyContinue) { Invoke-Expression (&starship init powershell) }
# If (Get-Command scoop-search -ErrorAction SilentlyContinue) { Invoke-Expression (&scoop-search --hook) }
# If (Get-Command pwsh -ErrorAction SilentlyContinue) { Invoke-Expression (&oh-my-posh init pwsh) }
