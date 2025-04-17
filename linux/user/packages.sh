#!/usr/bin/env bash

# get current directory and source common template
CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"
source "${CWD}"/common.sh

ppas_apt=(
    'ppa:git-core/ppa'
    'ppa:flatpak/stable'
    'ppa:papirus/papirus'
); export ppas_apt

pkgs_apt=(
    android-sdk-platform-tools
    atool
    bash-completion
    build-essential
    cmake
    curl
    dialog
    dos2unix
    ffmpeg
    fzf
    git
    mediainfo
    most
    nano
    p7zip-full
    p7zip-rar
    python-is-python3
    python3-pip
    python3-venv
    tree
    vim
    wget
    xclip
); export pkgs_apt

pkgs_dnf=(
    procps-ng
    android-tools
    atool
    bash-completion
    cmake
    curl
    dialog
    dos2unix
    ffmpeg
    fzf
    gcc
    git
    mediainfo
    most
    nano
    ncurses
    p7zip
    p7zip-plugins
    python3-pip
    python3-virtualenv
    tree
    vim
    wget
    xclip
); export pkgs_dnf

pkgs_pacman=(
    android-tools
    atool
    bash-completion
    base-devel
    cmake
    curl
    dialog
    dos2unix
    ffmpeg
    fzf
    git
    mediainfo
    most
    nano
    p7zip
    python-virtualenv
    tree
    vim
    wget
    xclip
); export pkgs_pacman

pkgs_snap=(
    pieces-os                       # code assistant server
    pieces-for-developers           # code assistant
    powershell                      # windows shell
); export pkgs_snap

pkgs_flatpak=(
    com.bitwarden.desktop           # bitwarden
    io.ente.auth                    # ente auth
    com.google.Chrome               # chrome
    com.microsoft.Edge              # edge
    org.mozilla.firefox             # firefox
    com.brave.Browser               # brave
    com.discordapp.Discord          # discord
    org.telegram.desktop            # telegram
    com.ktechpit.whatsie            # whatsie
    com.valvesoftware.Steam         # steam
    io.mgba.mGBA                    # mgba
    org.kde.gwenview                # gwenview
    org.kde.kolourpaint             # kolourpaint
    org.kde.okular                  # okular
    org.qbittorrent.qBittorrent     # qbittorrent
    org.videolan.VLC                # vlc
); export pkgs_flatpak

pkgs_pipx=(
    ansible-core                    # github.com/ansible/ansible
    black                           # github.com/psf/black
    gallery-dl                      # github.com/mikf/gallery-dl
    glances                         # github.com/nicolargo/glances
    mycli                           # github.com/dbcli/mycli
    ps_mem                          # github.com/pixelb/ps_mem
    shellcheck-py                   # github.com/shellcheck-py/shellcheck-py
    sherlock-project                # github.com/sherlock-project/sherlock
    shtab                           # github.com/iterative/shtab
    speedtest-cli                   # github.com/sivel/speedtest-cli
    tldr                            # github.com/tldr-pages/tldr
    topgrade                        # github.com/topgrade-rs/topgrade
    trash-cli                       # github.com/andreafrancia/trash-cli
    uv                              # github.com/astral-sh/uv
    youtube-dl                      # github.com/ytdl-org/youtube-dl
    yt-dlp                          # github.com/yt-dlp/yt-dlp
); export pkgs_pipx


function main {
    EnablePpa
    InstallApt
    #InstallDnf
    #InstallPacman
    #InstallSnap
    InstallFlatpak
    InstallPipx
}

# begin script from here
main "${@}"
