
#######################################################################
# INIT
#######################################################################

# shellcheck disable=SC2148
# shellcheck disable=SC1091

if [[ -z "${PS1}" ]]; then return; fi

shopt -s checkwinsize
shopt -s direxpand
shopt -s histverify

#######################################################################
# FEATURES (Y to enable, anything else to disable)
#######################################################################

_SET_ALIASES_="Y"
_SET_BASHCOMP_="Y"
_SET_FETCH_="N"
_SET_FUNCTIONS_="Y"
_SET_PATH_="Y"
_SET_PROMPT_="N"
_SET_STARSHIP_="N"
_SET_VARIABLES_="Y"

#######################################################################
# COMPLETION
#######################################################################

if [[ ${_SET_BASHCOMP_} == 'Y' ]]; then
	if [[ -r /usr/share/bash-completion/bash_completion ]]; then
		source /usr/share/bash-completion/bash_completion
	else
		echo 'bash-completion package is not installed'
	fi
fi

#######################################################################
# PATH
#######################################################################

if [[ ${_SET_PATH_} == 'Y' ]]; then
	PATH="${PATH}:${HOME}/.local/bin"
	PATH="${PATH}:${HOME}/.anaconda/bin"
	PATH="${PATH}:${HOME}/.cargo/bin"
	PATH="${PATH}:${HOME}/.go/bin"
	PATH="${PATH}:${HOME}/.local/share/JetBrains/Toolbox/scripts"
	PATH="${PATH}:${HOME}/src/scripts/linux"
	PATH="${PATH}:${HOME}/src/binaries"
	PATH="$(printf %s "${PATH}" | awk -vRS=: -vORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }' )"
	export PATH
fi

#######################################################################
# VARIABLES
#######################################################################

if [[ ${_SET_VARIABLES_} == 'Y' ]]; then
	export EDITOR="micro"
	export HISTCONTROL="ignoreboth:erasedups"
	export HISTFILESIZE="10000"
	export HISTSIZE="2000"
	export HISTTIMEFORMAT="%Y-%m-%d %a %H:%M:%S    "
	export MANPAGER="most -s -t4 -w"
	export PAGER="most -s -t4 -w"
	export VISUAL="micro"
fi

#######################################################################
# FUNCTIONS
#######################################################################

if [[ ${_SET_FUNCTIONS_} == 'Y' ]]; then
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

if [[ ${_SET_ALIASES_} == 'Y' ]]; then
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

if [[ ${_SET_PROMPT_} == 'Y' ]]; then
	function info_git() { git branch --show-current 2>/dev/null; }
	function info_os() { source /etc/os-release; echo "${ID}-${VERSION_ID}"; }
	function info_datetime() { date +"%Y%m%d-%a-%H%M%S"; }
	function info_ssh() { [[ -n "${SSH_TTY}" ]]  && echo "ssh@"; }
	col_black="$(tput setaf 8)"
	col_red="$(tput setaf 9)"
	col_green="$(tput setaf 10)"
	col_yellow="$(tput setaf 11)"
	col_blue="$(tput setaf 12)"
	col_magenta="$(tput setaf 13)"
	col_cyan="$(tput setaf 14)"
	col_white="$(tput setaf 15)"
	col_reset="$(tput sgr0)"
	PS1='${col_black}$(info_datetime) $(info_ssh)$(info_os)${col_reset}\n${col_cyan}\u@\h${col_reset} ${col_green}\w${col_reset} ${col_red}$(info_git)${col_reset}\n${col_black}\$${col_reset} '
	PS1="\[\e]0;\u@\h \w\a\]${PS1}"
	export PS1
fi

#######################################################################
# MISC
#######################################################################

if [[ "${_SET_FETCH_}" == 'Y' ]]; then
	if [[ $(command -v distrofetch.sh) ]]; then
		distrofetch.sh
	fi
fi

if [[ "${_SET_STARSHIP_}" == 'Y' ]]; then
	if [[ $(command -v starship) ]]; then
		function set_win_title(){ echo -ne "\033]0; $(whoami)@$(hostname) $(basename "$PWD") \007"; }
		eval "$(starship init bash)"
		starship_precmd_user_func="set_win_title"
	fi
fi
