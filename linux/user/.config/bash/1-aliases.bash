printf "%s\n" "# loading aliases..."

unalias -a

alias chmod='command chmod --verbose'
alias chown='command chown --verbose'
alias cp='command cp --verbose'
alias curl='command curl --ipv4'
alias diff='command diff --color=auto'
alias git='command git --no-pager'
alias grep='command grep --color=auto'
alias ln='command ln --verbose'
alias ls='command ls --color=auto'
alias mkdir='command mkdir --verbose'
alias mv='command mv --verbose'
alias rm='command rm --verbose --interactive=once'
alias rmdir='command rmdir --verbose'
alias wget='command wget --inet4-only'

alias dt="builtin cd ${HOME}/src/dotfiles/linux/user"
alias sc="builtin cd ${HOME}/src/scripts/linux"
