#!/usr/bin/env bash

# chrome
wget -4O /tmp/chrome.deb 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
sudo apt install -y /tmp/chrome.deb

# code
wget -4O /tmp/code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt install -y /tmp/code.deb

# docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
cat << EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
EOF
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd -f docker && sudo usermod -aG docker "${USER}"

# mysql
wget -4O /tmp/mysql.deb 'https://repo.mysql.com/mysql-apt-config_0.8.29-1_all.deb'
sudo apt update && sudo apt install -y /tmp/mysql.deb
sudo apt-get update && sudo apt install -y mysql-server mysql-workbench-community libmysqlclient21
mysql --show-warnings --user root --password --execute "\
	DROP USER IF EXISTS user@localhost;\
	CREATE USER IF NOT EXISTS user@localhost IDENTIFIED BY '1234567890';\
	GRANT ALL PRIVILEGES ON *.* TO user@localhost;\
	FLUSH PRIVILEGES;\
"
mysql --show-warnings --user root --password --execute "\
	SELECT user,host,plugin,password_expired FROM mysql.user;\
"

# virt-manager
sudo groupadd -f kvm && sudo usermod -aG kvm "${USER}"
sudo groupadd -f libvirt && sudo usermod -aG libvirt "${USER}"
cat << EOF | sudo tee -a /etc/libvirt/libvirtd.conf
unix_sock_group = "libvirt"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0770"
EOF
cat << EOF | sudo tee -a /etc/libvirt/qemu.conf
swtpm_user = "swtpm"
swtpm_group = "swtpm"
user = "${USER}"
group = "${USER}"
EOF
