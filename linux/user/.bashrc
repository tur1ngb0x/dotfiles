# CHECK
if [[ "${-}" != *i* ]]; then
    return
fi

# BEHAVIOUR
shopt -s autocd
shopt -s cdable_vars
shopt -s checkwinsize
shopt -s direxpand
shopt -s dirspell
shopt -s expand_aliases
shopt -s histappend
shopt -s histverify

# COMPLETION
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    if [[ -z "${BASH_COMPLETION_VERSINFO-}" ]]; then
        source /usr/share/bash-completion/bash_completion
    fi
else
    echo 'bash-completion is not installed'
fi

# COMMAND NOT FOUND
function command_not_found_handle () {
    if [[ -x /usr/lib/command-not-found ]]; then
        /usr/lib/command-not-found -- "${1}"
        return "${?}"
    elif [[ -x /usr/share/command-not-found/command-not-found ]]; then
        /usr/share/command-not-found/command-not-found -- "${1}"
        return "${?}"
    else
        printf "%s: command not found\n" "${1}" >&2
        return 127
    fi
}

# PATH PREFIX
PATH="${HOME}/src/adb:${PATH}"

# PATH SUFFIX
PATH="${PATH}:/var/lib/flatpak/exports/bin"
PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/.local/share/flatpak/exports/share"
PATH="${PATH}:${HOME}/src/cargo/bin"
PATH="${PATH}:${HOME}/src/distrobox/bin"
PATH="${PATH}:${HOME}/src/go/bin"
PATH="${PATH}:${HOME}/src/scripts/linux"
PATH="${PATH}:${HOME}/src/pastelo"
PATH="$(printf '%s' "${PATH}" | awk -v RS=: -v ORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }')"
export PATH

# VARIABLES
CLICOLOR='1'
COLORTERM='truecolor'
EDITOR='micro'
HISTCONTROL='ignorespace:ignoredups:erasedups'
HISTFILESIZE='10000'
HISTSIZE='2000'
HISTTIMEFORMAT='%Y-%m-%d %a %H:%M:%S  '
MANPAGER='most -s -t4 -w'
PROMPT_COMMAND='history -a'
PAGER="${MANPAGER}"
VISUAL='micro'
DOTS="${HOME}/src/dotfiles"
SCRS="${HOME}/src/scripts"
export DOTS SCRS
export CLICOLOR COLOR TERM EDITOR HISTCONTROL HISTFILESIZE HISTSIZE HISTTIMEFORMAT MANPAGER PAGER PROMPT_COMMAND PS1 STARSHIP_CONFIG VISUAL

# FUNCTIONS
function datenow { date +"%Y-%m-%d %a %H:%M:%S %Z %z"; }
function ddc { sudo bash -c "modprobe i2c-dev && ddcutil setvcp 10 ${1}"; }
function codeman { manfile="$(mktemp)-${1}.man"; man "${1}" > "${manfile}"; code --new-window --disable-extensions --sync off "${manfile}"; }
function outclip { xclip -selection clipboard; }
function outcode { code -; }
function outpaste { "${HOME}"/src/pastelo/pastelo; }
function path { tr ':' '\n' <<< "${PATH}"; }
function pyv { source "${PWD}/bin/activate"; }
function refreshell { clear; reset; source "${HOME}/.bashrc"; }

# ALIASES
alias chmod='chmod --verbose'
alias chown='chown --verbose'
alias cp='cp --verbose'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ln='ln --verbose'
alias ls='ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y%m%d-%a-%H%M%S" --color=auto'
alias mkdir='mkdir --verbose'
alias mv='mv --verbose'
alias rm="rm --verbose"
alias rmdir='rmdir --verbose'

# SHELL PROMPT
userid="$(id -ur)"
case "${userid}" in
    0)
        PS1='\[\e[91m\]\u@\h\[\e[0m\] \[\e[96m\]\w\[\e[0m\] \[\e[93m\]\n\[\e[0m\]  '
        PS1="\[\e]0;\u@\h:\w\a\]${PS1}"
        ;;
    *)  PS1='\[\e[92m\]\u@\h\[\e[0m\] \[\e[96m\]\w\[\e[0m\] \[\e[93m\]$(git --no-pager branch --color=never --show-current 2>/dev/null)\n\[\e[0m\]  '
        PS1="\[\e]0;\u@\h:\w\a\]${PS1}"
        ;;
esac
unset userid

# lsd
if command -v lsd &> /dev/null; then
    alias ls="lsd \
    --almost-all \
    --classify \
    --color auto \
    --group-dirs first \
    --header \
    --human-readable \
    --icon auto \
    --icon-theme fancy \
    --long \
    --no-symlink \
    --permission octal \
    --size default \
    "
fi

# starship
if command -v starship &> /dev/null; then
    STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
    function starship_win_title {
        echo -ne "\033]0; $USER@$HOSTNAME $PWD \007"
    }
    starship_precmd_user_func="starship_win_title"
    eval "$(starship init bash)"
fi

# ADB Shell
# alias ls='ls -A -a -F -g -h -l -o -p -s --color=always'
# export PS1="${USER}@${HOSTNAME} ${PWD} $ "
