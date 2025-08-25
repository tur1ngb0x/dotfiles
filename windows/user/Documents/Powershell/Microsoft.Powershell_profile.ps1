
# Set-PSReadLineOption     -PredictionViewStyle ListView
Set-PSReadLineOption     -PredictionSource History
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Remove-Item Alias:* -Force
set-alias cat get-content -Option AllScope -Force
set-alias cd set-location -Option AllScope -Force
set-alias clear clear-host -Option AllScope -Force
set-alias cp copy-item -Option AllScope -Force
set-alias echo write-output -Option AllScope -Force
set-alias history get-history -Option AllScope -Force
set-alias man get-help -Option AllScope -Force
set-alias mv move-item -Option AllScope -Force
set-alias popd pop-location -Option AllScope -Force
set-alias pushd push-location -Option AllScope -Force
set-alias ps get-process -Option AllScope -Force
set-alias pwd get-location -Option AllScope -Force
set-alias ren rename-item -Option AllScope -Force
set-alias rm remove-item -Option AllScope -Force
set-alias rmdir remove-item -Option AllScope -Force
set-alias tee tee-object -Option AllScope -Force

function prompt          { "$env:USERNAME@$env:COMPUTERNAME $(Get-Location)`n$ " }
function adb-opt         { Get-Date; adb.exe kill-server; adb.exe shell cmd package bg-dexopt-job; Get-Date }
function code-wsl        { code --remote wsl+ubuntu /home/tur1ngb0x/src }
function today           { (Get-Date).ToString("yyyyMMdd-ddd-HHmmss") }
function env             { Get-ChildItem Env: | ForEach-Object { "`$env:$($_.Name)`n$($_.Value)`n" } }
function path            { $env:Path -split ";" }
function pwshist         { (Get-PSReadLineOption).HistorySavePath }

function power-uefi      { shutdown.exe /fw /t 0 /f }
function power-logoff    { shutdown.exe /l /t 0 /f }
function power-lock      { rundll32.exe user32.dll,LockWorkStation }
function power-reboot    { shutdown.exe /r /t 0 /f }
function power-hibernate { shutdown.exe /h /t 0 /f}
function power-display   { (Add-Type '[DllImport("user32.dll")]public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name A -Pas)::SendMessage(-1,0x0112,0xF170,2) }
function power-shutdown  { shutdown.exe /s /t 0 /f }
function power-sleep     { rundll32.exe powrprof.dll,SetSuspendState 0,1,1 }

function cpsync {
    if ($args.Count -eq 0) { Write-Host 'syntax: cpsync <source> <destination>'; return }
    robocopy.exe /V /E /Z /ETA /R:2880 /W:30 $args
}

function fix-disk {
    if ($args.Count -gt 0) { Write-Host 'syntax: fix-disk'; return }
    cleanmgr.exe /verylowdisk /sageset:420 | Out-Null
    cleanmgr.exe /verylowdisk /sagerun:420 | Out-Null
    defrag c: /optimize /printprogress /verbose
}

function fix-os {
    if ($args.Count -gt 0) { Write-Host 'syntax: fix-os'; return }
    dism.exe /online /cleanup-image /restorehealth /norestart
    sfc.exe /scannow
    dism.exe /online /cleanup-image /startcomponentcleanup /resetbase /norestart
}

function fix-drivers {
    if ($args.Count -eq 0) { Write-Host 'syntax: fix-drivers <path>'; return }
    New-Item -ItemType Directory -Path $args[0] -Force
    Export-WindowsDriver -Online -Destination $args[0]
}

function linux-backup {
    if ($args.Count -eq 0) { wsl.exe --list --verbose; Write-Host "`nsyntax: linux-backup <distro>"; return }
    wsl.exe --export $args[0] ("X:\backups\" + $args[0] + "-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".tar")
}

function linux-off {
    if ($args.Count -eq 0)                         { wsl.exe --list --running; Write-Host "syntax: linux-off <distro> | all"; return }
    if ($args.Count -eq 1 -and $args[0] -eq 'all') { wsl.exe --shutdown; return }
    if ($args.Count -eq 1)                         { wsl.exe --terminate $args[0]; return }
    Write-Host "syntax: linux-off <distro>|all"
}

function linux-status {
	if ($args.Count -gt 0) { Write-Host 'syntax: linux-status'; return }
	wsl.exe --version; wsl.exe --status; wsl.exe --list --verbose
}

function purge-brave   { Remove-Item "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data" -Recurse -Force -Confirm }
function purge-chrome  { Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data" -Recurse -Force -Confirm }
function purge-edge    { Remove-Item "$env:LOCALAPPDATA\Microsoft\Edge\User Data" -Recurse -Force -Confirm }
function purge-firefox { Remove-Item "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles","$env:APPDATA\Mozilla\Firefox\Profiles" -Recurse -Force -Confirm }

function tool-massgravel { Invoke-RestMethod "https://get.activated.win" | Invoke-Expression }
function tool-nerdfont   { & ([scriptblock]::Create((Invoke-WebRequest 'https://to.loredo.me/Install-NerdFont.ps1'))) }
function tool-winutil    { Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression }

If (Get-Command starship -ErrorAction SilentlyContinue)     { Invoke-Expression (&starship init powershell) }
If (Get-Command scoop-search -ErrorAction SilentlyContinue) { Invoke-Expression (&scoop-search --hook) }
If (Get-Command eza -ErrorAction SilentlyContinue)          { function ls { eza --all --long --time-style '+%Y-%m-%d %H:%M' --header --icons=always --hyperlink --no-symlinks @args } }
