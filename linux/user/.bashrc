# Behaviour
[[ "${-}" != *i* ]] && return
[[ -z "${BASH_COMPLETION_VERSINFO}" ]] && source /usr/share/bash-completion/bash_completion
shopt -s checkwinsize direxpand histappend histverify

# PATH
PATH="${PATH}:/var/lib/flatpak/exports/bin"
PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/.local/share/flatpak/exports/share"
PATH="${PATH}:${HOME}/src/adb"
PATH="${PATH}:${HOME}/src/cargo/bin"
PATH="${PATH}:${HOME}/src/go/bin"
PATH="${PATH}:${HOME}/src/scripts/linux"
PATH="$(printf '%s' "${PATH}" | awk -v RS=: -v ORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }')"
export PATH

# Variables
CLICOLOR='1'
EDITOR='micro'
HISTCONTROL='ignorespace:ignoredups:erasedups'
HISTFILESIZE='10000'
HISTSIZE='2000'
HISTTIMEFORMAT='%Y-%m-%d %a %H:%M:%S    '
MANPAGER='most -s -t4 -w'
PAGER="$MANPAGER"
PROMPT_COMMAND='history -a'
PS1="$(tput bold)$(tput setaf 3)\u@\h $(tput setaf 6)\w $(tput setaf 2)\$$(tput sgr0) "
PS1="\[\e]0;\u@\h \w\a\]${PS1}"
STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
VISUAL='micro'

export CLICOLOR EDITOR HISTCONTROL HISTFILESIZE HISTSIZE HISTTIMEFORMAT MANPAGER PAGER PROMPT_COMMAND PS1 STARSHIP_CONFIG VISUAL

# Functions
# function outcurl { curl --ipv4 --form "clbin=<-" https://clbin.com; }
function datenow { date +"%Y-%m-%d %a %H:%M:%S %Z %z"; }
function outclip { xclip -selection clipboard; }
function outcode { code -; }
function outpaste { "${HOME}"/src/pastelo/pastelo; }
function path { echo "${PATH}" | tr ':' '\n'; }
function pyv { source "${PWD}/bin/activate"; }
function refreshell { clear; reset; source "${HOME}/.bashrc"; }


# Aliases
# alias ls='ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y%m%d-%a-%H%M%S" --color=always'
alias chmod='chmod --verbose'
alias chown='chown --verbose'
alias cp='cp --verbose'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ln='ln --verbose'
alias ls="ls.sh"
alias mkdir='mkdir --verbose'
alias mv='mv --verbose'
alias rmdir='rmdir --verbose'
alias pastelo="\${HOME}/src/pastelo/pastelo"

# ADB Shell
# alias ls='ls -A -a -F -g -h -l -o -p -s --color=always'
# export PS1="${USER}@${HOSTNAME} ${PWD} $ "

# Helpers
# function set_variable { eval "${1}=\"${*:2}\"; export ${1}"; }
# function set_alias    { alias "${1}"="command ${*:2}"; }
# function set_function { eval "function ${1} { \"${*:2}\" ; }; export -f ${1}"; }
# function set_path     { PATH="${PATH}:${1}"; PATH="$(printf '%s' "${PATH}" | awk -v RS=: -v ORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }')"; export PATH; }
