# init
[[ -z "${PS1}" ]] && return
[[ -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion

# behaviour
shopt -s checkwinsize
shopt -s histappend

# shell prompt
PS1='\u@\h:\w\n\$ '; PS1="\[\e]0;\u@\h \w\a\]${PS1}"
