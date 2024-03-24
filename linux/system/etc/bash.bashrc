# init
[[ -z "${PS1}" ]] && return
[[ -f /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion

# behaviour
shopt -s checkwinsize
shopt -s histappend

# bash prompt
[[ $(id --user --real) -eq 0 ]] && PS1='\[\e[91;1;7m\] \u@\h \w \[\e[0m\]\n λ ' && PS1="\[\e]0;\u@\h \w\a\]${PS1}" && export PS1
[[ $(id --user --real) -ne 0 ]] && PS1='\[\e[92;1;7m\] \u@\h \w \[\e[0m\]\n λ ' && PS1="\[\e]0;\u@\h \w\a\]${PS1}" && export PS1
