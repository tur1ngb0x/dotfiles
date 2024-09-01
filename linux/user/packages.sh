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

pkgs_flatpak_kde=(
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
)

pkgs_flatpak_gnome=(
	'org.gnome.Epiphany'	# Browser
	'org.gnome.Calculator'	# Calculator
	'org.gnome.Calendar'	# Calendar
	'org.gnome.Snapshot'	# Camera
	'org.gnome.Characters'	# Characters
	'org.gnome.clocks'		# Clock
	'org.gnome.Connections'	# Connections
	'org.gnome.Contacts'	# Contacts
	'org.gnome.baobab'		# Disk
	'ca.desrt.dconf-editor'	# Dconf
	'org.gnome.Evince'		# Documents
	'org.gnome.TextEditor'	# Editor
	'org.gnome.Extensions'	# Extensions
	'org.gnome.Loupe'		# Image
	'org.gnome.Logs'		# Logs
	'org.gnome.Maps'		# Maps
	'org.gnome.Papers'		# Reader
	'org.gnome.SimpleScan'	# Scanner
	'org.gnome.Boxes'		# Virtualization
	'org.gnome.Weather'		# Weather
)

pkgs_pipx=(
	gallery-dl
	glances
	mycli
	ps_mem
	shellcheck-py
	speedtest-cli
	tldr
	yt-dlp
)

function post_virt-manager {
	[[ ! -f /usr/bin/virt-manager ]] && echo 'virt-manager is not installed' && return
	sudo groupadd -f kvm
	sudo usermod -aG kvm "${USER}"
	sudo groupadd -f libvirt
	sudo usermod -aG libvirt "${USER}"
	[[ ! -f /etc/libvirt/libvirtd.conf ]] && sudo cp -fv /etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf.bak
	cat <<-'EOF' | sudo tee -a /etc/libvirt/libvirtd.conf
	unix_sock_group = "libvirt"
	unix_sock_ro_perms = "0770"
	unix_sock_rw_perms = "0770"
	auth_unix_ro = "none"
	auth_unix_rw = "none"
	EOF
	cat <<-EOF | sudo tee -a /etc/libvirt/qemu.conf
	user = "${USER}"
	group = "${USER}"
	EOF
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

text 'ppa_apt'; for ppa in "${ppas_apt[@]}"; do sudo apt-add-repository -yn "${ppa}"; done
text 'pkgs_apt'; for pkg in "${pkgs_apt[@]}"; do sudo apt-get install -y "${pkg}"; done
text 'pkgs_pipx'; for pkg in "${pkgs_pipx[@]}"; do pipx install "${pkg}"; done
text 'pkgs_snap'; for pkg in "${pkgs_snap[@]}"; do sudo snap install "${pkg}" --classic;   done
text 'pkgs_flatpak'; for pkg in "${pkgs_flatpak_gnome[@]}"; do flatpak --user install -y "${pkg}";   done
