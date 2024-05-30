
#######################################################################
# INIT
#######################################################################

# shellcheck disable=SC2148
# shellcheck disable=SC1091

if [[ -z "${PS1}" ]]; then return; fi
if [[ -r /usr/share/bash-completion/bash_completion ]]; then source /usr/share/bash-completion/bash_completion; fi

shopt -s checkwinsize
shopt -s direxpand
shopt -s histverify

SET_SCRIPT_FETCH="Y"
SET_PROMPT_CUSTOM="N"
SET_PROMPT_STARSHIP="N"
SET_CUSTOM_FUNCTIONS="N"
SET_CUSTOM_ALIASES="N"

#######################################################################
# PATH
#######################################################################

PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/.anaconda/bin"
PATH="${PATH}:${HOME}/.cargo/bin"
PATH="${PATH}:${HOME}/.go/bin"
PATH="${PATH}:${HOME}/.local/share/JetBrains/Toolbox/scripts"
PATH="${PATH}:${HOME}/src/scripts/linux"
PATH="${PATH}:${HOME}/src/binaries"
PATH="$(printf %s "${PATH}" | awk -vRS=: -vORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }' )"
export PATH

#######################################################################
# VARIABLES
#######################################################################

export EDITOR="micro"
export HISTCONTROL="ignoreboth:erasedups"
export HISTFILESIZE="10000"
export HISTSIZE="2000"
export HISTTIMEFORMAT="%Y-%m-%d %a %H:%M:%S    "
export MANPAGER="most -s -t4 -w"
export PAGER="most -s -t4 -w"
export VISUAL="micro"

#######################################################################
# FUNCTIONS
#######################################################################

if [[ ${SET_CUSTOM_FUNCTIONS} == 'Y' ]]; then
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
fi

#######################################################################
# ALIASES
#######################################################################

if [[ ${SET_CUSTOM_ALIASES} == 'Y' ]]; then
	alias chmod='chmod --verbose'
	alias chown='chown --verbose'
	alias cp='cp --verbose'
	alias curl='curl --ipv4'
	alias diff='diff --color=auto'
	alias grep='grep --color=auto'
	alias ln='ln --verbose'
	alias ls='ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto'
	alias mkdir='mkdir --verbose'
	alias mv='mv --verbose'
	alias rm='rm --verbose'
	alias rmdir='rmdir --verbose'
	alias wget='wget --inet4-only'
fi

#######################################################################
# PROMPT
#######################################################################

if [[ ${SET_PROMPT_CUSTOM} == 'Y' ]]; then
	function info_os() { source /etc/os-release; echo "${ID}-${VERSION_ID}"; }
	function info_git() { git branch --show-current 2>/dev/null; }
	col_black="$(tput setaf 8)"
	col_red="$(tput setaf 9)"
	col_green="$(tput setaf 10)"
	col_yellow="$(tput setaf 11)"
	col_blue="$(tput setaf 12)"
	col_magenta="$(tput setaf 13)"
	col_cyan="$(tput setaf 14)"
	col_white="$(tput setaf 15)"
	col_reset="$(tput sgr0)"
	PS1='${col_yellow}$(info_os)${col_reset} ${col_cyan}\u@\h${col_reset} ${col_green}\w${col_reset} ${col_red}$(info_git)${col_reset}\n${col_white}\$${col_reset} '
	PS1="\[\e]0;\u@\h \w\a\]${PS1}"
	export PS1
else
	PS1='\u@\h \w\n\$ '
	PS1="\[\e]0;\u@\h \w\a\]${PS1}"
	export PS1
fi

#######################################################################
# MISC
#######################################################################

if [[ "${SET_SCRIPT_FETCH}" == 'Y' ]]; then
	if [[ $(command -v distrofetch.sh) ]]; then
		distrofetch.sh
	fi
fi

if [[ "${SET_PROMPT_STARSHIP}" == 'Y' ]]; then
	if [[ $(command -v starship) ]]; then
		eval "$(starship init bash)"
	fi
fi
