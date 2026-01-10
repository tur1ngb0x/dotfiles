# INTERACTIVE
[[ "${-}" != *i* ]] && builtin return

# SHELL
builtin bind '"\e[A": history-search-backward'     # up arrow search backward in history
builtin bind '"\e[B": history-search-forward'      # down arrow search forward in history
builtin bind '"\e[Z": menu-complete-backward'      # shift+tab cycles backwards through completions
builtin bind 'set colored-completion-prefix on'    # highlights completion prefix in color
builtin bind 'set colored-stats on'                # display metadata indicators during completion
builtin bind 'set enable-bracketed-paste on'       # prevent copy pasted text from triggering keybindings
builtin bind 'set expand-tilde on'                 # expand ~/ to /home/<username>
builtin bind 'set mark-directories on'             # append / to directories
builtin bind 'set mark-modified-lines on'          # mark lines in history which were modified before execution
builtin bind 'set mark-symlinked-directories on'   # append slash to symlinks during completion
builtin bind 'set match-hidden-files on'           # include hidden files during completion
builtin bind 'set menu-complete-display-prefix on' # show typed prefix during completion
builtin bind 'set show-all-if-ambiguous on'        # list all matches automatically
builtin bind 'set show-all-if-unmodified on'       # list all possible completions in 1st tab
builtin bind 'set skip-completed-text on'          # do not reinsert already completed text
builtin bind 'set visible-stats on'                # show file metadata during completion
builtin bind 'TAB:menu-complete'                   # tab cycles forwards through completion
builtin set -o noclobber                           # prevent > from overwriting files, use >| to force
builtin shopt -s autocd                            # cd by typing directory name
builtin shopt -s cdspell                           # auto fix minor typos after using cd command
builtin shopt -s checkwinsize                      # update lines and columns after each command
builtin shopt -s cmdhist                           # save multi line cmds as single entry in bash history
builtin shopt -s complete_fullquote                # enables quoting during completion
builtin shopt -s direxpand                         # expand variables for directories
builtin shopt -s dirspell                          # auto fix minor directory name typos during completion
builtin shopt -s globasciiranges                   # use ascii ordering instead of locale
builtin shopt -s histappend                        # append history instead of overwriting
builtin shopt -s histverify                        # edit history line before execution
builtin shopt -s interactive_comments              # enables comment support in interactive shells
builtin shopt -s progcomp                          # enable advanced completions
builtin shopt -s promptvars                        # expand shell variables
builtin command stty -ixon                         # disable software flow control

# PATH
PATH="${HOME}/src/scripts/linux:${PATH}"                 # user scripts
PATH="${HOME}/.cargo/bin:${PATH}"                        # rust binaries
PATH="${HOME}/.local/bin:${PATH}"                        # user binaries
PATH="${HOME}/.local/share/flatpak/exports/bin:${PATH}"  # flatpak binaries
PATH="$(builtin printf '%s' "${PATH}" | builtin command awk -v RS=: -v ORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }')"
builtin export PATH

# VARIABLES
#COLORTERM='truecolor';                          builtin export COLORTERM                  # enable 24-bit color support
#GIT_EDITOR='micro';                             builtin export GIT_EDITOR                 # editor used by git
#GIT_PAGER='most -s -t4 -w';                     builtin export GIT_PAGER                  # pager used by git
#LESS='FRSX'                                     builtin export LESS                       # less: F=quit if one screen, R=raw color, S=chop lines, X=no init
#MANPAGER='most -s -t4 -w';                      builtin export MANPAGER                   # pager used by man
#PAGER='most -s -t4 -w';                         builtin export PAGER                      # pager used by cli programs
#TERM="xterm-256color";                          builtin export TERM                       # term variable
DOCKER_BUILDKIT="1"                             builtin export DOCKER_BUILDKIT            # enable docker buildkit
VIRTUAL_ENV_DISABLE_PROMPT='1';                 builtin export VIRTUAL_ENV_DISABLE_PROMPT # disable venv name in PS1 prompt
EDITOR="micro";                                 builtin export EDITOR                     # editor used by cli programs
VISUAL='micro';                                 builtin export VISUAL                     # editor used by gui programs
HISTCONTROL='ignorespace:ignoredups:erasedups'; builtin export HISTCONTROL                # make history cleaner
HISTFILESIZE='10000';                           builtin export HISTFILESIZE               # history max lines saved in disk
HISTSIZE='1000';                                builtin export HISTSIZE                   # history max lines saved in memory per session
HISTTIMEFORMAT='%Y%m%d-%H%M%S  ';               builtin export HISTTIMEFORMAT             # history line timestamp
WINEPREFIX="${HOME}/src/wine/default"           builtin export WINEPREFIX                 # default wine prefix location

