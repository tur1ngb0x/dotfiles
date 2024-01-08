#!/usr/bin/env bash

git-apt(){
	sudo add-apt-repository --yes --no-update ppa:git-core/ppa
	sudo apt-get update
	sudo apt-get install --no-install-recommends --no-install-suggests --reinstall --assume-yes git build-essential
	sudo apt-get install --no-install-recommends --no-install-suggests --reinstall --assume-yes libsecret-1-0 libsecret-1-dev
	sudo rm -fv /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
	sudo make -C /usr/share/doc/git/contrib/credential/libsecret
	sudo strip --strip-unneeded /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
}

git-dnf(){
	sudo dnf install --setopt=install_weak_deps=false --assumeyes git git-credential-libsecret
}

git-pac(){
	sudo pacman -Syyu --noconfirm --needed git
}

git-ssh(){
	ssh-keygen -t rsa -b 4096 -f "${HOME}"/.ssh/ssh-rsa4096-github-tur1ngb0x -C 'ssh-rsa4096-github-tur1ngb0x'
	eval "$(ssh-agent -s)" &> /dev/null
	ssh-add "${HOME}"/.ssh/ssh-rsa4096-github-tur1ngb0x
	cat "${HOME}"/.ssh/ssh-rsa4096-github-tur1ngb0x.pub
}

# begin script from here
if [[ $(command -pv apt) ]]; then
	git-apt
elif [[ $(command -pv dnf) ]]; then
	git-dnf
elif [[ $(command -pv pacman) ]]; then
	git-pacman
else
	echo 'only apt, dnf, pacman are supported'
fi
