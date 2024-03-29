#!/usr/bin/env bash

#######################################################################
# START
########################################################################

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

chkpath() { tr ":" "\n" <<< "${PATH}"; }
codesrc() { code "${HOME}"/src; }
now() { date +"%Y%m%d-%H%M%S"; }
out-clip() { xclip -selection clipboard; }
out-code() { code -; }
out-curl() { curl --form "clbin=<-" https://clbin.com; }

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
alias sudo='sudo '
alias wget='wget --inet4-only --hsts-file /tmp/wget-hsts --verbose'

#######################################################################
# PROMPT
#######################################################################

PS1='\[\e[94;1;7m\] \u@\h \w \[\e[0m\]\n $ '
PS1="\[\e]0;\u@\h \w\a\]${PS1}"
export PS1

#######################################################################
# END
#######################################################################
cat <<-EOF
-----------------------------------------------------------------------
👋 Hello ${USER} !
📅 $(date +'%Y %B %-d %A %H:%M:%S %Z ')
🤖 $(uname -r)
-----------------------------------------------------------------------
EOF
