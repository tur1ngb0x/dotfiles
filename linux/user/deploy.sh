#!/usr/bin/env bash

LC_ALL=C
CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"
function header	{ tput rev; printf " %s \n" "${1}"; tput sgr0; }
function tex	{ printf " %s \n" "${1}"; }
function mkd	{ mkdir -pv "${@}"; }
function mkf	{ touch "${@}"; }
function rmd	{ rm -frv "${@}"; }
function rmf	{ rm -fv "${@}"; }
function lns	{ ln -fsv "${1}" "${2}"; }

function prompt_user {
	MSG="$(tput rev; printf ' Press Y/y to deploy, any other key to exit: '; tput sgr0) "
	read -p "${MSG}" -n 1 -r answer; echo
	if [[ ! "${answer}" =~ ^[Yy]$ ]]; then
		exit
	fi
}

function deploy_bash {
	header 'bash'
	rmf "${HOME}"/.bash_profile
	lns "${CWD}"/.bash_logout "${HOME}"/.bash_logout
	lns "${CWD}"/.bashrc "${HOME}"/.bashrc
}

function deploy_code {
	header 'code'
	mkd "${HOME}"/.config/Code/User #native
	lns "${CWD}"/.config/Code/User/settings.json "${HOME}"/.config/Code/User/settings.json
	mkd "${HOME}"/.var/app/com.visualstudio.code/config/Code/User #flatpak
	lns "${CWD}"/.config/Code/User/settings.json "${HOME}"/.var/app/com.visualstudio.code/config/Code/User/settings.json
	mkd "${HOME}"/.vscode-server/data/Machine # wsl/ssh
	lns "${CWD}"/.config/Code/User/settings.json "${HOME}"/.vscode-server/data/Machine/settings.json
	mkd "${HOME}"/Apps/vscode/data/tmp/User #portable
	lns "${CWD}"/.config/Code/User/settings.json "${HOME}"/Apps/vscode/data/tmp/User/settings.json
}

function deploy_fonts {
	header 'fonts'
	mkd "${HOME}"/.config/fontconfig
	lns "${CWD}"/.config/fontconfig/fonts.conf "${HOME}"/.config/fontconfig/fonts.conf
}

function deploy_git {
	header 'git'
	mkd "${HOME}"/.config/git
	lns "${CWD}"/.config/git/config "${HOME}"/.config/git/config
}

function deploy_micro {
	header 'micro'
	mkd "${HOME}"/.config/micro
	lns "${CWD}"/.config/micro/settings.json "${HOME}"/.config/micro/settings.json
}

function deploy_shell {
	header 'shell'
	lns "${CWD}"/.inputrc "${HOME}"/.inputrc
	lns "${CWD}"/.profile "${HOME}"/.profile
}

function deploy_x11 {
	header 'x11'
	lns "${CWD}"/.xprofile "${HOME}"/.xprofile
	lns "${CWD}"/.Xresources "${HOME}"/.Xresources
}

function deploy_xdg {
	header 'folders'
	mkd "${HOME}"/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos} && find "${HOME}"/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos} -maxdepth 0 -type d
	mkd "${HOME}"/.{cache,config,local/{bin,share,state}} && find "${HOME}"/.{cache,config,local/{bin,share,state}} -maxdepth 0 -type d
	mkd "${HOME}"/src/tmp && find "${HOME}"/src/tmp -maxdepth 0 -type d
}

function main {
	prompt_user
	deploy_xdg
	deploy_shell
	deploy_bash
	#deploy_code
	deploy_fonts
	deploy_git
	deploy_micro
	deploy_x11
}

# begin script from here
main "${@}"
