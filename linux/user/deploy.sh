#!/usr/bin/env bash

# #####################################################################
# START
# #####################################################################

set -e -u

# #####################################################################
# VARIABLES
# #####################################################################

LC_ALL=C; export LC_ALL

CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"; export CWD

# #####################################################################
# FUNCTIONS
# #####################################################################

text(){
	tput rev
	printf " %s \n" "${1}"
	tput sgr0
}

deploy_xdg(){
	text 'folders'
	mkdir -pv "${HOME}"/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos} && echo 'XDG USER'
	mkdir -pv "${HOME}"/.{cache,config,local/{bin,share,state}} && echo 'XDG BASE'
	mkdir -pv "${HOME}"/src/tmp  && echo 'USER SRC'
}

deploy_shell(){
	text 'shell'
	ln -fsv "${CWD}"/.inputrc "${HOME}"/.inputrc
	ln -fsv "${CWD}"/.profile "${HOME}"/.profile
}

deploy_bash(){
	text 'bash'
	rm -fv "${HOME}"/.bash_profile
	ln -fsv "${CWD}"/.bash_logout "${HOME}"/.bash_logout
	ln -fsv "${CWD}"/.bashrc "${HOME}"/.bashrc
}

deploy_starship()
{
	text 'starship'
	mkdir -pv "${HOME}"/.config/starship
	ln -fsv "${CWD}"/.config/starship/starship.toml "${HOME}"/.config/starship/starship.toml
}

deploy_code(){
	text 'code'
	mkdir -pv "${HOME}"/.config/Code/User #native
	ln -fsv "${CWD}"/.config/Code/User/settings.json "${HOME}"/.config/Code/User/settings.json
	mkdir -pv "${HOME}"/.var/app/com.visualstudio.code/config/Code/User #flatpak
	ln -fsv "${CWD}"/.config/Code/User/settings.json "${HOME}"/.var/app/com.visualstudio.code/config/Code/User/settings.json
	mkdir -pv "${HOME}"/.vscode-server/data/Machine # wsl/ssh
	ln -fsv "${CWD}"/.config/Code/User/settings.json "${HOME}"/.vscode-server/data/Machine/settings.json
	mkdir -pv "${HOME}"/Applications/vscode/data/tmp/User #portable
	ln -fsv "${CWD}"/.config/Code/User/settings.json "${HOME}"/Applications/vscode/data/tmp/User/settings.json
}

deploy_fonts(){
	text 'fonts'
	mkdir -pv "${HOME}"/.config/fontconfig
	ln -fsv "${CWD}"/.config/fontconfig/fonts.conf "${HOME}"/.config/fontconfig/fonts.conf
}

deploy_git(){
	text 'git'
	mkdir -pv "${HOME}"/.config/git
	ln -fsv "${CWD}"/.config/git/config "${HOME}"/.config/git/config
}

deploy_x11(){
	text 'x11'
	ln -fsv "${CWD}"/.xprofile "${HOME}"/.xprofile
	ln -fsv "${CWD}"/.Xresources "${HOME}"/.Xresources
}

main(){
	deploy_xdg
	deploy_shell
	deploy_bash
	deploy_starship
	deploy_code
	deploy_fonts
	deploy_git
	deploy_x11
}

# #####################################################################
# MAIN
# #####################################################################

main "${@}"

# #####################################################################
# END
# #####################################################################

set +e +u
