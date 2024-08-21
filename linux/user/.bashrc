# INIT
if [[ -z "${PS1}" ]]; then return; fi
if [[ -f /usr/share/bash-completion/bash_completion ]]; then source /usr/share/bash-completion/bash_completion; fi
shopt -s checkwinsize direxpand histverify

# PATH
PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/src/scripts/linux"
PATH="$(printf %s "${PATH}" | awk -vRS=: -vORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }' )"
export PATH

# VARIABLES
EDITOR="micro"
HISTCONTROL="ignorespace:ignoredups:erasedups"
HISTFILESIZE="10000"
HISTSIZE="2000"
HISTTIMEFORMAT="%Y-%m-%d %a %H:%M:%S    "
MANPAGER="most -s -t4 -w"
PAGER="most -s -t4 -w"
STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
VISUAL="micro"
export EDITOR HISTCONTROL HISTFILESIZE HISTSIZE HISTTIMEFORMAT MANPAGER PAGER STARSHIP_CONFIG VISUAL

# FUNCTIONS
function adbopt { adb shell cmd package bg-dexopt-job; }
function datenow { date +"%Y-%m-%d %a %H:%M:%S"; }
function out-clip { xclip -selection clipboard; }
function out-code { code -; }
function out-curl { curl --form "clbin=<-" https://clbin.com; }
function refreshell { clear; reset; source "${HOME}"/.bashrc; }

# ALIASES
alias chmod='chmod --verbose'
alias chown='chown --verbose'
alias cp='cp --verbose'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ln='ln --verbose'
alias ls='ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto'
alias mkdir='mkdir --verbose'
alias mv='mv --verbose'
alias rm='rm --verbose'
alias rmdir='rmdir --verbose'

# PS1
PS1='\[\e[7m\] \u@\h \w \[\e[0m\] $(git branch --no-color --show-current 2>/dev/null)\n \$ '
PS1="\[\e]0;\u@\h \w\a\]${PS1}"
export PS1

# STARSHIP
if [[ $(command -v starship) ]]; then eval "$(starship init bash)"; fi

# PIPX
if [[ $(command -v pipx) ]]; then eval "$(register-python-argcomplete3 pipx)"; fi

# FETCH
if [[ $(command -v fetch.sh) ]]; then fetch.sh --short; fi

export PATH=$PATH:/home/pd/.spicetify
