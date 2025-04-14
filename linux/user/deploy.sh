#!/usr/bin/env bash

# get current directory and source common template
CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"
source "${CWD}"/common.sh

function deploy_bash {
    PrintHeader 'bash'
    CreateLink "${CWD}"/.bash_logout "${HOME}"/.bash_logout
    CreateLink "${CWD}"/.bashrc "${HOME}"/.bashrc
}

function deploy_fonts {
    PrintHeader 'fonts'
    CreateDir "${HOME}"/.config/fontconfig
    CreateLink "${CWD}"/.config/fontconfig/fonts.conf "${HOME}"/.config/fontconfig/fonts.conf
}

function deploy_git {
    PrintHeader 'git'
    CreateDir "${HOME}"/.config/git
    CreateLink "${CWD}"/.config/git/config "${HOME}"/.config/git/config
}

function deploy_micro {
    PrintHeader 'micro'
    CreateDir "${HOME}"/.config/micro
    CreateLink "${CWD}"/.config/micro/settings.json "${HOME}"/.config/micro/settings.json
}

function deploy_shell {
    PrintHeader 'shell'
    CreateLink "${CWD}"/.inputrc "${HOME}"/.inputrc
    CreateLink "${CWD}"/.profile "${HOME}"/.profile
}

function deploy_x11 {
    PrintHeader 'x11'
    CreateLink "${CWD}"/.xprofile "${HOME}"/.xprofile
    CreateLink "${CWD}"/.Xresources "${HOME}"/.Xresources
}

function deploy_xdg {
    PrintHeader 'folders'
    CreateDir "${HOME}"/.{cache,config,local/{bin,share,state}}
    CreateDir "${HOME}"/Apps
    CreateDir "${HOME}"/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos}
    CreateDir "${HOME}"/src/tmp
}

function main {
    PromptUser "Deploy configuration files? (y/N)"
    deploy_xdg
    deploy_bash
    deploy_fonts
    deploy_git
    deploy_micro
    deploy_x11
}
 
# begin script from here
main "${@}"

# code
# "${HOME}"/.config/Code/User #native
# "${HOME}"/.var/app/com.visualstudio.code/config/Code/User #flatpak
# "${HOME}"/.vscode-server/data/Machine #wsl/ssh
# "${HOME}"/Apps/vscode/data/tmp/User #portable

# detect platform
# if [[ $(command -v systemd-detect-virt) ]]; then
#     virt_type=$(systemd-detect-virt)
#     if [[ "${virt_type}" != "none" ]]; then
#        $tasks
#     fi
# fi
