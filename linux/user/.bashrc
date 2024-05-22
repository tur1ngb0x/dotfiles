
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

function adbopt { adb shell cmd package bg-dexopt-job; }
function chkpath { tr ":" "\n" <<< "${PATH}"; }
function chkmem { watch --interval 1 'free --mebi --lohi --total --wide'; }
function codesrc { code "${HOME}"/src; }
function datenow { date +"%Y%m%d-%a-%H%M%S"; }
function outclip { xclip -selection clipboard; }
function outcode { code -; }
function outcurl { curl --form "clbin=<-" https://clbin.com; }
function poweroff { systemctl poweroff; }
function reboot { systemctl reboot; }
function wslexp { explorer.exe .; }
function inxifull { sudo inxi -a -F -r -t -xxx -y1 -z; }

#######################################################################
# ALIASES
#######################################################################

alias chmod='chmod --verbose'
alias chown='chown --verbose'
alias cp='cp --verbose'
alias curl='curl --ipv4 --verbose'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ln='ln --verbose'
alias ls='ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto'
alias mkdir='mkdir --verbose'
alias mv='mv --verbose'
alias rm='rm --verbose'
alias rmdir='rmdir --verbose'
alias wget='wget --inet4-only --hsts-file /tmp/wget-hsts --verbose'

#######################################################################
# PROMPT
#######################################################################
_distro_="($(awk -F'=' '/^NAME=/ {gsub(/"/, "", $2); print $2}' /etc/os-release))"
_username_="\u"
_hostname_="\h"
_directory_="\w"
_git_="($(git --no-pager branch --show-current 2>/dev/null))"
_newline_="\n"
_at_="@"
_symbol_="$"
#PS1="${_distro_} ${_username_}${_at_}${_hostname_} ${_directory_} ${_git_}${_newline_}${_symbol_} "
PS1="\[\e[94;1;7m\] $(awk -F'=' '/^NAME=/ {gsub(/"/, "", $2); print $2}' /etc/os-release) \[\e[93;1;7m\] \u@\h \[\e[92;1;7m\] \w \[\e[0m\] $(git --no-pager  branch --color=never --show-current)\n $ "
#PS1="${distro} \u@\h \w\n $ "
#PS1="\[\e]0;\u@\h \w\a\]${PS1}"
export PS1

#######################################################################
# MISC
#######################################################################
#if [[ $(command -v fastfetch) ]]; then fastfetch; elif [[ $(command -v distrofetch.sh) ]]; then distrofetch.sh; fi
