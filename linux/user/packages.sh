#!/usr/bin/env bash

function text { tput rev; printf "\n %s \n" "${1}"; tput sgr0; }

ppas_apt=(
	'ppa:flatpak/stable'
	'ppa:git-core/ppa'
	'ppa:papirus/papirus'
)

pkgs_apt=(
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

pkgs_dnf=(
		atool
		bash-completion
		base-devel
		curl
		dos2unix
		ffmpeg
		git
		mediainfo
		most
		nano
		p7zip
		pipx
		tree
		vim
		wget
		xclip
		virt-manager
)

pkgs_pacman=(
	atool
	bash-completion
	base-devel
	curl
	dos2unix
	ffmpeg
	git
	mediainfo
	most
	nano
	p7zip
	pipx
	tree
	vim
	wget
	xclip
	virt-manager
)

pkgs_snap=(
	pieces-os
	pieces-for-developers
)

pkgs_flatpak=(
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

function install_apt {
	sudo apt-get install -y "${pkgs_apt[@]}"
}

function install_dnf {
	sudo dnf install -y "${pkgs_dnf[@]}"
}

function install_pacman {
	sudo pacman -S --needed ---noconfirm "${pkgs_pacman[@]}"
}

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

text 'pkgs_snap';        for pkg in "${pkgs_snap[@]}";       do sudo snap install             "${pkg}";   done
text 'pkgs_flatpak';     for pkg in "${pkgs_flatpak[@]}";    do flatpak --user install -y     "${pkg}";   done
text 'ppa_apt';      for ppa in "${ppas_apt[@]}";    do sudo apt-add-repository -y    "${ppa}";   done
text 'pkgs_apt';     for pkg in "${pkgs_apt[@]}";   do sudo apt-get install -y       "${pkg}";   done

function main {
	if [[ -f /usr/bin/apt ]]; then
		upgrade_apt
	elif [[ -f /usr/bin/dnf ]]; then
		upgrade_dnf
	elif [[ -f /usr/bin/pacman ]]; then
		upgrade_pacman
	else
		text 'only apt/dnf/pacman are supported.'
	fi

	if [[ -f /usr/bin/snap ]]; then
		upgrade_snap
	fi

	if [[ -f /usr/bin/flatpak ]]; then
		upgrade_flatpak
	fi

	if [[ -f /usr/bin/code ]]; then
		upgrade_code
	fi

	if [[ -f /usr/bin/docker ]]; then
		upgrade_docker
	fi

	if [[ -f /usr/bin/pipx ]]; then
		upgrade_pipx
	fi
}
