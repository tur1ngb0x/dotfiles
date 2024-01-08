#!/usr/bin/env bash

# directories
mkdir -pv "${HOME}"/Applications
mkdir -pv "${HOME}"/.local/bin

# micro
wget -4O /tmp/micro.sh 'https://getmic.ro' && pushd "${HOME}"/.local/bin && sh /tmp/micro.sh && popd

# ncdu
wget -4O- 'https://dev.yorhel.nl/download/ncdu-2.3-linux-x86_64.tar.gz' | tar -xvz -C "${HOME}"/.local/bin

# yt-dlp
wget -4O "${HOME}"/.local/bin/yt-dlp 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp'

# telegram
wget -4O- 'https://telegram.org/dl/desktop/linux' | tar -xvJ -C "${HOME}"/Applications && (nohup "${HOME}"/Applications/Telegram/Telegram &) &> /tmp/telegram.out

# toolbox
wget -4O- 'https://data.services.jetbrains.com/products/download?platform=linux&code=TBA' | tar -xvz --strip-components=1 -C /tmp && (nohup /tmp/jetbrains-toolbox &) &> /tmp/jetbrains-toolbox.out

# permissions
chmod -fvR 0755 "${HOME}"/.local/bin/*

# listing
ls -al "${HOME}"/.local/bin/*
