# INTERACTIVE
if [[ "${-}" != *i* ]]; then
    return
fi

# OPTIONS
shopt -s checkwinsize       # Update LINES and COLUMNS after window resize (fixes wrapping issues)
shopt -s cmdhist            # Save multi-line commands as a single history entry
shopt -s histappend         # Append new history lines instead of overwriting ~/.bash_history
shopt -s histverify         # Verify and edit history expansion (!cmd) before execution
shopt -s progcomp           # Enable programmable completion (needed for bash-completion)
shopt -s complete_fullquote # Keep completions properly quoted to safely handle spaces/special chars
shopt -s promptvars         # Expand variables inside dynamic PS1 prompts
shopt -s globasciiranges    # make [a-z] reliably use ASCII ordering (avoids locale surprises).

# READLINE
bind '"\e[A": history-search-backward'     # up arrow to search backward in history
bind '"\e[B": history-search-forward'      # down arrow to search forward in history
bind 'set bell-style visible'              # Flash instead of beep when completion fails
bind 'set colored-completion-prefix on'    # Colourise typed prefix in completion list
bind 'set colored-stats on'                # Colourise completion entries (like ls --color)
bind 'set enable-bracketed-paste on'       # Safe paste: prevents accidental execution
bind 'set mark-symlinked-directories on'   # Add '/' when completing symlinked directories
bind 'set match-hidden-files on'           # Include hidden files in completions
bind 'set menu-complete-display-prefix on' # Show only completions with typed prefix
bind 'set show-all-if-ambiguous on'        # Show matches on first Tab press
bind 'set show-all-if-unmodified on'       # Always show completions without extra typing
bind 'set visible-stats on'                # Add symbols (/ * @) to indicate file types

# COMPLETION
source /usr/share/bash-completion/bash_completion

# PATH
PATH="$HOME/.local/bin:$PATH"        # Add user bin directory
PATH="$HOME/scripts/linux:$PATH"     # Add personal Linux scripts
PATH="$HOME/src/scripts/linux:$PATH" # Add personal Linux scripts

# PROMPT
PROMPT_COMMAND='builtin history -a'; export PROMPT_COMMAND
PS1="\[\e[1;92m\]\u@\h \[\e[1;96m\]\w \[\e[1;93m\]\n\[\e[0m\]\$ "; PS1="\[\e]0;\u@\h \w\a\]${PS1}"; export PS1

# ALIASES
unalias -a                                       # remove all aliases
#alias ls='command ls --color=auto'              # enable color
alias grep='command grep --color=auto'           # enable color
alias diff='command diff --color=auto'           # enable color
alias dt="builtin cd ~/src/dotfiles/linux/user/" # cd into dotfiles repo
alias sc="builtin cd ~/src/scripts/linux/"       # cd into scripts repo

# FUNCTIONS
function ls() { command ls \
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
