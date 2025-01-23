
function header {
    Write-Host (" # " + $args) -ForegroundColor Green -BackgroundColor Black
}

function text {
    Write-Host $args
}

function prompt_user {
    $response = Read-Host "Deploying configuration files, do you want to continue? (y/n)"
    if ($response -notmatch "^[Yy]$") {
        exit
    }
}

# current directory
# $HOME = $env:USERPROFILE
$CWD = (Get-Location).Path

function deploy_powershell {
    header 'powershell 5'
    New-Item -ItemType Directory `
        -Path "$env:USERPROFILE\Documents\WindowsPowerShell" `
        -Force
    sudo New-Item -ItemType SymbolicLink `
        -Path "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" `
        -Target "$CWD\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" `
        -Force
    header 'powershell 7'
    New-Item -ItemType Directory `
        -Path "$env:USERPROFILE\Documents\PowerShell" `
        -Force
    sudo New-Item -ItemType SymbolicLink `
        -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" `
        -Target "$CWD\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" `
        -Force
}

function deploy_wsl {
    header 'wsl'
    sudo New-Item -ItemType SymbolicLink `
        -Path "$env:USERPROFILE\.wslconfig" `
        -Target "$CWD\.wslconfig" `
        -Force
}

function deploy_git {
    header 'git'
    sudo New-Item -ItemType SymbolicLink `
        -Path "$env:USERPROFILE\.gitconfig" `
        -Target "$CWD\.gitconfig" `
        -Force
}

function deploy_desktop {
    header 'desktop'
    New-Item -ItemType Directory `
        -Path "$env:USERPROFILE\Desktop" `
        -Force
    sudo New-Item -ItemType SymbolicLink `
        -Path "$env:USERPROFILE\Desktop\code-linux.code-workspace" `
        -Target "$CWD\Desktop\code-linux.code-workspace" `
        -Force
    sudo New-Item -ItemType SymbolicLink `
        -Path "$env:USERPROFILE\Desktop\code-windows.code-workspace" `
        -Target "$CWD\Desktop\code-windows.code-workspace" `
        -Force
}

function main {
    prompt_user
    deploy_powershell
    deploy_wsl
    deploy_git
}

# begin script from here
main