# ALIASES - RESET
builtin unalias -a
# ALIASES - VERBOSITY
builtin alias chgrp='builtin command chgrp --verbose'
builtin alias chmod='builtin command chmod --verbose'
builtin alias chown='builtin command chown --verbose'
builtin alias cp='builtin command cp --verbose'
builtin alias ln='builtin command ln --verbose'
builtin alias mkdir='builtin command mkdir --verbose'
builtin alias mv='builtin command mv --verbose'
builtin alias rm='builtin command rm --verbose --interactive=once'
builtin alias rmdir='builtin command rmdir --verbose'
builtin alias rmdir='builtin command rmdir --verbose'
builtin alias rsync='builtin command rsync --verbose'
# ALIASES - COLORS
builtin alias diff='builtin command diff --color=auto'
builtin alias grep='builtin command grep --color=auto'
builtin alias ip='builtin command ip --color=auto'
builtin alias ls='builtin command ls --color=auto'
builtin alias pikaur='/usr/bin/pikaur --color=auto'
builtin alias yay='/usr/bin/yay --color=auto'
builtin alias paru='/usr/bin/paru --color=auto'
builtin alias watch='builtin command watch --color'
# ALIASES - FUNCTIONALITY
builtin alias apt-get='/usr/bin/sudo /usr/bin/apt-get'
builtin alias apt='/usr/bin/sudo /usr/bin/apt'
builtin alias bashly='builtin command docker run --rm -it --user $(builtin command id -u):$(builtin command id -g) --volume ~/src/bashly:/app dannyben/bashly'
builtin alias colourify='builtin command grc --stderr --stdout'
builtin alias completely='builtin command docker run --rm -it --user $(builtin command id -u):$(builtin command id -g) --volume ~/src/completely:/app dannyben/completely'
builtin alias curl='builtin command curl --ipv4'
builtin alias dnf='/usr/bin/sudo /usr/bin/dnf'
builtin alias less='builtin command less -R'
builtin alias ls='builtin command eza --color=auto --color-scale=all --color-scale-mode=gradient --classify=auto --group-directories-first'
builtin alias pacman='/usr/bin/sudo /usr/bin/pacman'
builtin alias replasma='/usr/bin/sudo /usr/bin/systemctl --user restart plasma-plasmashell.service'
builtin alias wget='builtin command wget --inet4-only'

# PROMPT
PROMPT_COMMAND='EXIT=$?; builtin history -a'
_ps1_sep()      { builtin printf -- '-%.0s' $(builtin command seq 1 "${COLUMNS:-80}"); }
_ps1_exit()     { (( EXIT != 0 )) && builtin printf "\e[30;41m exit:%s \e[0m" "${EXIT}"; }
_ps1_userhost() { builtin printf "\e[30;42m %s@%s \e[0m" "${USER}" "${HOSTNAME}"; }
_ps1_dir()      { builtin printf "\e[30;46m %s \e[0m" "${PWD}"; }
_ps1_venv()     { [[ -n "${VIRTUAL_ENV}" ]] && builtin printf "\e[30;45m venv:%s \e[0m" "$(builtin command basename "${VIRTUAL_ENV}")"; }
_ps1_git()      { builtin command git rev-parse --git-dir &>/dev/null && builtin printf "\e[30;43m git:%s \e[0m" "$(builtin command git rev-parse --abbrev-ref HEAD 2>/dev/null)"; }
PS1='$(_ps1_userhost)$(_ps1_dir)$(_ps1_venv)$(_ps1_git)\n\$ '
PS1="\[\e]0;\u@\h:\w\a\]${PS1}"

# SOURCE
builtin source /usr/share/bash-completion/bash_completion 2>/dev/null
builtin source /usr/share/doc/pkgfile/command-not-found.bash 2>/dev/null


function bash-cmd () {
    [[ $# -eq 0 ]] && builtin printf "usage: bash-cmd '<command>'\n" && builtin return

    builtin local file
    file=$(builtin command mktemp --suffix=.md) || return

    (
        builtin printf '\033[7m# Input:\033[0m\n'
        builtin printf '```\n'
        builtin printf '$ %s\n' "$*"
        builtin printf '```\n'
        builtin printf '\033[7m# Output:\033[0m\n'
        builtin printf '```\n'
        builtin eval "${@:?}"
        builtin printf '```\n'
    ) \
    | builtin command tee >(\
        builtin command sed -r 's/\x1B(\[[0-9;]*[A-Za-z]|\][^\a]*\a)//g' \
        | builtin command tee "${file}" \
        | builtin command xclip -selection clipboard)

    builtin command code "${file}" >/dev/null 2>&1
}

function cheat () {
    builtin command curl "https://cheat.sh/${1}"
}
