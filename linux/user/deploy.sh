#!/usr/bin/env bash

# POSIX strict mode
LC_ALL=C

# checks
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && printf 'ERROR: Do not source this script\n'             && return
[[ "${EUID}" -eq 0 ]]               && printf 'ERROR: Do not run this script as a root user\n' && exit
[[ "$#" -ne 0 ]]                    && printf 'ERROR: Do not run this script with arguments\n' && exit

# get full path of this script
CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

# deploy function
function _deploy () {
    # take dotfile as source
    local src_file="${CWD}/${1:?}"

    # source should not be a symlink
    [[ ! -e "${src_file}" ]] || [[ -L "${src_file}" ]] && printf 'ERROR: invalid source: %s\n' "${src_file}" && return

    # replace CWD with HOME
    local dest_file="${src_file/#${CWD}/${HOME}}"

    # get destination directory
    local dest_dir="$(dirname "${dest_file}")"

    # create destination directory
    mkdir -p "${dest_dir}"

    # symlink source to destination directory
    ln -s -f -v "${src_file}" "${dest_file}"
}

function _install () {
	if [[ -f /usr/bin/apt-get ]]; then
		/usr/bin/sudo /usr/bin/apt-get install -y "${@}"
	elif [[ -f /usr/bin/dnf ]]; then
		/usr/bin/sudo /usr/bin/dnf install -y "${@}"
	elif [[ -f /usr/bin/pacman ]]; then
		/usr/bin/sudo /usr/bin/pacman --sync --needed --noconfirm "${@}"
	else
		echo 'cannot determine package manager'
		exit
	fi	
}

# shell
_deploy '.profile'
_deploy '.bashrc'

# git
_deploy '.config/git/config' && _install 'git'

# alacritty
_deploy '.config/alacritty/alacritty.toml' && _install 'alacritty'

# i3
_deploy '.config/i3/config'
