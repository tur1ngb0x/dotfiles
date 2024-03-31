
#######################################################################
# START
#######################################################################

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

chkpath() { command -p tr ":" "\n" <<< "${PATH}"; }
codesrc() { command -p code "${HOME}"/src; }
now() { command -p date +"%Y%m%d-%a-%H%M%S"; }
out-clip() { command -p xclip -selection clipboard; }
out-code() { command -p code -; }
out-curl() { command -p curl --form "clbin=<-" https://clbin.com; }

#######################################################################
# ALIASES
#######################################################################

alias chmod='command -p chmod --verbose'
alias chown='command -p chown --verbose'
alias cp='command -p cp --verbose'
alias curl='command -p curl --ipv4 --verbose'
alias diff='command -p diff --color=auto'
alias grep='command -p grep --color=auto'
alias ln='command -p ln --verbose'
alias ls='command -p ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto'
alias mkdir='command -p mkdir --verbose'
alias mv='command -p mv --verbose'
alias rm='command -p rm --verbose'
alias rmdir='command -p rmdir --verbose'
alias wget='command -p wget --inet4-only --hsts-file /tmp/wget-hsts --verbose'

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
