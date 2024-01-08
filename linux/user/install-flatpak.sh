#!/usr/bin/env bash

sudo add-apt-repository -yn ppa:flatpak/stable && sudo apt-get update
sudo apt-get install -y flatpak
sudo dnf install -y flatpak
sudo pacman -S flatpak


flatpak remote-delete flathub
flatpak remote-delete fedora
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

pkgs_flatpak=(
	com.authy.Authy
	com.bitwarden.desktop
	com.discordapp.Discord
	com.google.Chrome
	com.microsoft.Edge
	com.valvesoftware.Steam
	io.mgba.mGBA
	org.kde.gwenview
	org.kde.kolourpaint
	org.kde.okular
	org.mozilla.firefox
	org.qbittorrent.qBittorrent
	org.telegram.desktop
	org.videolan.VLC
	com.mattjakeman.ExtensionManager
	com.github.tchx84.Flatseal
)

pkgs_flatpak_gnome=(

)

pkgs_flatpak_plasma=(

)

for pkg in "${pkgs_flatpak[@]}"; do flatpak --user install --assumeyes --or-update "${pkg}"; done
