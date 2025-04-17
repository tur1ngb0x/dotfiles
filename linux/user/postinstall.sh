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
