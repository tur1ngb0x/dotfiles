#!/usr/bin/env bash

# get current directory & source common template
CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"
source "${CWD}"/common.sh

function deploy_bash () {
    PrintHeader 'bash'
    CreateLink "${CWD}"/.bash_logout "${HOME}"/.bash_logout
    CreateLink "${CWD}"/.bashrc "${HOME}"/.bashrc
}

function deploy_fonts () {
    PrintHeader 'fonts'
    CreateDir "${HOME}"/.config/fontconfig
    CreateLink "${CWD}"/.config/fontconfig/fonts.conf "${HOME}"/.config/fontconfig/fonts.conf
}

function deploy_git () {
    PrintHeader 'git'
    CreateDir "${HOME}"/.config/git
    CreateLink "${CWD}"/.config/git/config "${HOME}"/.config/git/config
}

function deploy_micro () {
    PrintHeader 'micro'
    CreateDir "${HOME}"/.config/micro
    CreateLink "${CWD}"/.config/micro/settings.json "${HOME}"/.config/micro/settings.json
}

function deploy_shell () {
    PrintHeader 'shell'
    CreateLink "${CWD}"/.inputrc "${HOME}"/.inputrc
    CreateLink "${CWD}"/.profile "${HOME}"/.profile
}

function deploy_x11 () {
    PrintHeader 'x11'
    CreateLink "${CWD}"/.xprofile "${HOME}"/.xprofile
    CreateLink "${CWD}"/.Xresources "${HOME}"/.Xresources
}

function deploy_xdg () {
    PrintHeader 'folders'

    CreateDir "${HOME}"/.cache
    CreateDir "${HOME}"/.config
    CreateDir "${HOME}"/.local/bin
    CreateDir "${HOME}"/.local/share
    CreateDir "${HOME}"/.local/state

    CreateDir "${HOME}"/Desktop
    CreateDir "${HOME}"/Documents
    CreateDir "${HOME}"/Downloads
    CreateDir "${HOME}"/Music
    CreateDir "${HOME}"/Pictures
    CreateDir "${HOME}"/Public
    CreateDir "${HOME}"/Templates
    CreateDir "${HOME}"/Videos

    CreateDir "${HOME}"/Apps
    CreateDir "${HOME}"/src/tmp
    CreateDir "${HOME}"/src/docker
    CreateDir "${HOME}"/src/distrobox
}

function deploy_packages () {
    PrintHeader 'packages'
}

function main () {
    PromptUser "Deploy configuration files? (y/N)"
    deploy_xdg
    deploy_bash
    #deploy_shell
    #deploy_fonts
    deploy_git
    #deploy_micro
    #deploy_x11
}

# begin script from here
main "${@}"

# code
# "${HOME}"/.config/Code/User #native
# "${HOME}"/.var/app/com.visualstudio.code/config/Code/User #flatpak
# "${HOME}"/.vscode-server/data/Machine #wsl/ssh
# "${HOME}"/Apps/vscode/data/tmp/User #portable
