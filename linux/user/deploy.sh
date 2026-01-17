#!/usr/bin/env bash

# enable bash strict mode for safer execution
set -euo pipefail

# enforce POSIX locale for deterministic behavior
export LC_ALL='C'

# hard-code PATH to trusted system locations only
export PATH='/usr/local/sbin:/usr/local/bin:/usr/bin'

# ensure the script is not sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    # print error if script is sourced instead of executed
    builtin printf "%s\n" "ERROR: Do not source this script" 1>&2
    builtin return 1
fi

# ensure the script is not run as root
if [[ "${EUID}" -eq 0 ]]; then
    # print error if script is executed as root
    builtin printf "%s\n" "ERROR: Do not run this script as a root user" 1>&2
    command exit 1
fi

# ensure the script is run without arguments
if [[ "${#}" -ne 0 ]]; then
    # print error if arguments are provided
    builtin printf "%s\n" "ERROR: Do not run this script with arguments" 1>&2
    command exit 1
fi

# get full path of this script
CWD="$(
    command cd "$(command dirname "${BASH_SOURCE[0]}")" \
        &>/dev/null \
        && command pwd -P
)"

# deploy a dotfile by creating a symlink in HOME
function _deploy () {
    # compute absolute source file path from script directory
    local src_file="${CWD}/${1:?}"

    # validate that source exists and is not a symlink
    if [[ ! -e "${src_file}" ]] \
        || [[ -L "${src_file}" ]]; then
        # print error if source is invalid
        builtin printf "%s\n" "ERROR: invalid source: ${src_file}" 1>&2
        builtin return 1
    fi

    # compute destination path by replacing CWD with HOME
    local dest_file="${src_file/#${CWD}/${HOME}}"

    # determine destination directory path
    local dest_dir="$(command dirname "${dest_file}")"

    # create destination directory hierarchy if missing
    command mkdir -p "${dest_dir}"

    # create or replace symbolic link from source to destination
    command ln -s -f -v "${src_file}" "${dest_file}"
}

function _install () {
    local mode=''
    local -a apt_pkgs=()
    local -a dnf_pkgs=()
    local -a pacman_pkgs=()

    for arg in "${@}"; do
        case "${arg}" in
            --apt|--dnf|--pacman)
                mode="${arg}"
                ;;
            *)
                [[ "${mode}" == '--apt' ]] && apt_pkgs+=("${arg}")
                [[ "${mode}" == '--dnf' ]] && dnf_pkgs+=("${arg}")
                [[ "${mode}" == '--pacman' ]] && pacman_pkgs+=("${arg}")
                ;;
        esac
    done

    if [[ -x '/usr/bin/pacman' ]]; then
        /usr/bin/sudo /usr/bin/pacman --sync --needed --noconfirm "${pacman_pkgs[@]}"
        return
    fi

    if [[ -x '/usr/bin/dnf' ]]; then
        /usr/bin/sudo /usr/bin/dnf install -y "${dnf_pkgs[@]}"
        return
    fi

    if [[ -x '/usr/bin/apt' ]]; then
        /usr/bin/sudo /usr/bin/apt install -y "${apt_pkgs[@]}"
        return
    fi
}

function main () {
    command rm -f -v "${HOME}"/.bash_profile
    _deploy '.profile'
    _deploy '.xprofile'
    _deploy '.bashrc'
    _deploy '.config/git/config'
    _deploy '.config/fontconfig/fonts.conf'
    _deploy '.config/alacritty/alacritty.toml'
    _deploy '.config/micro/settings.json'
}

# start script execution
main "${@}"
