#!/usr/bin/env bash

function text { tput rev; printf "\n %s \n" "${1}"; tput sgr0; }

ppas_apt=(
    'ppa:git-core/ppa'
    'ppa:flatpak/stable'
    'ppa:papirus/papirus'
)

pkgs_apt=(
    android-sdk-platform-tools
    atool
    bash-completion
    build-essential
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
    pipx
    python-is-python3
    python3-pip
    python3-venv
    tree
    vim
    wget
    xclip
)

pkgs_dnf=(
    android-tools
    atool
    bash-completion
    gcc
    curl
    dialog
    dos2unix
    ffmpeg
    fzf
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
)

pkgs_pacman=(
    android-tools
    atool
    bash-completion
    base-devel
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
)

pkgs_snap=(
    'pieces-os'                     # code assistant server
    'pieces-for-developers'         # code assistant
    'powershell'                    # windows shell
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
    gallery-dl                      # image downloader
    glances                         # system info
    mycli                           # sql cli
    ps_mem                          # memory info
    shellcheck-py                   # shell checker
    sherlock-project                # username checker
    speedtest-cli                   # speed test cli
    tldr                            # man pages
    topgrade                        # system updater
    yt-dlp                          # media downloader
    youtube-dl                      # media downloader
)

if [[ $(command -v systemd-detect-virt) ]]; then
    virt_type=$(systemd-detect-virt)
    if [[ "${virt_type}" != "none" ]]; then
        echo "Virtualization: ${virt_type}"
	else
		echo "Virtualization: none"
    fi
fi

# if package is not installed, install it
function install_apt     { text 'APT';      for i in "${pkgs_apt[@]}";      do [[ ! $(dpkg -l | awk '{print $2}' | grep "^${i}") ]] && sudo apt-get install -y "${i}"; done; }
function install_dnf     { text 'DNF';      for i in "${pkgs_dnf[@]}";      do [[ ! $(dnf list --installed | grep "^${i}") ]] && sudo dnf install -y "${i}"; done; }
function install_pacman  { text 'PACMAN';   for i in "${pkgs_pacman[@]}";   do [[ ! $(pacman -Qq | grep "^${i}") ]] && sudo pacman -S "${i}"; done; }
function install_snap    { text 'SNAP';     for i in "${pkgs_snap[@]}";     do [[ ! $(snap list --all | grep "^${i}") ]] && sudo snap install "${i}" --classic; done; }
function install_flatpak { text 'FLATPAK';  for i in "${pkgs_flatpak[@]}";  do [[ ! $(flatpak --user list --all --columns=app | grep "^${i}") ]] && flatpak --user install "${i}"; done; }
function install_pipx    { text 'PIPX';     for i in "${pkgs_pipx[@]}";     do [[ ! $(pipx list | grep "^${i}") ]] && pipx install "${i}"; done; }

function post_install_virt-manager {
    if [[ $(command -v virt-manager) ]]; then
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
    else
        echo 'virt-manager is not installed'
    fi
}

function post_install_mysql {
    if [[ $(command -v mysql) ]]; then
        mysql --show-warnings --user root --password --execute "\
            DROP USER IF EXISTS user@localhost;\
            CREATE USER IF NOT EXISTS user@localhost IDENTIFIED BY '1234567890';\
            GRANT ALL PRIVILEGES ON *.* TO user@localhost;\
            FLUSH PRIVILEGES;\
        "
        mysql --show-warnings --user root --password --execute "\
            SELECT user,host,plugin,password_expired FROM mysql.user;\
        "
    else
        echo 'mysql is not installed'
    fi
}

function post_install_pieces {
    if [[ $(snap list pieces-os) ]]; then
        sudo snap connect pieces-os:process-control :process-control
    else
        echo 'pieces-os is not installed'
    fi
}

function main {
    text 'APT';     install_apt
    text 'DNF';     install_dnf
    text 'PACMAN';  install_pacman
    text 'SNAP';    install_snap
    text 'FLATPAK'; install_flatpak
    text 'PIPX';    install_pipx
}

main "${@}"
