
# defaults
alias chmod='chmod --verbose'
alias chown='chown --verbose'
alias cp='cp --verbose'
alias curl='curl --ipv4 --verbose'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ln='ln --verbose'
alias ls='ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto'
alias mkdir='mkdir --verbose'
alias mv='mv --verbose'
alias rm='rm --verbose'
alias rmdir='rmdir --verbose'
alias sudo='sudo '
alias wget='wget --inet4-only --hsts-file /tmp/wget-hsts --verbose'

# custom
alias chkpath='tr ":" "\n" <<< "${PATH}"'
alias now='date +"%Y%m%d-%H%M%S"'
alias out-clip='xclip -selection clipboard'
alias out-code='code -'
alias out-curl='curl --form "clbin=<-" https://clbin.com'
