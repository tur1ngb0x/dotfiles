# shellcheck disable=SC2148,1091

# INIT
if [[ -z "${PS1}" ]]; then return; fi
if [[ -f /usr/share/bash-completion/bash_completion ]]; then source /usr/share/bash-completion/bash_completion; fi
shopt -s checkwinsize direxpand histverify

# PATH
PATH="${PATH}:${HOME}/.local/bin"
#PATH="${PATH}:${HOME}/.anaconda/bin"
#PATH="${PATH}:${HOME}/.cargo/bin"
#PATH="${PATH}:${HOME}/.go/bin"
#PATH="${PATH}:${HOME}/.local/share/JetBrains/Toolbox/scripts"
PATH="${PATH}:${HOME}/src/scripts/linux"
PATH="$(printf %s "${PATH}" | awk -vRS=: -vORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }' )"
export PATH

# VARIABLES
EDITOR="micro"
HISTCONTROL="ignoreboth:erasedups"
HISTFILESIZE="10000"
HISTSIZE="2000"
HISTTIMEFORMAT="%Y-%m-%d %a %H:%M:%S    "
MANPAGER="most -s -t4 -w"
PAGER="most -s -t4 -w"
VISUAL="micro"
export EDITOR HISTCONTROL HISTFILESIZE HISTSIZE HISTTIMEFORMAT MANPAGER PAGER VISUAL

# FUNCTIONS
function adbopt { adb shell cmd package bg-dexopt-job; }
function datenow { date +"%Y-%m-%d %a %H:%M:%S"; }
function fix-ff { bash -c "$(curl -fsSL https://raw.githubusercontent.com/black7375/Firefox-UI-Fix/master/install.sh)"; }
function fix-ssh { sudo bash -c 'systemctl stop --force --now NetworkManager sshd ssh; systemctl restart --force --now NetworkManager sshd ssh'; }
function inxi-full { sudo bash -c 'inxi -a -F -r -t -xxx -y1 -z'; }
function out-clip { xclip -selection clipboard; }
function out-code { code -; }
function out-curl { curl --form "clbin=<-" https://clbin.com; }
function poweroff { sudo bash -c 'systemctl poweroff'; }
function reboot { sudo bash -c 'systemctl reboot'; }
function refreshell { clear; reset; source "${HOME}"/.bashrc; }

# ALIASES
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

# PS1
PS1='\[\e[1;7m\] \u@\h \w \[\e[0m\]\n\$ '
PS1="\[\e]0;\u@\h \w\a\]${PS1}"
export PS1

# STARSHIP
if [[ $(command -v starship) ]] && [[ -f "${HOME}"/.config/starship.toml ]]; then eval "$(starship init bash)"; fi

# FETCH
if [[ $(command -v distrofetch.sh) ]]; then distrofetch.sh --short; fi
