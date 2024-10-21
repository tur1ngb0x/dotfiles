#!/usr/bin/env bash

LC_ALL=C
CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"
function hed	{ tput rev; printf " # %s \n" "${1}"; tput sgr0; }
function tex	{ printf " %s \n" "${1}"; }
function mkd	{ mkdir -pv "${@}"; }
function mkf	{ touch "${@}"; }
function rmd	{ rm -frv "${@}"; }
function rmf	{ rm -fv "${@}"; }
function lns	{ ln -fsv "${1}" "${2}"; }
function pet	{ tput rev bold; printf " %s \\n" "${@}"; tput sgr0; eval "${@}" 2>&1 || return; }

function prompt_user {
	echo 'Deploying configuration files, do you want to continue?'
	read -p "Press Y or y to continue, N or n to cancel: " -n 1 -r answer; echo
	if [[ ! "${answer}" =~ ^[Yy]$ ]]; then
		exit
	fi
}

function deploy_bash {
	hed 'bash'
	rmf "${HOME}"/.bash_profile
	lns "${CWD}"/.bash_logout "${HOME}"/.bash_logout
	lns "${CWD}"/.bashrc "${HOME}"/.bashrc
}

function deploy_code {
	hed 'code'
	mkd "${HOME}"/.config/Code/User									#native
	mkd "${HOME}"/.var/app/com.visualstudio.code/config/Code/User	#flatpak
	mkd "${HOME}"/.vscode-server/data/Machine						#wsl/ssh
	mkd "${HOME}"/Apps/vscode/data/tmp/User							#portable
}

function deploy_fonts {
	hed 'fonts'
	mkd "${HOME}"/.config/fontconfig
	lns "${CWD}"/.config/fontconfig/fonts.conf "${HOME}"/.config/fontconfig/fonts.conf
}

function deploy_git {
	hed 'git'
	mkd "${HOME}"/.config/git
	lns "${CWD}"/.config/git/config "${HOME}"/.config/git/config
}

function deploy_micro {
	hed 'micro'
	mkd "${HOME}"/.config/micro
	lns "${CWD}"/.config/micro/settings.json "${HOME}"/.config/micro/settings.json
}

function deploy_shell {
	hed 'shell'
	lns "${CWD}"/.inputrc "${HOME}"/.inputrc
	lns "${CWD}"/.profile "${HOME}"/.profile
}

function deploy_starship {
	hed 'starship'
	mkd "${HOME}"/.config/starship
	lns "${CWD}"/.config/starship/starship.toml "${HOME}"/.config/starship/starship.toml
}

function deploy_x11 {
	hed 'x11'
	lns "${CWD}"/.xprofile "${HOME}"/.xprofile
	lns "${CWD}"/.Xresources "${HOME}"/.Xresources
}

function deploy_xdg {
	hed 'folders'
	mkd "${HOME}"/{Apps,Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos}
	find "${HOME}"/{Apps,Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos} -maxdepth 0 -type d
	mkd "${HOME}"/.{cache,config,local/{bin,share,state}}
	find "${HOME}"/.{cache,config,local/{bin,share,state}} -maxdepth 0 -type d
	mkd "${HOME}"/src/tmp
	find "${HOME}"/src/tmp -maxdepth 0 -type d
}

function main {
	prompt_user
	deploy_xdg
	deploy_shell
	deploy_bash
	deploy_starship
	deploy_fonts
	deploy_git
	deploy_micro
	deploy_x11
}

# begin script from here
main "${@}"
