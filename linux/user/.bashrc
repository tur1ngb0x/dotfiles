
# STARTUP
if [[ "${-}" != *i* ]]; then
    return
fi

shopt -s checkwinsize
shopt -s cmdhist
shopt -s histappend
shopt -s histverify

# BASH COMPLETION
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
else
    echo 'bash-completion not found.'
fi

# PATH
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/scripts/linux"
PATH="$PATH:$HOME/src/scripts/linux"

# PROMPT
PROMPT_COMMAND='builtin history -a'; export PROMPT_COMMAND
PS1="\[\e[1;92m\]\u@\h \[\e[1;96m\]\w \[\e[1;93m\]\n\[\e[0m\]\$ "; PS1="\[\e]0;\u@\h \w\a\]${PS1}"; export PS1

# ALIAS
unalias -a
