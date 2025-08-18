# FUNCTIONS
function adb-opt  { date; pet 'adb kill-server; adb shell cmd package bg-dexopt-job'; date }
function path     { pet '$env:Path -split ";"' }
function env      { Get-ChildItem Env: | ForEach-Object { "`$env:$($_.Name)`n$($_.Value)`n" } }
function code-wsl { pet 'code --remote wsl+ubuntu /home/tur1ngb0x/src' }
function datenow  { pet '(Get-Date).ToString("yyyyMMdd-ddd-HHmmss")' }
function pwshist  { (Get-PSReadLineOption).HistorySavePath }

function prompt {
    $pwshUser = $env:USERNAME
    $pwshHost = ($env:COMPUTERNAME).ToLower()
    $pwshDir  = (Get-Location).Path
    $pwshGit  = git branch --show-current 2>$null

    Write-Host "$pwshUser@$pwshHost" -ForegroundColor Green  -NoNewline
    Write-Host " "                   -NoNewline
    Write-Host "$pwshDir"            -ForegroundColor Cyan   -NoNewline
    Write-Host " "                   -NoNewline
    Write-Host "$pwshGit"            -ForegroundColor Yellow -NoNewline

    return "`n$ "
}

function pet {
    Param ([String]$Command)
    Write-Host " # $Command " -ForegroundColor Black -BackgroundColor Green
    Invoke-Expression $Command
}


function power {
    Param ([String]$Action)
    Switch ($Action) {
        "firmware" { shutdown.exe /fw /t 0 /f }
        "lock"     { rundll32.exe user32.dll,LockWorkStation }
        "reboot"   { shutdown.exe /r /t 0 /f}
        "screen"   { (Add-Type '[DllImport("user32.dll")]public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name A -Pas)::SendMessage(-1,0x0112,0xF170,2) }
        "shutdown" { shutdown.exe /s /t 0 /f }
        "sleep"    { rundll32.exe powrprof.dll,SetSuspendState 0,1,1 }
        default    {
            $help = @"
OPTIONS     SUMMARY
firmware	restart into firmware setup
lock        lock the computer
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
            pet 'ipconfig.exe /release'
            pet 'ipconfig.exe /release6'
            pet 'ipconfig.exe /flushdns'
            pet 'ipconfig.exe /renew'
            pet 'ipconfig.exe /renew6'
            pet 'ipconfig.exe /registerdns'
        }
        "os" {
            pet 'dism.exe /online /cleanup-image /restorehealth /norestart'
            pet 'sfc.exe /scannow'
            pet 'dism.exe /online /cleanup-image /startcomponentcleanup /resetbase /norestart'
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

function wslinux {
    Param ([String]$Action)
    Switch ($Action) {
        "backup" {
            pet 'wsl.exe --export ubuntu "X:\backups\ubuntu-$((Get-Date).ToString('yyyyMMdd-ddd-HHmmss')).tar"'
            pet 'wsl.exe --export debian "X:\backups\debian-$((Get-Date).ToString('yyyyMMdd-ddd-HHmmss')).tar"'
            pet 'wsl.exe --export fedora "X:\backups\fedora-$((Get-Date).ToString('yyyyMMdd-ddd-HHmmss')).tar"'
            pet 'wsl.exe --export arch "X:\backups\arch-$((Get-Date).ToString('yyyyMMdd-ddd-HHmmss')).tar"'
        }
        "off" {
            pet 'wsl.exe --list --running'
            pet 'wsl.exe --shutdown'
            pet 'wsl.exe --list --running'
        }
        "status" {
            pet 'wsl.exe --version'
            pet 'wsl.exe --status'
            pet 'wsl.exe --list --verbose'

        }
        default { Write-Host "Arguments: backup, off, status" }
    }
}

function purge {
    Param ([String]$Action)
    Switch ($Action) {
        "brave" {
            pet 'spps -Name "brave" -Force -Confirm'
            pet 'rm "$HOME\AppData\Local\BraveSoftware\Brave-Browser\User Data" -Recurse -Force -Confirm'
        }
        "chrome" {
            pet 'spps -Name "chrome" -Force -Confirm'
            pet 'rm "$HOME\AppData\Local\Google\Chrome\User Data" -Recurse -Force -Confirm'
        }
        "edge" {
            pet 'spps -Name "msedge" -Force -Confirm'
            pet 'spps -Name "msedgewebview2" -Force -Confirm'
            pet 'rm "$HOME\AppData\Local\Microsoft\Edge\User Data" -Recurse -Force -Confirm'
        }
        "firefox" {
            pet 'spps -Name "firefox" -Force -Confirm'
            pet 'rm "$HOME\AppData\Local\Mozilla\Firefox\Profiles" -Recurse -Force -Confirm'
            pet 'rm "$HOME\AppData\Roaming\Mozilla\Firefox\Profiles" -Recurse -Force -Confirm'
        }
        default { Write-Host "Options: brave | chrome | edge | firefox" }
    }
}

#######################################################################
# MISC
#######################################################################
# If (Get-Command starship) { Invoke-Expression (&starship init powershell) }
# If (Get-Command scoop-search) { Invoke-Expression (&scoop-search --hook) }
# If (Get-Command pwsh) { Invoke-Expression (&oh-my-posh init pwsh) }
