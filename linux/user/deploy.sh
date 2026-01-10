#!/usr/bin/env bash

# POSIX strict mode
LC_ALL=C

# checks
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && printf 'ERROR: Do not source this script\n'             && return 1
[[ "${EUID}" -eq 0 ]]               && printf 'ERROR: Do not run this script as a root user\n' && exit 1
[[ "$#" -ne 0 ]]                    && printf 'ERROR: Do not run this script with arguments\n' && exit 1

# get full path of this script
CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

# deploy function
function _deploy () {
    # take dotfile as source
    local src_file="${CWD}/${1:?}"

    # source should not be a symlink
    [[ ! -e "${src_file}" ]] || [[ -L "${src_file}" ]] && printf 'ERROR: invalid source: %s\n' "${src_file}" && return 1

    # replace CWD with HOME
    local dest_file="${src_file/#${CWD}/${HOME}}"

    # get destination directory
    local dest_dir="$(dirname "${dest_file}")"

    # create destination directory
    mkdir -p "${dest_dir}"

    # # print header
    # printf '\e[7m%s\e[0m\n' "${1:?}"

    # symlink source to destination directory
    ln -s -f -v "${src_file}" "${dest_file}"
}

_install() {
    local pm=""

    # detect package manager
    if [[ -x "/usr/bin/apt-get" ]]; then
        pm="apt"
    elif [[ -x "/usr/bin/dnf" ]]; then
        pm="dnf"
    elif [[ -x "/usr/bin/pacman" ]]; then
        pm="pacman"
    else
        return 1
    fi

    while [[ "${#}" -gt 0 ]]; do
        case "${1}" in
            --apt)
                [[ "${pm}" != "apt" ]] && break
                shift
                while [[ "${#}" -gt 0 && "${1}" != --* ]]; do
                    /usr/bin/sudo /usr/bin/apt-get install --assume-yes "${1}"
                    shift
                done
                ;;
            --dnf)
                [[ "${pm}" != "dnf" ]] && break
                shift
                while [[ "${#}" -gt 0 && "${1}" != --* ]]; do
                    /usr/bin/sudo /usr/bin/dnf install --assumeyes "${1}"
                    shift
                done
                ;;
            --pacman)
                [[ "${pm}" != "pacman" ]] && break
                shift
                while [[ "${#}" -gt 0 && "${1}" != --* ]]; do
                    /usr/bin/sudo /usr/bin/pacman --sync --needed --noconfirm "${1}"
                    shift
                done
                ;;
            *)
                shift
                ;;
        esac
    done
}

function main () {

    # shell
    rm -f -v "${HOME}"/.bash_profile
    _deploy '.profile'
    _deploy '.xprofile'
    _deploy '.bashrc'
    _deploy '.config/git/config'
    _deploy '.config/alacritty/alacritty.toml'
}

# begin script from here
main "${@}"
