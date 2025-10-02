# INTERACTIVE
if [[ "${-}" != *i* ]]; then
    return
fi

# OPTIONS
shopt -s checkwinsize       # update lines and columns after window resize (fixes wrapping issues)
shopt -s cmdhist            # save multi-line commands as a single history entry
shopt -s histappend         # append new history lines instead of overwriting ~/.bash_history
shopt -s histverify         # verify and edit history expansion (!cmd) before execution
shopt -s progcomp           # enable programmable completion (needed for bash-completion)
shopt -s complete_fullquote # keep completions properly quoted to safely handle spaces/special chars
shopt -s promptvars         # expand variables inside dynamic ps1 prompts
shopt -s globasciiranges    # make [a-z] reliably use ascii ordering (avoids locale surprises).

# READLINE
bind '"\e[A": history-search-backward'     # up arrow to search backward in history
bind '"\e[B": history-search-forward'      # down arrow to search forward in history
bind 'set bell-style visible'              # flash instead of beep when completion fails
bind 'set colored-completion-prefix on'    # colourise typed prefix in completion list
bind 'set colored-stats on'                # colourise completion entries (like ls --color)
bind 'set enable-bracketed-paste on'       # safe paste: prevents accidental execution
bind 'set mark-symlinked-directories on'   # add '/' when completing symlinked directories
bind 'set match-hidden-files on'           # include hidden files in completions
bind 'set menu-complete-display-prefix on' # show only completions with typed prefix
bind 'set show-all-if-ambiguous on'        # show matches on first tab press
bind 'set show-all-if-unmodified on'       # always show completions without extra typing
bind 'set visible-stats on'                # add symbols (/ * @) to indicate file types

# COMPLETION
source /usr/share/bash-completion/bash_completion

# PATH
PATH="${HOME}/.local/bin:${PATH}"        # add user bin directory
PATH="${HOME}/scripts/linux:${PATH}"     # add personal Linux scripts
PATH="${HOME}/src/scripts/linux:${PATH}" # add personal Linux scripts

# ALIASES
unalias -a                                       # remove all aliases
alias curl="command curl -4"                     # force ipv4
alias diff='command diff --color=auto'           # enable color
alias dt="builtin cd ~/src/dotfiles/linux/user/" # cd into dotfiles repo
alias grep='command grep --color=auto'           # enable color
alias sc="builtin cd ~/src/scripts/linux/"       # cd into scripts repo
alias wget='command wget --hsts-file ~/.cache/wget-hsts -4'

# FUNCTIONS
function show () { (set -x; "${@:?}"); }

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
    | command awk 'NR==1 && /^total /{next}{for(i=1;i<=NF;i++) if(i!=2 && i!=5) printf "%s%s",$i,(i==NF?"\n":" ")}'
}

function treee() {
    command tree -C -F --dirsfirst --sort name -I ".git" "${@}"
}

function ddc() {
    if [ "$(command date +%H%M)" -ge 600 ] && [ "$(command date +%H%M)" -le 1800 ]; then
        command ddcutil setvcp 10 100
    else
        command ddcutil setvcp 10 0
    fi
}

function nerdfont() {
    [[ $# -eq 0 ]] && echo 'https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/' && return
    show command mkdir -p -v "${HOME}/.local/share/fonts"
    show command curl -4L -o "/tmp/${1}.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${1}.tar.xz"
    show command tar -v -f "/tmp/${1}.tar.xz" -x --xz -C "${HOME}/.local/share/fonts" --wildcards '*NerdFontMono*'
    show command fc-cache -r
}

# PROMPT
PROMPT_COMMAND='builtin history -a'; export PROMPT_COMMAND
if [[ "${UID}" -ne 0 ]]; then
    PS1='\[\e[92;1m\]\u@\h\[\e[0m\] \[\e[96;1m\]\w\n\[\e[0m\]\$ '; export PS1
else
    PS1='\[\e[91;1m\]\u@\h\[\e[0m\] \[\e[93;1m\]\w\n\[\e[0m\]\$ '; export PS1
fi
