#!/usr/bin/env bash

# remove all aliases
builtin unalias -a
builtin shopt -u expand_aliases

# force POSIX locale for consistent, predictable behaviour
LC_ALL="C"

# get absolute path of the script
CWD="$(builtin cd "$(command dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && builtin pwd -P)"

# get absolute path of directories
user="${CWD}/user"

# deploy function
deploy() {
    local text; text="${1}"                              # print text as argument 1
    local src_file; src_file="${2}"                      # source file as argument 2
    local dst_file; dst_file="${3}"                      # destination symlink as argument 3
    local dst_dir; dst_dir="$(dirname -- "${dst_file}")" # extract directory from destination symlink


    if [[ -n "${text}" ]]; then
        builtin printf '%s\t' "${text}"
    fi

    if [[ ! -d "${dst_dir}" ]]; then
        command mkdir -p -- "${dst_dir}"
    fi
    if [[ ! -L "${src_file}" ]] && [[ -f "${src_file}" ]]; then
        command ln -s -r -f -v -- "${src_file}" "${dst_file}"
    fi
}

main(){
#   $0     $1      $2                                      $3
    deploy "bash"  "${user}/.bash_profile"                 "${HOME}/.bash_profile"
    deploy "bash"  "${user}/.bashrc"                       "${HOME}/.bashrc"
    deploy "git"   "${user}/.config/git/config"            "${HOME}/.config/git/config"
    deploy "micro" "${user}/.config/micro/settings.json"   "${HOME}/.config/micro/settings.json"
    deploy "fonts" "${user}/.config/fontconfig/fonts.conf" "${HOME}/.config/fontconfig/fonts.conf"
}

main "${@}" | column -t

unset CWD user root syst

# "${HOME}/.config/Code/User"                               # native/snap
# "${HOME}/.var/app/com.visualstudio.code/config/Code/User" # flatpak
# "${HOME}/.vscode-server/data/Machine"                     # wsl/ssh
# "${HOME}/Apps/vscode/data/tmp/User"                       # portable
