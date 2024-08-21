# init
[[ -z "${PS1}" ]] && return
source /usr/share/bash-completion/bash_completion

# behaviour
shopt -s checkwinsize
shopt -s histappend

# bash prompt
if [[ $(id -ur) -eq 0 ]]; then
	PS1='\[\e[91;1;7m\] \u@\h \w \[\e[0m\]\n λ '
else
	PS1='\[\e[92;1;7m\] \u@\h \w \[\e[0m\]\n λ '
fi
PS1="\[\e]0;\u@\h \w\a\]${PS1}"; export PS1
