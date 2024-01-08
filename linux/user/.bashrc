# init
[[ -z "${PS1}" ]] && return
source /usr/share/bash-completion/bash_completion

# behaviour
shopt -s autocd
shopt -s cdable_vars
shopt -s checkwinsize
shopt -s direxpand
shopt -s histappend

# path
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${HOME}/.anaconda/bin"
export PATH="${PATH}:${HOME}/.cargo/bin"
export PATH="${PATH}:${HOME}/src/scripts/linux"

# variables
export DOTFILES="${HOME}/src/dotfiles/linux"
export EDITOR="micro"
export HISTCONTROL="ignoreboth:erasedups"
export HISTFILESIZE="10000"
export HISTSIZE="2000"
export HISTTIMEFORMAT="%Y-%m-%d %a %H:%M:%S    "
export LESS="-R --use-color"
export MANPAGER="most -s -t4 -w"
export PAGER="most -s -t4 -w"
export SCRIPTS="${HOME}/src/scripts/linux"
export SRC="${HOME}/src"
export VISUAL="micro"

# aliases
alias chmod='chmod --verbose'
alias chown='chown --verbose'
alias cp='cp --verbose'
alias diff='diff --color=auto'
alias fwboot='sync && systemctl reboot --firmware-setup'
alias grep='grep --color=auto'
alias ln='ln --verbose'
alias ls='ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto'
alias mkdir='mkdir --verbose'
alias mv='mv --verbose'
alias ncdu='ncdu -2 --confirm-quit --extended --one-file-system --show-itemcount --show-mtime'
alias poweroff='sync && systemctl poweroff'
alias reboot='sync && systemctl reboot'
alias refreshell="clear; reset; source ${HOME}/.bashrc"
alias rename='rename --verbose --interactive'
alias rm='rm --verbose'
alias rmdir='rmdir --verbose'
alias stdout-clip='xclip -selection clipboard'
alias stdout-code='code -'
alias stdout-curl='curl --form "clbin=<-" https://clbin.com'
alias today='date +"%Y-%m-%d %a %H:%M:%S %Z"; date +"%Y%m%d%H%M%S"; date +"%s"'

# prompt custom
[[ "$(id -u)" -eq 0 ]] && PS1='\[\e[91m\]\u@\h \[\e[93m\]\w\n\[\e[0m\]# ' && PS1="\[\e]0;\u@\h \w\a\]${PS1}"
[[ "$(id -u)" -ne 0 ]] && PS1='\[\e[92m\]\u@\h \[\e[96m\]\w\n\[\e[0m\]$ ' && PS1="\[\e]0;\u@\h \w\a\]${PS1}"
