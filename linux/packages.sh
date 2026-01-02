#!/usr/bin/env bash

# PPA
[ -f /usr/bin/add-apt-repository ] && {
    for i in \
        ppa:git-core/ppa \
        ppa:flatpak/stable \
        ppa:papirus/papirus \
        ppa:fish-shell/release-4 \
        ppa:flexiondotorg/quickemu
    do sudo add-apt-repository -y -n "${i}"; done
}

# APT
[[ -f /usr/bin/apt-get ]] && {
    sudo apt-get update
    sudo apt-get full-upgrade -y
    for i in \
        android-sdk-platform-tools \
        atool p7zip-full p7zip-rar \
        build-essential cmake \
        micro nano vim \
        ffmpeg mediainfo \
        curl wget \
        python-is-python3 python3-pip python3-venv \
        bash-completion dialog dos2unix fzf most tree xclip \
        git \
        ubuntu-restricted-extras
    do sudo apt-get install -y "${i}"; done
}

# DNF
[[ -f /usr/bin/dnf ]] && {
    sudo dnf upgrade --refresh -y
    for i in \
        android-tools \
        atool p7zip p7zip-plugins \
        cmake gcc ncurses procps-ng \
        nano vim \
        ffmpeg mediainfo \
        curl wget \
        python3-pip python3-virtualenv \
        bash-completion dialog dos2unix fzf most tree xclip \
        git
    do sudo dnf install -y "${i}"; done
}

# PACMAN
[[ -f /usr/bin/pacman ]] && {
    sudo pacman -Syyu --noconfirm
    for i in \
        android-tools \
        atool p7zip \
        base-devel cmake \
        nano vim \
        ffmpeg mediainfo \
        curl wget \
        python-virtualenv \
        bash-completion dialog dos2unix fzf most tree xclip \
        git
    do sudo pacman -S --noconfirm "${i}"; done
}

# PIPX
[[ -f /usr/bin/pipx ]] && {
    for i in \
        gallery-dl \
        glances \
        mycli \
        ps_mem \
        shellcheck-py \
        speedtest-cli \
        tldr \
        yt-dlp
    do pipx install "${i}"; done
}

# FLATPAK
[[ -f /usr/bin/flatpak ]] && {
    flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    for i in \
        com.bitwarden.desktop io.ente.auth \
        com.google.Chrome com.microsoft.Edge org.mozilla.firefox com.brave.Browser \
        com.valvesoftware.Steam io.mgba.mGBA \
        org.kde.gwenview org.kde.kolourpaint org.kde.okular org.videolan.VLC \
        com.discordapp.Discord org.telegram.desktop org.qbittorrent.qBittorrent
    do flatpak --user install -y flathub "${i}"; done
}

# SNAP
[[ -f /usr/bin/snap ]] && {
    for i in \
        pieces-os \
        pieces-for-developers \
        powershell
    do sudo snap install "${i}"; done
}
