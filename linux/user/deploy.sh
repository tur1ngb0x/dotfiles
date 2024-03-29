#!/usr/bin/env bash

text() { tput rev; printf " %s \n" "${1}"; tput sgr0; }
CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"

folders(){
	text 'folders'
	mkdir -pv "${HOME}"/{Desktop,Documents,Downloads,Music,Pictures,Public,Templates,Videos}
	mkdir -pv "${HOME}"/.{cache,config,local/{bin,share,state}}
	mkdir -pv "${HOME}"/src
	xdg-user-dirs-update
}

bash(){
	text 'bash'
	mkdir -pv "${HOME}/.config/bash"
	rm -frv "${HOME}"/.bash_profile
	ln -fsv "${CWD}"/.bash_logout "${HOME}"/.bash_logout
	ln -fsv "${CWD}"/.bashrc "${HOME}"/.bashrc
	ln -fsv "${CWD}"/.config/bash/0-init.sh "${HOME}"/.config/bash/0-init.sh
	ln -fsv "${CWD}"/.config/bash/1-path.sh "${HOME}"/.config/bash/1-path.sh
	ln -fsv "${CWD}"/.config/bash/2-variables.sh "${HOME}"/.config/bash/2-variables.sh
	ln -fsv "${CWD}"/.config/bash/3-functions.sh "${HOME}"/.config/bash/3-functions.sh
	ln -fsv "${CWD}"/.config/bash/4-aliases.sh "${HOME}"/.config/bash/4-aliases.sh
	ln -fsv "${CWD}"/.config/bash/5-prompt.sh "${HOME}"/.config/bash/5-prompt.sh
	ln -fsv "${CWD}"/.config/bash/6-misc.sh "${HOME}"/.config/bash/6-misc.sh
	ln -fsv "${CWD}"/.inputrc "${HOME}"/.inputrc
	ln -fsv "${CWD}"/.profile "${HOME}"/.profile
}

code(){
	text 'code'
	mkdir -pv "${HOME}"/.config/Code/User
	ln -fsv "${CWD}"/.config/Code/User/settings.json "${HOME}"/.config/Code/User/settings.json                               # native
	mkdir -pv "${HOME}"/.var/app/com.visualstudio.code/config/Code/User
	ln -fsv "${CWD}"/.config/Code/User/settings.json "${HOME}"/.var/app/com.visualstudio.code/config/Code/User/settings.json # flatpak
	mkdir -pv "${HOME}"/.vscode-server/data/Machine
	ln -fsv "${CWD}"/.config/Code/User/settings.json "${HOME}"/.vscode-server/data/Machine/settings.json                     # wsl
	mkdir -pv "${HOME}"/Applications/vscode/data/tmp/User
	ln -fsv "${CWD}"/.config/Code/User/settings.json "${HOME}"/Applications/vscode/data/tmp/User/settings.json               # portable
}

fonts(){
	text 'fonts'
	mkdir -pv "${HOME}"/.config/fontconfig
	ln -fsv "${CWD}"/.config/fontconfig/fonts.conf "${HOME}"/.config/fontconfig/fonts.conf
}

git(){
	text 'git'
	mkdir -pv "${HOME}"/.config/git
	ln -fsv "${CWD}"/.config/git/config "${HOME}"/.config/git/config
}

x11(){
	text 'x11'
	ln -fsv "${CWD}"/.xprofile "${HOME}"/.xprofile
	ln -fsv "${CWD}"/.Xresources "${HOME}"/.Xresources
}

# create folders
folders

# symlink dotfiles
bash
code
fonts
git
x11
