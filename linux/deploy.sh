#!/usr/bin/env bash

# force posix locale
LC_ALL="C"

# force strict mode
set -euo pipefail

# get absolute path of this script
CWD="$(builtin cd -- "$(command dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && builtin pwd -P)"

# get absolute path of user directory
user="${CWD}/user"

# deploy function
function deploy ()
{
    local text; text="${1}"                                         # arg 1 - print package name
    local src_file; src_file="${2}"                                 # arg 2 - source file
    local dst_file; dst_file="${3}"                                 # arg 3 - destination symlink
    local dst_dir; dst_dir="$(command dirname -- "${dst_file}")"    # extract directory from arg 3

    if [[ -n "${text}" ]]; then
        builtin printf -- '%s\t' "${text}"
    fi

    if [[ ! -d "${dst_dir}" ]]; then
        command mkdir -p -- "${dst_dir}"
    fi

    if [[ ! -L "${src_file}" ]] && [[ -f "${src_file}" ]]; then
        command ln -s -f -v -- "${src_file}" "${dst_file}"
    fi
}

function fixes ()
{
    if [[ -f "${HOME}"/.profile ]] && [[ -f "${HOME}"/.bash_profile ]]; then
        command rm -f -v -- "${HOME}"/.profile
    fi
}

# main function
main()
{
#   $0     $1      $2                                      $3
    deploy "bash"  "${user}/.bash_profile"                 "${HOME}/.bash_profile"
    deploy "bash"  "${user}/.bashrc"                       "${HOME}/.bashrc"
    deploy "bash"  "${user}/.bash_logout"                  "${HOME}/.bash_logout"
    deploy "git"   "${user}/.config/git/config"            "${HOME}/.config/git/config"
    deploy "micro" "${user}/.config/micro/settings.json"   "${HOME}/.config/micro/settings.json"
    deploy "nano"  "${user}/.config/nano/nanorc"           "${HOME}/.config/nano/nanorc"
    deploy "fonts" "${user}/.config/fontconfig/fonts.conf" "${HOME}/.config/fontconfig/fonts.conf"
    deploy "x11"   "${user}/.Xresources"                   "${HOME}/.Xresources"

    fixes
}

# call main function
main "${@}" | command sort | command column -t

builtin unset -- CWD user deploy fixes

# "${HOME}/.config/Code/User"                               # native/snap
# "${HOME}/.var/app/com.visualstudio.code/config/Code/User" # flatpak
# "${HOME}/.vscode-server/data/Machine"                     # wsl/ssh
# "${HOME}/Apps/vscode/data/tmp/User"                       # portable
