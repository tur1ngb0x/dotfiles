# init
[[ -z "${PS1}" ]] && return
source /usr/share/bash-completion/bash_completion

# behaviour
shopt -s checkwinsize
shopt -s histappend

# shell prompt
PS1='\n$(tput rev) \u@\h \w $(tput sgr0)\n\$ '; PS1="\[\e]0;\u@\h \w\a\]${PS1}"
