# INTERACTIVE
[[ "${-}" != *i* ]] && builtin return





# COMPLETION
builtin source /usr/share/bash-completion/bash_completion 2>/dev/null





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
builtin shopt -s cdspell                           # # auto fix minor typos after using cd command
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
PATH="$(builtin printf '%s' "${PATH}" | command awk -v RS=: -v ORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }')"
builtin export PATH





# VARIABLES
COLORTERM='truecolor';                          builtin export COLORTERM      # enable 24-bit color support
EDITOR="micro";                                 builtin export EDITOR         # editor used by cli programs
GIT_EDITOR='micro';                             builtin export GIT_EDITOR     # editor used by git
GIT_PAGER='most -s -t4 -w';                     builtin export GIT_PAGER      # pager used by git
HISTCONTROL='ignorespace:ignoredups:erasedups'; builtin export HISTCONTROL    # make history cleaner
HISTFILESIZE='10000';                           builtin export HISTFILESIZE   # history max lines saved in disk
HISTSIZE='1000';                                builtin export HISTSIZE       # history max lines saved in memory per session
HISTTIMEFORMAT='%Y%m%d-%H%M%S  ';               builtin export HISTTIMEFORMAT # history line timestamp
LESS='FRSX'                                     builtin export LESS           # less: F=quit if one screen, R=raw color, S=chop lines, X=no init
MANPAGER='most -s -t4 -w';                      builtin export MANPAGER       # pager used by man
PAGER='most -s -t4 -w';                         builtin export PAGER          # pager used by cli programs
TERM="xterm-256color";                          builtin export TERM           # term variable
VISUAL='micro';                                 builtin export VISUAL         # editor used by gui programs





# ALIASES
unalias -a

builtin alias apt='command sudo /usr/bin/apt '
builtin alias bashly='command docker run --rm -it --user $(command id -u):$(command id -g) --volume ~/src/bashly:/app dannyben/bashly'
builtin alias chgrp='command chgrp --verbose'
builtin alias chmod='command chmod --verbose'
builtin alias chown='command chown --verbose'
builtin alias completely='command docker run --rm -it --user $(command id -u):$(command id -g) --volume ~/src/completely:/app dannyben/completely'
builtin alias cp='command cp --verbose'
builtin alias curl='command curl --ipv4'
builtin alias diff='command diff --color=auto'
builtin alias dnf='command sudo /usr/bin/dnf '
builtin alias grep='command grep --color=auto'
builtin alias ip='command ip --color=auto'
builtin alias less='command less -R'
builtin alias ln='command ln --verbose'
builtin alias ls='command ls --color=auto'
builtin alias mkdir='command mkdir --verbose'
builtin alias mv='command mv --verbose'
builtin alias pacman='command sudo /usr/bin/pacman '
builtin alias replasma='command systemctl --user restart plasma-plasmashell.service'
builtin alias rm='command rm --verbose --interactive=once'
builtin alias rmdir='command rmdir --verbose'
builtin alias rmdir='command rmdir --verbose'
builtin alias rsync='command rsync --verbose'
builtin alias watch='command watch --color'
builtin alias wget='command wget --inet4-only'


# PROMPT
#PROMPT_COMMAND='ec=$?; builtin history -a'
#PS1='\[\e]0;\u@\h \w\a\]\[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;36m\]\w\[\e[0m\]$( [[ -n "${VIRTUAL_ENV}" ]] && builtin printf " \[\e[1;35m\](venv:%s)\[\e[0m\]" "$(command basename "${VIRTUAL_ENV}")" )$( command git rev-parse --git-dir &>/dev/null && builtin printf " \[\e[1;33m\](git:%s)\[\e[0m\]" "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" )$( (( ec == 0 )) && builtin printf " \[\e[1;32m\](exit:%s)\[\e[0m\]" "$ec" || builtin printf " \[\e[1;31m\](exit:%s)\[\e[0m\]" "$ec" ) \n\$ '
PROMPT_COMMAND='builtin history -a'
PS1='$(/usr/bin/tput rev 2>/dev/null) \u@\h:\w $(/usr/bin/tput sgr0 2>/dev/null) $(/usr/bin/git rev-parse --abbrev-ref HEAD 2>/dev/null)\n\$ '
PS1="\[\e]0;\u@\h \w\a\]${PS1}"

