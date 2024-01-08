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

pkgs_ubuntu=(
	atool
	axel
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
	python3-pip
	python3-venv
	tree
	vim
	wget
	xclip
)

ppa_ubuntu=(
	'ppa:flatpak/stable'
	'ppa:git-core/ppa'
	'ppa:papirus/papirus'
)

# for pkg in "${pkgs_snap[@]}"; do sudo snap refresh && sudo snap install "${pkg}"; done
# for pkg in "${pkgs_flatpak[@]}"; do flatpak update && flatpak install -y "${pkg}"; done
# for ppa in "${ppa_ubuntu[@]}"; do sudo apt update && sudo apt-add-repository -yn "${pkg}" && sudo apt-; done
# for pkg in "${pkgs_ubuntu[@]}"; do sudo apt install -y "${pkg}"; done

for pkg in "${pkgs_snap[@]}"; do echo "${pkg}"; done
for pkg in "${pkgs_flatpak[@]}"; do echo "${pkg}"; done
for ppa in "${ppa_ubuntu[@]}"; do echo "${pkg}"; done
for pkg in "${pkgs_ubuntu[@]}"; do echo "${pkg}"; done
