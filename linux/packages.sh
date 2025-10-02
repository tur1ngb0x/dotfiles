#!/usr/bin/env bash

# PPAs
sudo add-apt-repository --yes --no-update ppa:git-core/ppa
sudo add-apt-repository --yes --no-update ppa:flatpak/stable
sudo add-apt-repository --yes --no-update ppa:papirus/papirus
sudo add-apt-repository --yes --no-update ppa:fish-shell/release-4
sudo add-apt-repository --yes --no-update ppa:flexiondotorg/quickemu

/usr/bin/sudo /usr/bin/apt install --assume-yes \
    android-sdk-platform-tools \
    atool p7zip-full p7zip-rar \
    build-essential cmake \
    micro nano vim \
    ffmpeg mediainfo \
    curl wget \
    python-is-python3 python3-pip python3-venv \
    bash-completion dialog dos2unix fzf most tree xclip \
    git

/usr/bin/sudo /usr/bin/dnf install --assumeyes \
    android-tools \
    atool p7zip p7zip-plugins \
    cmake gcc ncurses procps-ng \
    nano vim \
    ffmpeg mediainfo \
    curl wget \
    python3-pip python3-virtualenv \
    bash-completion dialog dos2unix fzf most tree xclip \
    git

/usr/bin/sudo /usr/bin/pacman --sync --noconfirm \
    android-tools \
    atool p7zip \
    base-devel cmake \
    nano vim \
    ffmpeg mediainfo \
    curl wget \
    python-virtualenv \
    bash-completion dialog dos2unix fzf most tree xclip \
    git

/usr/bin/sudo /usr/bin/snap install --color never --unicode never\
    pieces-os \
    pieces-for-developers \
    powershell

/usr/bin/sudo /usr/bin/flatpak --user install --assumeyes --noninteractive flathub \
    com.bitwarden.desktop io.ente.auth \
    com.google.Chrome com.microsoft.Edge org.mozilla.firefox com.brave.Browser \
    com.valvesoftware.Steam io.mgba.mGBA \
    org.kde.gwenview org.kde.kolourpaint org.kde.okular org.videolan.VLC \
    com.discordapp.Discord org.telegram.desktop org.qbittorrent.qBittorrent
