#!/usr/bin/env bash

# get current directory & source common template
CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"
source "${CWD}"/common.sh

function PostInstall_VirtManager {
    if command -v virt-manager; then
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

function PostInstall_MYSQL {
    if command -v mysql; then
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

function PostInstall_Pieces {
    if snap list pieces-os; then
        sudo snap connect pieces-os:process-control :process-control
    else
        echo 'pieces-os is not installed'
    fi
}

function main {
    PostInstall_VirtManager
    PostInstall_MYSQL
    PostInstall_Pieces
}

# begin script from here
main "${@}"
