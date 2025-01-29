#!/usr/bin/env bash

LC_ALL=C
CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"
function txt	{ tput rev; printf " # %s \n" "${1}"; tput sgr0; }
function show   { (set -x; "${@:?}"); }

function prompt_user {
    read -p "Press Y/y to deploy, N/n to exit: " -n 1 -r answer; echo
    if [[ ! "${answer}" =~ ^[Yy]$ ]]; then
        exit
    fi
}

function deploy_bash {
    txt 'bash'
    show rm -frv "${HOME}"/.bash_profile
    show ln -fsv "${CWD}"/.bash_logout "${HOME}"/.bash_logout
    show ln -fsv "${CWD}"/.bashrc "${HOME}"/.bashrc
}

function deploy_fonts {
    txt 'fonts'
    show mkdir -pv "${HOME}"/.config/fontconfig
    show ln -fsv "${CWD}"/.config/fontconfig/fonts.conf "${HOME}"/.config/fontconfig/fonts.conf
}

function deploy_git {
    txt 'git'
    show mkdir -pv "${HOME}"/.config/git
    show ln -fsv "${CWD}"/.config/git/config "${HOME}"/.config/git/config
}

function deploy_micro {
    txt 'micro'
    show mkdir -pv "${HOME}"/.config/micro
    show ln -fsv "${CWD}"/.config/micro/settings.json "${HOME}"/.config/micro/settings.json
}

function deploy_shell {
    txt 'shell'
    show ln -fsv "${CWD}"/.inputrc "${HOME}"/.inputrc
    show ln -fsv "${CWD}"/.profile "${HOME}"/.profile
}

function deploy_x11 {
    txt 'x11'
    show ln -fsv "${CWD}"/.xprofile "${HOME}"/.xprofile
    show ln -fsv "${CWD}"/.Xresources "${HOME}"/.Xresources
}

function deploy_xdg {
    txt 'folders'
    show mkdir -pv "${HOME}"/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos}
    show mkdir -pv "${HOME}"/.{cache,config,local/{bin,share,state}}
    show mkdir -pv "${HOME}"/Apps/
    show mkdir -pv "${HOME}"/src/tmp
}

function main {
    prompt_user
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
        $tasks
#     fi
# fi
