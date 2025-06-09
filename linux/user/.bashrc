# CHECK
if [[ "${-}" != *i* ]]; then
    return
fi

# BEHAVIOUR
shopt -s checkwinsize
shopt -s cmdhist
shopt -s histappend
shopt -s histverify

# PROMPT
PROMPT_COMMAND='history -a'; export PROMPT_COMMAND
PS1="\[\e[1;92m\]\u@\h \[\e[1;96m\]\w \[\e[1;93m\]\n\[\e[0m\]\$ "; PS1="\[\e]0;\u@\h \w\a\]${PS1}"; export PS1

# SOURCE
source "${HOME}"/src/github/dotfiles/linux/user/.config/bash/1-aliases.bash
source "${HOME}"/src/github/dotfiles/linux/user/.config/bash/2-functions.bash
source "${HOME}"/src/github/dotfiles/linux/user/.config/bash/3-conditions.bash
