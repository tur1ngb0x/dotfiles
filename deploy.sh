#!/usr/bin/env bash

# remove all aliases
builtin unalias -a
builtin shopt -u expand_aliases

# force POSIX locale for consistent, predictable behaviour
LC_ALL="C"

# get absolute path of the script
CWD="$(builtin cd "$(command dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && builtin pwd -P)"

# get absolute path of directories
user="${CWD}/linux/user"
root="${CWD}/linux/root"
syst="${CWD}/linux/system"

deploy_file() {
    local txt="${1}" # print text
    local dir="${2}" # create parent directory
    local src="${3}" # source file
    local dst="${4}" # destination symlink

    # print header text
    builtin printf '%s\t' "${txt}"

    # create directory
    command mkdir -p -- "${dir}"

    # create destination symlink
    command ln -s -r -f -v -- "${src}" "${dst}"
    # command ln -s -r -f -v -- "${src}" "${dst}"
}

# main function
main() {
    #$0         $1      $2                      $3                                       $4
    deploy_file "bash"  "${HOME}"               "${user}/.bash_logout"                "${HOME}/.bash_logout"
    deploy_file "bash"  "${HOME}"               "${user}/.bash_profile"               "${HOME}/.bash_profile"
    deploy_file "bash"  "${HOME}"               "${user}/.bashrc"                     "${HOME}/.bashrc"
    deploy_file "git"   "${HOME}/.config/git"   "${user}/.config/git/config"          "${HOME}/.config/git/config"
    deploy_file "micro" "${HOME}/.config/micro" "${user}/.config/micro/settings.json" "${HOME}/.config/micro/settings.json"
    deploy_file "x11"   "${HOME}"               "${user}/.Xresources"                 "${HOME}/.Xresources"
}

main "${@}" | column -t

unset CWD user root syst





# "${HOME}/.config/Code/User"                               # native/snap
# "${HOME}/.var/app/com.visualstudio.code/config/Code/User" # flatpak
# "${HOME}/.vscode-server/data/Machine"                     # wsl/ssh
# "${HOME}/Apps/vscode/data/tmp/User"                       # portable
