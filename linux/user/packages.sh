#!/usr/bin/env bash

function text { tput rev; printf "\n %s \n" "${1}"; tput sgr0; }

ppas_apt=(
    'ppa:flatpak/stable'
    'ppa:git-core/ppa'
    'ppa:papirus/papirus'
)

pkgs_apt=(
    android-sdk-platform-tools
    atool
    bash-completion
    build-essential
    curl
    dos2unix
    ffmpeg
	fzf
    git
    mediainfo
    most
    nano
    p7zip-full
    p7zip-rar
    pipx
    python-is-python3
    python3-pip
    python3-venv
    tree
    vim
    wget
    xclip
)

pkgs_snap=(
    'pieces-os'
    'pieces-for-developers'
    'powershell'
)

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
)

pkgs_pipx=(
    gallery-dl
    glances
    mycli
    ps_mem
    shellcheck-py
    sherlock-project
    speedtest-cli
    tldr
    topgrade
    yt-dlp
)

function post_virt-manager {
    if [[ ! -f /usr/bin/virt-manager ]]; then
        echo 'virt-manager is not installed'
    else
        sudo groupadd -f kvm
        sudo usermod -aG kvm "${USER}"
        sudo groupadd -f libvirt
        sudo usermod -aG libvirt "${USER}"
        cat <<-'EOF' | sudo tee -a /etc/libvirt/libvirtd.conf
        unix_sock_group = "libvirt"
        unix_sock_ro_perms = "0770"
        unix_sock_rw_perms = "0770"
        auth_unix_ro = "none"
        auth_unix_rw = "none"
EOF
    cat <<-'EOF' | sudo tee -a /etc/libvirt/qemu.conf
    user = "${USER}"
    group = "${USER}"
EOF
    fi
}

function post_mysql {
    [[ ! -f /usr/bin/mysql ]] && echo 'mysql is not installed' && return
    mysql --show-warnings --user root --password --execute "\
        DROP USER IF EXISTS user@localhost;\
        CREATE USER IF NOT EXISTS user@localhost IDENTIFIED BY '1234567890';\
        GRANT ALL PRIVILEGES ON *.* TO user@localhost;\
        FLUSH PRIVILEGES;\
    "
    mysql --show-warnings --user root --password --execute "\
        SELECT user,host,plugin,password_expired FROM mysql.user;\
    "
}

function post_pieces {
    [[ ! $(snap list pieces-os) ]] && echo 'pieces-os is not installed' && return
    sudo snap connect pieces-os:process-control :process-control
}

function main {
    text 'PPA';		for i in "${ppas_apt[@]}"; do     sudo apt-add-repository -yn "${i}"; done
    text 'APT';		for i in "${pkgs_apt[@]}"; do     sudo apt-get install -y "${i}"; done
	text 'PIPX';	for i in "${pkgs_pipx[@]}"; do    pipx install "${i}"; done
    text 'SNAP';	for i in "${pkgs_snap[@]}"; do    sudo snap install "${i}" --classic; done
    text 'FLATPAK';	for i in "${pkgs_flatpak[@]}"; do sudo flatpak --user install "${i}"; done

    post_virt-manager
    post_pieces
    post_mysql
}

main "${@}"
