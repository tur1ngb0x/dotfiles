#!/usr/bin/env bash

{ set -e -u -x -o pipefail; } &> /dev/null
[[ $(id -u) -eq 0 ]] && echo "Run the script as a non-root user. Exiting." && exit
text() { tput rev && tput setaf 4 && printf " %s \n" "${1}" && tput sgr0; }
cdir=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
tput rev; printf "%s\n" "copying files"; tput sgr0;
{ set +e +u +x +o pipefail; } &> /dev/null

usage()
{
	cat << EOF
Usage:
	$ bash ./install-ztemplate <option>
Options:
	debian, ubuntu, fedora, arch
Example:
	$ bash ./install-ztemplate debian
	$ bash ./install-ztemplate arch
EOF
}

pkgs_snap=(a b c)
pkgs_flatpak=(a b c)
pkgs_debian=(a b c)
pkgs_ubuntu=(a b c)
pkgs_fedora=(a b c)
pkgs_arch=(a b c)
pkgs_test=(a b c)

if [[ ${#} -eq 0 ]]; then
	usage && exit
else
	case "${1}" in
		"snap")		for pkg in "${pkgs_snap[@]}"; do sudo snap install "${pkg}"; done ;;
		"flatpak")	for pkg in "${pkgs_snap[@]}"; do flatpak install "${pkg}"; done ;;
		"debian")	for pkg in "${pkgs_debian[@]}"; do sudo apt install "${pkg}"; done ;;
		"ubuntu")	for pkg in "${pkgs_ubuntu[@]}"; do sudo apt install "${pkg}"; done ;;
		"fedora")	for pkg in "${pkgs_fedora[@]}"; do sudo dnf install "${pkg}"; done ;;
		"arch")		for pkg in "${pkgs_arch[@]}"; do sudo pacman -S "${pkg}"; done ;;
		"test")		for pkg in "${pkgs_test[@]}"; do printf "${pkg}\n"; done ;;
		*)			usage ;;
	esac
fi


variable="command --flag 1 --flag 2 --flag 3"
echo "${variable}"
eval "${variable}"


IFS=""
packages=( \
	# essentials
	a b c \
	# tools
	l m n o \
	# apps
	x y z \
)
for i in "${packages[@]}"; do echo "${i}"; done
unset IFS
