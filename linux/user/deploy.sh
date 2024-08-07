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

header(){ tput rev; printf " %s \n" "${1}"; tput sgr0; }
text(){ printf " %s \n" "${1}"; }
mkd() { mkdir -pv "${@}"; }
mkf() { touch "${@}"; }
rmd() { rm -frv "${@}"; }
rmf() { rm -fv "${@}"; }
lns() { ln -fsv "${1}" "${2}"; }

deploy_xdg(){
	header 'folders'
	mkd "${HOME}"/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos} && find "${HOME}"/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos} -maxdepth 0 -type d
	mkd "${HOME}"/.{cache,config,local/{bin,share,state}} && find "${HOME}"/.{cache,config,local/{bin,share,state}} -maxdepth 0 -type d
	mkd "${HOME}"/src/tmp && find "${HOME}"/src -maxdepth 0 -type d
}

deploy_shell(){
	header 'shell'
	lns "${CWD}"/.inputrc "${HOME}"/.inputrc
	lns "${CWD}"/.profile "${HOME}"/.profile
}

deploy_bash(){
	header 'bash'
	rmf "${HOME}"/.bash_profile
	lns "${CWD}"/.bash_logout "${HOME}"/.bash_logout
	lns "${CWD}"/.bashrc "${HOME}"/.bashrc
}

deploy_starship()
{
	header 'starship'
	mkd "${HOME}"/.config/starship
	lns "${CWD}"/.config/starship/starship.toml "${HOME}"/.config/starship/starship.toml
}

deploy_code(){
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

deploy_fonts(){
	header 'fonts'
	mkd "${HOME}"/.config/fontconfig
	lns "${CWD}"/.config/fontconfig/fonts.conf "${HOME}"/.config/fontconfig/fonts.conf
}

deploy_git(){
	header 'git'
	mkd "${HOME}"/.config/git
	lns "${CWD}"/.config/git/config "${HOME}"/.config/git/config
}

deploy_x11(){
	header 'x11'
	lns "${CWD}"/.xprofile "${HOME}"/.xprofile
	lns "${CWD}"/.Xresources "${HOME}"/.Xresources
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
