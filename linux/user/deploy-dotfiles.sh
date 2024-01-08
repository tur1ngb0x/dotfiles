#!/usr/bin/env bash

cfol=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)

# bash
shell()
{
	rm -frv "${HOME}"/.bash_profile
	ln -fsv "${cfol}"/.profile "${HOME}"/.profile
	ln -fsv "${cfol}"/.bashrc "${HOME}"/.bashrc
}

fonts()
{
	mkdir -pv "${HOME}"/.config/fontconfig
	ln -fsv "${cfol}"/.config/fontconfig/fonts.conf "${HOME}"/.config/fontconfig/fonts.conf
	ln -fsv "${cfol}"/.Xresources "${HOME}"/.Xresources
}

git()
{
	mkdir -pv "${HOME}"/.config/git
	ln -fsv "${cfol}"/.config/git/config "${HOME}"/.config/git/config
	[[ $(command -pv apt) ]] && sed -i 's/#apt/helper/g' ~/.config/git/config
	[[ $(command -pv dnf) ]] && sed -i 's/#dnf/helper/g' ~/.config/git/config
	[[ $(command -pv pacman) ]] && sed -i 's/#pacman/helper/g' ~/.config/git/config
	[[ ! $(command -pv apt) ]] && [[ ! $(command -pv dnf) ]] && [[ ! $(command -pv pacman) ]] && sed -i 's/#other/helper/g' ~/.config/git/config
}

code()
{
	mkdir -pv "${HOME}"/.config/Code/User
	ln -fsv "${cfol}"/.config/Code/User/settings.json "${HOME}"/.config/Code/User/settings.json
}

# begin script from here
shell
git
code
fonts
