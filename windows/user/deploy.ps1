# # Set the current directory to the script's directory
# $CWD = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# # Function to display a header with reverse video (similar to tput rev)
# function hed {
#     Write-Host ("# " + $args[0]) -ForegroundColor Cyan -BackgroundColor Black
# }

# # Function to display a message
# function tex {
#     Write-Host $args[0]
# }

# # Function to create directories (with -Force flag to create parent directories)
# function mkd {
#     New-Item -ItemType Directory -Force -Path $args
# }

# # Function to create an empty file
# function mkf {
#     New-Item -ItemType File -Force -Path $args
# }

# # Function to remove directories and files recursively
# function rmd {
#     Remove-Item -Recurse -Force -Path $args
# }

# # Function to remove a file (with force)
# function rmf {
#     Remove-Item -Force -Path $args
# }

# # Function to create a symbolic link (same as ln -s)
# function lns {
#     New-Item -ItemType SymbolicLink -Force -Path $args[1] -Target $args[0]
# }

# # Function to run a command and handle errors (similar to pet)
# function pet {
#     Write-Host ("Running: " + $args[0]) -ForegroundColor Yellow
#     try {
#         Invoke-Expression $args[0]
#     }
#     catch {
#         Write-Host ("Error: " + $_.Exception.Message) -ForegroundColor Red
#     }
# }

# # Function to prompt the user to confirm the deployment
# function prompt_user {
#     $response = Read-Host "Deploying configuration files, do you want to continue? (Y/N)"
#     if ($response -notmatch "^[Yy]$") {
#         exit
#     }
# }

# # Function to deploy bash-related configuration
# function deploy_bash {
#     hed 'bash'
#     rmf "$env:USERPROFILE\.bash_profile"
#     lns "$CWD\.bash_logout" "$env:USERPROFILE\.bash_logout"
#     lns "$CWD\.bashrc" "$env:USERPROFILE\.bashrc"
# }

# # Function to deploy Visual Studio Code configuration
# function deploy_code {
#     hed 'code'
#     mkd "$env:USERPROFILE\.config\Code\User"
#     mkd "$env:USERPROFILE\.var\app\com.visualstudio.code\config\Code\User"
#     mkd "$env:USERPROFILE\.vscode-server\data\Machine"
#     mkd "$env:USERPROFILE\Apps\vscode\data\tmp\User"
# }

# # Function to deploy font configuration
# function deploy_fonts {
#     hed 'fonts'
#     mkd "$env:USERPROFILE\.config\fontconfig"
#     lns "$CWD\.config\fontconfig\fonts.conf" "$env:USERPROFILE\.config\fontconfig\fonts.conf"
# }

# # Function to deploy Git configuration
# function deploy_git {
#     hed 'git'
#     mkd "$env:USERPROFILE\.config\git"
#     lns "$CWD\.config\git\config" "$env:USERPROFILE\.config\git\config"
# }

# # Function to deploy Micro editor configuration
# function deploy_micro {
#     hed 'micro'
#     mkd "$env:USERPROFILE\.config\micro"
#     lns "$CWD\.config\micro\settings.json" "$env:USERPROFILE\.config\micro\settings.json"
# }

# # Function to deploy shell-related configuration
# function deploy_shell {
#     hed 'shell'
#     lns "$CWD\.inputrc" "$env:USERPROFILE\.inputrc"
#     lns "$CWD\.profile" "$env:USERPROFILE\.profile"
# }

# # Function to deploy Starship prompt configuration
# function deploy_starship {
#     hed 'starship'
#     mkd "$env:USERPROFILE\.config\starship"
#     lns "$CWD\.config\starship\starship.toml" "$env:USERPROFILE\.config\starship\starship.toml"
# }

# # Function to deploy X11-related configuration
# function deploy_x11 {
#     hed 'x11'
#     lns "$CWD\.xprofile" "$env:USERPROFILE\.xprofile"
#     lns "$CWD\.Xresources" "$env:USERPROFILE\.Xresources"
# }

# # Function to deploy XDG standard directories
# function deploy_xdg {
#     hed 'folders'
#     $dirs = @('Apps', 'Desktop', 'Documents', 'Downloads', 'Music', 'Pictures', 'Public', 'Templates', 'Videos')
#     foreach ($dir in $dirs) {
#         mkd "$env:USERPROFILE\$dir"
#     }

#     mkd "$env:USERPROFILE\.cache"
#     mkd "$env:USERPROFILE\.config"
#     mkd "$env:USERPROFILE\.local\bin"
#     mkd "$env:USERPROFILE\.local\share"
#     mkd "$env:USERPROFILE\.local\state"
#     mkd "$env:USERPROFILE\src\tmp"
# }

# # Main function to start the deployment
# function main {
#     prompt_user
#     deploy_xdg
#     deploy_shell
#     deploy_bash
#     deploy_starship
#     deploy_fonts
#     deploy_git
#     deploy_micro
#     deploy_x11
# }

# # Run the script from here
# main

# current directory
$cwd = split-path -path $myinvocation.mycommand.definition -parent

# Create the directory
New-Item -ItemType Directory `
    -Path "$HOME\Documents\WindowsPowerShell" `
    -Force

# Create the symbolic link
sudo New-Item -ItemType SymbolicLink `
    -Path "$env:userprofile\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" `
    -Target "$env:userprofile\src\dotfiles\windows\user\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" `
    -Force

# powershell 7
new-item -itemtype directory -path "$env:userprofile\documents\powershell\"
new-item -path "$env:userprofile\documents\powershell\microsoft.powershell_profile.ps1" -itemtype symboliclink -target ".\documents\powershell\microsoft.powershell_profile.ps1" -force

# wsl
new-item -path "$env:userprofile\.wslconfig" -itemtype symboliclink -target ".\wslconfig"

# git
new-item -path "$env:userprofile\.gitconfig" -itemtype symboliclink -target ".\gitconfig"
