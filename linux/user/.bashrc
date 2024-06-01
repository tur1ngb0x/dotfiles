
# init
if [[ -z "${PS1}" ]]; then return; fi
if [[ -r /usr/share/bash-completion/bash_completion ]]; then source /usr/share/bash-completion/bash_completion; fi
shopt -s checkwinsize
shopt -s direxpand
shopt -s histverify

# path
PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/.anaconda/bin"
PATH="${PATH}:${HOME}/.cargo/bin"
PATH="${PATH}:${HOME}/.go/bin"
PATH="${PATH}:${HOME}/.local/share/JetBrains/Toolbox/scripts"
PATH="${PATH}:${HOME}/src/scripts/linux"
PATH="$(printf %s "${PATH}" | awk -vRS=: -vORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }' )"
export PATH

# variables
EDITOR="micro"
HISTCONTROL="ignoreboth:erasedups"
HISTFILESIZE="10000"
HISTSIZE="2000"
HISTTIMEFORMAT="%Y-%m-%d %a %H:%M:%S    "
MANPAGER="most -s -t4 -w"
PAGER="most -s -t4 -w"
VISUAL="micro"

# functions
function adbopt { adb shell cmd package bg-dexopt-job; }
function cfg-sys-fstab { sudoedit /etc/fstab; }
function cfg-sys-grub { sudoedit /etc/default/grub; }
function cfg-sys-ssh { sudoedit /etc/ssh/ssh_config ;}
function cfg-sys-sshd { sudoedit /etc/ssh/sshd_config ;}
function cfg-user-bash { "${EDITOR}" "${HOME}"/.bashrc ;}
function cfg-user-profile { "${EDITOR}" "${HOME}"/.profile ;}
function chk-ip { curl ifconfig.me/all; }
function chk-mem { watch --interval 1 'free --mebi --lohi --total --wide'; }
function chk-path { tr ":" "\n" <<< "${PATH}"; }
function chk-ping { ping -4 "${@}"; }
function chk-route { traceroute -4 "${@}"; }
function codesrc { code "${HOME}"/src; }
function datenow { date +"%Y%m%d-%a-%H%M%S"; }
function fix-ffui { bash -c "$(curl -fsSL https://raw.githubusercontent.com/black7375/Firefox-UI-Fix/master/install.sh)"; }
function fix-ssh { sudo bash -c 'systemctl stop --force --now NetworkManager sshd ssh; systemctl restart --force --now NetworkManager sshd ssh'; }
function inxifull { sudo bash -c 'inxi -a -F -r -t -xxx -y1 -z'; }
function out-clip { xclip -selection clipboard; }
function out-code { code -; }
function out-curl { curl --form "clbin=<-" https://clbin.com; }
function poweroff { sudo bash -c 'systemctl poweroff'; }
function reboot { sudo bash -c 'systemctl reboot'; }
function refreshell { clear; reset; source "${HOME}"/.bashrc; }
function wslexp { explorer.exe .; }

# aliases
alias chmod='chmod --verbose'
alias chown='chown --verbose'
alias cp='cp --verbose'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ln='ln --verbose'
alias ls='ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto'
alias mkdir='mkdir --verbose'
alias mv='mv --verbose'
alias rm='rm --verbose'
alias rmdir='rmdir --verbose'

# ps1
PS1="$(tput bold rev) \u@\h \w $(tput sgr0)\n\$ "
PS1="\[\e]0;\u@\h \w\a\]${PS1}"
export PS1

# starship
if [[ $(command -v starship) ]]; then eval "$(starship init bash)"; fi

# fetch
if [[ $(command -v distrofetch.sh) ]]; then distrofetch.sh --short; fi
