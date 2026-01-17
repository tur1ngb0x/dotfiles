#!/usr/bin/env bash

ppas_apt=(
    'ppa:git-core/ppa'
    'ppa:flatpak/stable'
    'ppa:fish-shell/release-4'
    'ppa:papirus/papirus'
    'ppa:flexiondotorg/quickemu'
)

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
    fish
    flatpak
    fzf
    git
    mediainfo
    micro
    most
    nano
    p7zip-full
    p7zip-rar
    python-is-python3
    python3-pip
    python3-venv
    tree
    ubuntu-restricted-extras
    vim
    wget
    xclip
)

pkgs_dnf=(
    android-tools
    atool
    bash-completion
    cmake
    curl
    dialog
    dos2unix
    ffmpeg
    fish
    flatpak
    fzf
    git
    mediainfo
    micro
    most
    nano
    p7zip
    p7zip-plugins
    python3
    python3-pip
    tree
    vim
    wget
    xclip
)

pkgs_pacman=(
    android-tools
    atool
    base-devel
    bash-completion
    cmake
    curl
    dialog
    dos2unix
    ffmpeg
    fish
    flatpak
    fzf
    git
    mediainfo
    micro
    most
    nano
    p7zip
    p7zip-plugins
    python
    python-pip
    tree
    vim
    wget
    xclip
)

upgrade_apt(){
    ${ELEVATE:-} /usr/bin/apt-get update    
    ${ELEVATE:-} /usr/bin/apt-get -y upgrade
}

update_apt(){
    ${ELEVATE:-} /usr/bin/apt-get update
}

install_apt(){
    ${ELEVATE:-} /usr/bin/apt-get install --no-install-recommends --no-install-suggests -y "${@:?}"
}

install_ppa(){
    ${ELEVATE:-} /usr/bin/add-apt-repository -y -n "${1:?}"
}

if [[ "$(command id -ur)" -ne 0 ]]; then
    if [[ -f /usr/bin/sudo ]]; then
        export ELEVATE='/usr/bin/sudo'
    elif [[ -f /usr/bin/doas ]]; then
        export ELEVATE='/usr/bin/doas'
    elif [[ -f /usr/bin/sudo-rs ]]; then
        export ELEVATE='/usr/bin/sudo-rs'
    else
        echo 'install sudo || doas || sudo-rs to continue...'; exit
    fi
fi

# APT
export DEBIAN_FRONTEND=noninteractive; 
echo 'tzdata tzdata/Areas select Asia' | debconf-set-selections
echo 'tzdata tzdata/Zones/Asia select Kolkata' | debconf-set-selections
update_apt
install_apt dialog software-properties-common
for ppa in "${ppas_apt[@]}"; do install_ppa "${i}"; done
upgrade_apt



# # PIPX
# [[ -f /usr/bin/pipx ]] && {
#     for i in \
#         gallery-dl \
#         glances \
#         mycli \
#         ps_mem \
#         shellcheck-py \
#         speedtest-cli \
#         tldr \
#         yt-dlp
#     do pipx install "${i}"; done
# }

# # FLATPAK
# [[ -f /usr/bin/flatpak ]] && {
#     flatpak --user remote-add flathub-user https://flathub.org/repo/flathub.flatpakrepo
#     for i in \
#         com.bitwarden.desktop \
#         io.ente.auth \
#         com.google.Chrome \
#         com.microsoft.Edge \
#         org.mozilla.firefox \
#         com.brave.Browser \
#         com.valvesoftware.Steam \
#         io.mgba.mGBA \
#         org.kde.gwenview \
#         org.kde.kolourpaint \
#         org.kde.okular \
#         org.videolan.VLC \
#         com.discordapp.Discord \
#         org.telegram.desktop \
#         org.qbittorrent.qBittorrent
#     do flatpak --user install -y flathub-user "${i}"; done
# }

# # SNAP
# [[ -f /usr/bin/snap ]] && {
#     for i in \
#         pieces-os \
#         pieces-for-developers \
#         powershell
#     do ${ELEVATE:-} snap install "${i}"; done
# }
