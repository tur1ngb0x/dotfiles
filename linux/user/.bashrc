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
# bind 'set bell-style visible' # show visual flash instead of audible bell
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

# ble.sh
if [[ -f /usr/share/blesh/ble.sh ]]; then
    source /usr/share/blesh/ble.sh
fi

# path
PATH="${HOME}/.local/bin:${PATH}"
PATH="${HOME}/src/scripts/linux:${PATH}"
PATH="${HOME}/src/adb:${PATH}"
PATH="${HOME}/.local/share/flatpak/exports/bin:${PATH}"

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

function editor() {
    local -a CODE
    if command -v code &>/dev/null; then
        CODE=(code)
    elif command -v codium &>/dev/null; then
        CODE=(codium)
    elif flatpak info com.visualstudio.code &>/dev/null; then
        CODE=(flatpak run com.visualstudio.code)
    elif flatpak info com.vscodium.codium &>/dev/null; then
        CODE=(flatpak run com.vscodium.codium)
    else
        echo "Install VSC/VSCodium"
        return
    fi
    echo "Editor: ${CODE[@]}"; "${CODE[@]}" "${@}"
}

# alias stock
unalias -a
alias curl="command -p curl --ipv4"
alias diff='command -p diff --color=auto'
alias grep='command grep --color=auto'
alias ip='command -p ip --color=auto'
alias less='command -p less -R'
alias watch='command -p watch --color'
alias wget='command -p wget --inet4-only'
# alias custom
alias pj='builtin cd ~/src/projects/'
alias sc='builtin cd ~/src/scripts/linux/'
alias catt='command cat --number'
alias dt='builtin cd ~/src/dotfiles/linux/user/'

# prompt
PROMPT_COMMAND='builtin history -a'
PS1='\[\e[92;1m\]\u@\h\[\e[0m\] \[\e[96;1m\]\w \[\e[93;1m\]$(command git rev-parse --abbrev-ref HEAD 2>/dev/null)\n\[\e[0m\]\$ '

# starship
if command -v starship &>/dev/null; then
    function set_win_title(){
        echo -ne "\033]0;${USER}@${HOSTNAME} - ${PWD}\007"
    }; starship_precmd_user_func="set_win_title"; export starship_precmd_user_func
    eval "$(starship init bash)"
fi

# nerdfont
nerdfont(){
    local url="https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/"
    local dir="${HOME}/.local/share/fonts/${1}"
    # if ! command -p curl --silent --head "${url}" >/dev/null; then
    #     command -p echo "GitHub not reachable. Exiting..."
    #     return 1
    # fi

    if [[ $# -ne 1 ]]; then
        command -p echo "Available Fonts: ${url}"
        command -p echo "Syntax: nerdfont <fontname>"
        builtin return
    else
        builtin set -euxo pipefail
        command -p mkdir --parents "${dir}"
        command -p wget --quiet --show-progress --output-document=- "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${1}.tar.xz" | command -p tar --extract -J --wildcards --no-anchored --overwrite --directory="${dir}" '*NerdFontMono-*'
        command -p fc-cache --really-force
        command -p find "${dir}" -type f | sort
        builtin set +euxo pipefail
    fi
}

# fzf
if command -v fzf &>/dev/null; then
    eval "$(fzf --bash)"
fi