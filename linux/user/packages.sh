#!/usr/bin/env bash

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
)

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
)

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
)

pkgs_snap=(
    pieces-os                       # code assistant server
    pieces-for-developers           # code assistant
    powershell                      # windows shell
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
    ansible-core					# github.com/ansible/ansible
    black							# github.com/psf/black
    gallery-dl                      # github.com/mikf/gallery-dl
    glances                         # github.com/nicolargo/glances
    mycli                           # github.com/dbcli/mycli
    ps_mem                          # github.com/pixelb/ps_mem
    shellcheck-py                   # github.com/shellcheck-py/shellcheck-py
    sherlock-project                # github.com/sherlock-project/sherlock
    shtab							# github.com/iterative/shtab
    speedtest-cli                   # github.com/sivel/speedtest-cli
    tldr                            # github.com/tldr-pages/tldr
    topgrade                        # github.com/topgrade-rs/topgrade
    trash-cli						# github.com/andreafrancia/trash-cli
    uv								# github.com/astral-sh/uv
    youtube-dl                      # github.com/ytdl-org/youtube-dl
    yt-dlp                          # github.com/yt-dlp/yt-dlp
)

function text { printf "\033[7m# %s \033[0m\n" "${1}"; }

function elevate_user {
    if [[ $(id -ur) -eq 0 ]]; then
        ELEVATE=""
    elif [[ $(command -v sudo) ]]; then
        ELEVATE="sudo"
    elif [[ $(command -v doas) ]]; then
        ELEVATE="doas"
    else
        echo 'Install sudo or doas'
        exit
    fi
}

function detect-virt {
    if [[ $(command -v systemd-detect-virt) ]]; then
        VIRT_TYPE=$(systemd-detect-virt)
        if [[ "${VIRT_TYPE}" != "none" ]]; then
            echo "Virtualization: ${VIRT_TYPE}"
        else
            echo "Virtualization: none"
        fi
    fi
}

function install_ppa {
    text 'PPA'
    for i in "${ppas_apt[@]}"; do
        if [[ ! $(apt-add-repository --list | grep "${i#ppa:}" ) ]]; then
            ${ELEVATE} apt-add-repository -yn "${i}"
        else
            echo "${i} is already installed."
        fi
    done
}

function install_apt {
    if [[ $(command -v apt-get) ]]; then
        text 'APT'
        for i in "${pkgs_apt[@]}"; do
            if [[ ! $(dpkg -l | awk '{print $2}' | grep "^${i}") ]]; then
                ${ELEVATE} apt-get install -y "${i}"
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

function install_dnf {
    if [[ $(command -v dnf) ]]; then
        text 'DNF'
        for i in "${pkgs_dnf[@]}"; do
            if [[ ! $(dnf list --installed | grep "^${i}") ]]; then
                ${ELEVATE} dnf install -y "${i}"
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

function install_pacman {
    if [[ $(command -v pacman) ]]; then
        text 'PACMAN'
        for i in "${pkgs_pacman[@]}"; do
            if [[ ! $(pacman -Qq | grep "^${i}") ]]; then
                ${ELEVATE} pacman -S --needed --noconfirm "${i}";
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

function install_snap {
    if [[ $(command -v snap) ]]; then
        text 'SNAP'
        for i in "${pkgs_snap[@]}"; do
            if [[ ! $(snap list --all | grep "^${i}") ]]; then
                ${ELEVATE} snap install "${i}" --classic
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

function install_flatpak {
    if [[ $(command -v flatpak) ]]; then
        text 'FLATPAK'
        for i in "${pkgs_flatpak[@]}"; do
            if [[ ! $(flatpak --user list --all --columns=app | grep "^${i}") ]]; then
                flatpak --user install "${i}"
            else
                echo "${i} is already installed."
            fi
        done
    fi
}

function install_pipx {
    if [[ $(command -v python) ]]; then
        PYTHON="python"
    elif [[ $(command -v python3) ]]; then
        PYTHON="python3"
    else
        echo 'python not found'
        return
    fi
    ${PYTHON} -m pip install --user --upgrade pip
    ${PYTHON} -m pip install --user --upgrade pipx
    text 'PIPX'
    for i in "${pkgs_pipx[@]}"; do
        if [[ ! $(pipx list --short | awk '{print $1}' | grep "^${i}") ]]; then
            pipx install "${i}"
        else
            echo "${i} is already installed."
        fi
    done
}

function post_install_virt-manager {
    if [[ $(command -v virt-manager) ]]; then
        ${ELEVATE} groupadd -f kvm
        ${ELEVATE} usermod -aG kvm "${USER}"
        ${ELEVATE} groupadd -f libvirt
        ${ELEVATE} usermod -aG libvirt "${USER}"
        cat <<-'EOF' | ${ELEVATE} tee -a /etc/libvirt/libvirtd.conf
unix_sock_group = "libvirt"
unix_sock_ro_perms = "0770"
unix_sock_rw_perms = "0770"
auth_unix_ro = "none"
auth_unix_rw = "none"
EOF
        cat <<-'EOF' | ${ELEVATE} tee -a /etc/libvirt/qemu.conf
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
        ${ELEVATE} snap connect pieces-os:process-control :process-control
    else
        echo 'pieces-os is not installed'
    fi
}

function main {
    elevate_user
    install_ppa
    install_apt
    install_dnf
    install_pacman
    install_snap
    install_flatpak
    install_pipx
}

# begin script from here
main "${@}"
