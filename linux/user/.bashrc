# startup
if [[ "${-}" != *i* ]]; then
    return # if shell is not interactive, exit immediately
fi

# shell options
set -o noclobber # prevent > from overwriting files, use >| to force
stty -ixon # disable software flow control
shopt -s autocd # cd by typing directory name
shopt -s checkwinsize # update lines and columns after each command
shopt -s cmdhist # save multi line cmds as single entry in bash history
shopt -s histappend # append history instead of overwriting
shopt -s histverify # edit history line before execution
shopt -s progcomp # enable advanced completions
shopt -s complete_fullquote # enables quoting during completion
shopt -s promptvars # expand shell variables
shopt -s globasciiranges # use ascii ordering instead of locale

# bindings
bind '"\e[A": history-search-backward' # up arrow search backward in history
bind '"\e[B": history-search-forward' # down arrow search forward in history
bind '"\e[Z": menu-complete-backward' # shift+tab cycles backwards through completions
bind 'set bell-style visible' # show visual flash instead of audible bell
bind 'set colored-completion-prefix on' # highlights completion prefix in color
bind 'set colored-stats on' # display metadata indicators during completion
bind 'set enable-bracketed-paste on' # prevent pasted text from trigerring keybindings
bind 'set expand-tilde on' # expand ~ to current /home/user/
bind 'set mark-directories on' # append / to directories
bind 'set mark-modified-lines on' # mark lines in history which were modified before execution
bind 'set mark-symlinked-directories on' # append slash to symlinks during completion
bind 'set match-hidden-files on' # include hidden files during completion
bind 'set menu-complete-display-prefix on' # show typed prefix during completion
bind 'set show-all-if-ambiguous on' # list all matches automatically
bind 'set show-all-if-unmodified on' # list all possible completions in 1st tab
bind 'set skip-completed-text on' # do not reinsert already completed text
bind 'set visible-stats on' # show file metadata during completion
bind 'TAB:menu-complete' # tab cycles forwards through completion
bind 'set enable-keypad on' # enable app keypad mode

# bash completion
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    if [[ -z "$BASH_COMPLETION_VERSINFO" ]]; then
        source /usr/share/bash-completion/bash_completion
    fi
else
    printf '%s\n' 'bash-completion is not installed'
fi

# path
PATH="${HOME}/.local/bin:${PATH}"
PATH="${HOME}/scripts/linux:${PATH}"
PATH="${HOME}/src/scripts/linux:${PATH}"

# functions
function ls() {
    command ls \
        --almost-all \
        --color=always \
        --format=verbose \
        --group-directories-first \
        --human-readable \
        --indicator-style=file-type \
        --quoting-style=shell \
        --time-style=+"%Y%m%d-%H%M%S" \
        "${@}" \
    | command sed '1d; s/ ->.*$//'
}

# alias
unalias -a
alias catt='command cat --number'
alias curl="command curl --ipv4"
alias diff='command diff --color=auto'
alias dt='builtin cd ~/src/dotfiles/linux/user/'
alias grep='command grep --color=auto'
alias ip='command ip --color=auto'
alias less='command less -R'
alias pj='builtin cd ~/src/projects/'
alias sc='builtin cd ~/src/scripts/linux/'
alias watch='command watch --color'
alias wget='command wget --inet4-only --hsts-file ~/.cache/wget-hsts'

# prompt
PROMPT_COMMAND='builtin history -a'; export PROMPT_COMMAND

if [[ "${UID}" -ne 0 ]]; then
    PS1='\[\e[92;1m\]\u@\h\[\e[0m\] \[\e[96;1m\]\w \[\e[93;1m\]$(command git rev-parse --abbrev-ref HEAD 2>/dev/null)\n\[\e[0m\]\$ '
else
    PS1='\[\e[91;1m\]\u@\h\[\e[0m\] \[\e[93;1m\]\w\n\[\e[0m\]\$ '
fi; export PS1
