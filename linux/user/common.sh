#!/usr/bin/env bash


# if already sourced, dont do anything and return from the common.sh
[[ -n "${COMMON_SH_SOURCED}" ]] && return


# set locale
LC_ALL=C; export LC_ALL


# get current directory name
CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"; export CWD


# print and run the command
function ShowCmd {
    (set -x; "${@:?}")
}


# print simple text
function PrintText {
    printf "%s\n" "${1}";
}


# print header text
function PrintHeader {
    tput rev
    printf " %s \n" "${1}"
    tput sgr0
    # printf "\033[7m # %s \033[0m\n" "${1}"
}


# print error text
function PrintError {
    tput setaf 1
    printf "Error: %s\n" "${1}"
    tput sgr0
}


# elevate user
# ${ELEVATE} command
function ElevateUser {
    if [[ $(id -ur) -eq 0 ]]; then
        ELEVATE=""
        export ELEVATE
    elif command -v sudo &> /dev/null; then
        ELEVATE="sudo"
        export ELEVATE
    elif command -v doas &> /dev/null; then
        ELEVATE="doas"
        export ELEVATE
    else
        echo 'Install sudo or doas'
        exit
    fi
}


# show virtualization
function ShowVirt {
    if command -v systemd-detect-virt &> /dev/null; then
        VIRT_TYPE=$(systemd-detect-virt)
        if [[ "${VIRT_TYPE}" != "none" ]]; then
            echo "Virtualization: ${VIRT_TYPE}"
        else
            echo "Virtualization: none"
        fi
    fi
}


# prompt the user for Y or y to continue
function PromptUser {
    local answer
    printf "%s\n" "$1"
    read -p "Input: " -n 1 -r answer
    echo ''
    if [[ ! "${answer}" =~ ^[Yy]$ ]]; then
        return
    fi
}


# check if requirements are met
function CheckCmd {
    for cmd in "${@}"; do
        if command -v "${cmd}" &> /dev/null; then
            echo "${cmd} found in PATH"
        else
            echo "${cmd} not found in PATH"
            return
        fi
    done
}


# create a directory
function CreateDir {
    local dir="${1:?Directory path required}"
    if [[ ! -d "${dir}" ]]; then
        mkdir -p "${dir}"
    else
        PrintText "Directory already exists: ${dir}"
    fi
}


# create a symlink
function CreateLink {
    local source="${1:?Source path required}"
    local link="${2:?Link name required}"

    if [[ ! -e "${source}" ]]; then
        PrintError "Source does not exist: ${source}"
        return 1
    fi

    if [[ -L "${link}" || -e "${link}" ]]; then
        PrintText "Overwriting existing link at: ${link}"
        ln -fs "${source}" "${link}"
    else
        PrintText "Creating symbolic link: ${link} points to ${source}"
        ln -s "${source}" "${link}"
    fi
}



#######################################################################
# PACKAGE INSTALLATION
#######################################################################
ppas_apt=( )
function EnablePpa {
    if command -v apt-get &> /dev/null; then
        PrintHeader 'PPA'
        for i in "${ppas_apt[@]}"; do
            #if [[ ! $(apt-add-repository --list | grep "${i#ppa:}" ) ]]; then
            if ! apt-add-repository --list | grep -q "${i#ppa:}"; then
                sudo apt-add-repository -yn "${i}"
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

pkgs_apt=( )
function InstallApt {
    if command -v apt-get &> /dev/null; then
        PrintHeader 'APT'
        for i in "${pkgs_apt[@]}"; do
            #if [[ ! $(dpkg -l | awk '{print $2}' | grep "^${i}") ]]; then
            if ! dpkg -l | awk '{print $2}' | grep -q "^${i}"; then
                sudo apt-get install -y "${i}"
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

pkgs_dnf=()
function InstallDnf {
    if command -v dnf &> /dev/null; then
        PrintHeader 'DNF'
        for i in "${pkgs_dnf[@]}"; do
            #if [[ ! $(dnf list --installed | grep "^${i}") ]]; then
            if ! dnf list --installed | grep -q "^${i}"; then
                sudo dnf install -y "${i}"
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

pkgs_pacman=()
function InstallPacman {
    if command -v pacman &> /dev/null; then
        PrintHeader 'PACMAN'
        for i in "${pkgs_pacman[@]}"; do
            #if [[ ! $(pacman -Qq | grep "^${i}") ]]; then
            if ! pacman -Qq | grep -q "^${i}"; then
                sudo pacman -S --needed --noconfirm "${i}";
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

pkgs_snap=()
function InstallSnap {
    if command -v snap &> /dev/null; then
        PrintHeader 'SNAP'
        for i in "${pkgs_snap[@]}"; do
            #if [[ ! $(snap list --all | grep "^${i}") ]]; then
            if ! snap list --all | grep -q "^${i}"; then
                sudo snap install "${i}" --classic
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

pkgs_flatpak=()
function InstallFlatpak {
    if command -v flatpak &> /dev/null; then
        PrintHeader 'FLATPAK'
        for i in "${pkgs_flatpak[@]}"; do
            #if [[ ! $(flatpak --user list --all --columns=app | grep "^${i}") ]]; then
            if ! flatpak --user list --all --columns=app | grep -q "^${i}"; then
                flatpak --user install "${i}"
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

pkgs_pipx=()
function InstallPipx {
    if command -v python &> /dev/null; then
        PYTHON="python"
    elif command -v python3 &> /dev/null; then
        PYTHON="python3"
    else
        echo 'python not found'
        return
    fi
    PrintHeader 'PIPX'
    ${PYTHON} -m pip install --user --upgrade pip
    ${PYTHON} -m pip install --user --upgrade pipx
    for i in "${pkgs_pipx[@]}"; do
        #if [[ ! $(pipx list --short | awk '{print $1}' | grep "^${i}") ]]; then
        if ! pipx list --short | awk '{print $1}' | grep -q "^${i}"; then
            pipx install "${i}"
        else
            echo "${i} is already installed."
        fi
    done
}

# set flag to true after sourcing the entire file
COMMON_SH_SOURCED=1
