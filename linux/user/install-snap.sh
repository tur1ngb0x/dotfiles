#!/usr/bin/env bash

# remove snap blocker
sudo rm -fv /etc/apt/preferences.d/nosnap.pref

# install snapd
sudo apt-get install -y snapd
sudo dnf install -y snapd
sudo pacman -Syu snapd

# disable automatic snapshots
sudo snap set system snapshots.automatic.retention=no

# disable automatic updates
sudo snap refresh --hold

# remove old snapshots
LANG=C sudo snap list --all | while read -r name version revision tracking publisher notes; do if [[ "${notes}" = *disabled* ]]; then sudo snap remove --purge "${name}" --revision="${revision}"; fi; done; unset name version revision tracking publisher notes
