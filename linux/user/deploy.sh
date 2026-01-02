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
deploy () {
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

# shell
deploy '.profile'
deploy '.bashrc'

# git
deploy '.config/git/config'

# alacritty
deploy '.config/alacritty/alacritty.toml'
