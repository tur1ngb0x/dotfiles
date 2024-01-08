#!/usr/bin/env bash

sudo rm -fv /etc/apt/preferences.d/nosnap.pref

sudo apt-get install -y snapd

sudo snap set system snapshots.automatic.retention=no

sudo snap set system refresh.retain=0

sudo snap refresh --hold

# remove old snap versions
# LANG=C sudo snap list --all | while read snapname ver rev trk pub notes; do if [[ "${notes}" = *disabled* ]]; then sudo snap remove "${snapname}" --revision="${rev}"; fi; done
