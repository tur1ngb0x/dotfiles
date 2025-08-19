
function prompt          { "$env:USERNAME@$env:COMPUTERNAME $(Get-Location)`n$ " }

function adb-opt         { date; adb kill-server; adb shell cmd package bg-dexopt-job; date }
function path            { $env:Path -split ";" }
function env             { Get-ChildItem Env: | ForEach-Object { "`$env:$($_.Name)`n$($_.Value)`n" } }
function code-wsl        { code --remote wsl+ubuntu /home/tur1ngb0x/src }
function datenow         { (Get-Date).ToString("yyyyMMdd-ddd-HHmmss") }
function pwshist         { (Get-PSReadLineOption).HistorySavePath }

function power-uefi      { shutdown.exe /fw /t 0 /f }
function power-lock      { rundll32.exe user32.dll,LockWorkStation }
function power-reboot    { shutdown.exe /r /t 0 /f }
function power-display   { (Add-Type '[DllImport("user32.dll")]public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name A -Pas)::SendMessage(-1,0x0112,0xF170,2) }
function power-shutdown  { shutdown.exe /s /t 0 /f }
function power-sleep     { rundll32.exe powrprof.dll,SetSuspendState 0,1,1 }

function fix-disk        { cleanmgr.exe /verylowdisk /sageset:420 | Out-Null; cleanmgr.exe /verylowdisk /sagerun:420 | Out-Null; defrag c: /optimize /printprogress /verbose }
function fix-drivers     { mkdir "$HOME/Desktop/driverbackup"; dism /online /export-driver /destination:"$HOME/Desktop/driverbackup" }
function fix-explorer    { taskkill.exe /F /T /IM explorer.exe; timeout.exe /T 2; start explorer.exe }
function fix-network     { ipconfig.exe /release; ipconfig.exe /release6; ipconfig.exe /flushdns; ipconfig.exe /renew; ipconfig.exe /renew6; ipconfig.exe /registerdns }
function fix-os          { dism.exe /online /cleanup-image /restorehealth /norestart; sfc.exe /scannow; dism.exe /online /cleanup-image /startcomponentcleanup /resetbase /norestart }

function linux-backup    { wsl.exe --export $args[0] $("X:\backups\$($args[0])-" + (Get-Date).ToString("yyyyMMdd-HHmmss") + ".tar") }

function linux-off       { wsl.exe --list --running; wsl.exe --shutdown; wsl.exe --list --running }
function linux-status    { wsl.exe --version; wsl.exe --status; wsl.exe --list --verbose }

function purge-brave     { Remove-Item "$HOME\AppData\Local\BraveSoftware\Brave-Browser\User Data" -Recurse -Force -Confirm }
function purge-chrome    { Remove-Item "$HOME\AppData\Local\Google\Chrome\User Data" -Recurse -Force -Confirm }
function purge-edge      { Remove-Item "$HOME\AppData\Local\Microsoft\Edge\User Data" -Recurse -Force -Confirm }
function purge-firefox   { Remove-Item "$HOME\AppData\Local\Mozilla\Firefox\Profiles" -Recurse -Force -Confirm; Remove-Item "$HOME\AppData\Roaming\Mozilla\Firefox\Profiles" -Recurse -Force -Confirm }

function tool-massgravel { irm "https://get.activated.win" | iex }
function tool-nerdfont   { & ([scriptblock]::Create((iwr 'https://to.loredo.me/Install-NerdFont.ps1'))) }
function tool-winutil    { irm "https://christitus.com/win" | iex }


If (Get-Command starship -ErrorAction SilentlyContinue) { Invoke-Expression (&starship init powershell) }
If (Get-Command scoop-search -ErrorAction SilentlyContinue) { Invoke-Expression (&scoop-search --hook) }
If (Get-Command oh-my-posh -ErrorAction SilentlyContinue) { Invoke-Expression (&oh-my-posh init pwsh) }
