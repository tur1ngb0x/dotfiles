#######################################################################################################################
# Readline
#######################################################################################################################
# Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView





#######################################################################################################################
# Alias
#######################################################################################################################
Remove-Item Alias:* -Force





#######################################################################################################################
# Functions
#######################################################################################################################
function adb-opt         { Get-Date; adb.exe kill-server; adb.exe shell cmd package bg-dexopt-job; Get-Date }
function basename        { Split-Path -Leaf @args }
function cat             { Get-Content @args }
function cd              { Set-Location @args }
function clear           { Clear-Host @args }
function code-wsl        { code --remote wsl+ubuntu /home/tur1ngb0x/src }
function cp              { Copy-Item @args }
function df              { Get-Volume @args }
function diff            { Compare-Object @args }
function dirname         { Split-Path -Parent @args }
function echo            { Write-Output @args }
function env             { Get-ChildItem Env: | ForEach-Object { "`$env:$($_.Name)`n$($_.Value)`n" } }
function grep            { Select-String @args }
function head            { Get-Content @args -TotalCount 10 }
function history         { Get-Content (Get-PSReadLineOption).HistorySavePath | ForEach-Object -Begin { $i = 1 } -Process { "{0,5}: {1}" -f $i++, $_ } }
function history-clear   { Clear-History; Clear-Content (Get-PSReadLineOption).HistorySavePath }
function kill            { Stop-Process @args }
function ls              { Get-ChildItem @args }
function man             { Get-Help @args }
function mkdir           { New-Item -ItemType Directory @args }
function mv              { Move-Item @args }
function note            { subl.exe "${HOME}/src/notes/$(Get-Date -Format 'yyyyMMdd_HHmmss')_$($args[0]).txt" }
function path            { $env:Path -split ";" }
function popd            { Pop-Location @args }
function power-display   { (Add-Type '[DllImport("user32.dll")]public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name A -Pas)::SendMessage(-1,0x0112,0xF170,2) }
function power-hibernate { shutdown.exe /h /t 0 /f}
function power-lock      { rundll32.exe user32.dll,LockWorkStation }
function power-logoff    { shutdown.exe /l /t 0 /f }
function power-reboot    { shutdown.exe /r /t 0 /f }
function power-shutdown  { shutdown.exe /s /t 0 /f }
function power-sleep     { rundll32.exe powrprof.dll,SetSuspendState 0,1,1 }
function power-uefi      { shutdown.exe /fw /t 0 /f }
function ps              { Get-Process @args }
function pushd           { Push-Location @args }
function pwd             { Get-Location @args }
function pwshist         { (Get-PSReadLineOption).HistorySavePath }
function realexe         { & (Get-Command $args[0] -CommandType Application).Source }
function ren             { Rename-Item @args }
function rm              { Remove-Item @args }
function tail            { Get-Content @args -Tail 10 }
function tee             { Tee-Object @args }
function today           { (Get-Date).ToString("yyyyMMdd-ddd-HHmmss") }
function touch           { Set-Item @args }
function uptime          { Get-Uptime @args }
function wc              { Measure-Object @args }
function which           { Get-Command @args }

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

function driver-list {
    $map = @{
        'Published Name' = 'PublishedName'
        'Original Name'  = 'OriginalName'
        'Provider Name'  = 'ProviderName'
        'Class Name'     = 'ClassName'
        'Class GUID'     = 'ClassGuid'
        'Driver Version' = 'DriverVersion'
        'Signer Name'    = 'SignerName'
        'Attributes'     = 'Attributes'
    }

    $rx = [regex] '^(.*?)\s*:\s*(.*)$'
    $list = [System.Collections.Generic.List[object]]::new()
    $record = @{}

    pnputil /enum-drivers 2>&1 | ForEach-Object {
        $m = $rx.Match($_)
        if ($m.Success) {
            $k = $m.Groups[1].Value
            $v = $m.Groups[2].Value.Trim()
            if ($map.ContainsKey($k)) { $record[$map[$k]] = $v }
            if ($k -eq 'Attributes') {
                $copy = @{ }
                foreach ($prop in $record.Keys) { $copy[$prop] = $record[$prop] }
                $list.Add([PSCustomObject]$copy) | Out-Null
                $record.Clear()
            }
        }
    }
    $list | Format-Table PublishedName, OriginalName, ProviderName, ClassName, ClassGuid, DriverVersion, SignerName, Attributes -AutoSize
}

function purge-brave   { Remove-Item "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data" -Recurse -Force -Confirm }
function purge-chrome  { Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data" -Recurse -Force -Confirm }
function purge-edge    { Remove-Item "$env:LOCALAPPDATA\Microsoft\Edge\User Data" -Recurse -Force -Confirm }
function purge-firefox { Remove-Item "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles","$env:APPDATA\Mozilla\Firefox\Profiles" -Recurse -Force -Confirm }





#######################################################################################################################
# PROMPT
#######################################################################################################################
# function Prompt { "${env:USERNAME}@${env:COMPUTERNAME} ${PWD}`n$ " }
function Prompt {
    $local:u = "`e[1m`e[32m${env:USERNAME}`e[0m"
    $local:h = "`e[1m`e[36m${env:COMPUTERNAME}`e[0m"
    $local:w = "`e[1m`e[33m'${PWD}'`e[0m"
    $local:g = "`e[1m`e[95m$(git rev-parse --git-dir *>$null && git branch --show-current 2>$null)`e[0m"
    $local:s = "$"
    return "${local:u}@${local:h} ${local:w} ${local:g}`n${local:s} "
}




#######################################################################################################################
# CONDITIONALS
#######################################################################################################################
Get-Command starship -ErrorAction SilentlyContinue *> $null && Invoke-Expression (& starship init powershell)
Get-Module -ListAvailable -Name posh-git -ErrorAction SilentlyContinue *> $null && Import-Module posh-git
Get-Command scoop-search -ErrorAction SilentlyContinue *> $null                 && Invoke-Expression (&scoop-search --hook)
Get-Command eza -ErrorAction SilentlyContinue *> $null                          && Set-Alias ls eza -Force
