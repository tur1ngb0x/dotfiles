
# INIT
[[ "${-}" != *i* ]] && return
[[ -z "${BASH_COMPLETION_VERSINFO-}" ]] && source /usr/share/bash-completion/bash_completion



# OPTIONS
shopt -s checkwinsize
shopt -s histappend
shopt -s histverify
shopt -s cmdhist
# shopt -s autocd
# shopt -s cdable_vars
# shopt -s direxpand
# shopt -s dirspell



# PATH
PATH="${HOME}/src/adb:${PATH}"
PATH="${PATH}:/var/lib/flatpak/exports/bin"
PATH="${PATH}:${HOME}/.local/share/flatpak/exports/share"
PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/src/github/scripts/linux"
PATH="${PATH}:${HOME}/src/gitlab/pastelo"
PATH="$(printf '%s' "${PATH}" | awk -v RS=: -v ORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }')"; export PATH



# APPS
BROWSER='brave-browser-stable'; export BROWSER
EDITOR='micro'; export EDITOR
MANPAGER='most -s -t4 -w'; export MANPAGER
PAGER="${MANPAGER}"; export PAGER
TERMINAL='tilix'; export TERMINAL
VISUAL='micro'; export VISUAL



# VARIABLES
CLICOLOR='1'; export CLICOLOR
COLORTERM='truecolor'; export COLORTERM
HISTCONTROL='ignorespace:ignoredups:erasedups'; export HISTCONTROL
HISTFILESIZE='10000'; export HISTFILESIZE
HISTSIZE='2000'; export HISTSIZE
HISTTIMEFORMAT='%Y-%m-%d %a %H:%M:%S  '; export HISTTIMEFORMAT



# ALIASES
alias chmod='chmod --verbose'
alias chown='chown --verbose'
alias cp='cp --verbose'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ln='ln --verbose'
# alias ls='ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto'
alias mkdir='mkdir --verbose'
alias mv='mv --verbose'
alias rm="rm --verbose --interactive=once"
alias rmdir='rmdir --verbose'



# FUNCTIONS
function today () { date +"%Y-%m-%d %a %H:%M:%S %^Z %z"; }
function ddc () { sudo bash -c "modprobe i2c-dev && ddcutil setvcp 10 ${1}"; }
function outclip () { xclip -selection clipboard; }
function outpaste () { "${HOME}"/src/gitlab/pastelo/pastelo; }
function outcode () { code -; }
function path () { tr ':' '\n' <<< "${PATH}"; }
function pyv () { source "${PWD}/bin/activate"; }
function refreshell () { clear; reset; source "${HOME}/.bashrc"; }


# SHELL - 0-9(basic), 30-37 (fg), 40-47(bg), 90-97(fgb), 100-107(bgb)
PROMPT_COMMAND='history -a';
PS1="\[\e[1;92m\]\u@\h \[\e[1;96m\]\w \[\e[1;93m\]\n\[\e[0m\]\$ "
PS1="\[\e]0;\u@\h \w\a\]${PS1}"



# MISC
function cheat () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: cheat <arg1> <arg2>' && return
    [[ -n "${1}" ]] && [[ -z "${2}" ]] && command curl -L https://cheat.sh/"${1}"
    [[ -n "${1}" ]] && [[ -n "${2}" ]] && command curl -L https://cheat.sh/"${1}"/"${2}"
}

if command -v lsd &> /dev/null; then
    function ls () {
        command lsd --almost-all --blocks 'permission,user,group,date,git,name' --classify --color auto --date "+%Y%m%d-%H%M%S" --group-dirs first --hyperlink auto --icon auto --icon-theme fancy --ignore-config --long --no-symlink --permission octal "${@}"
    }
fi

function cd () {
    dir="${1:-${HOME}}"
    builtin cd "${dir}" && ls || return
    unset
}

function show () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: show <path>' && return
    if command -v batcat &>/dev/null; then
        batcat --set-terminal-title --style full "${@}"
    elif command -v bat &>/dev/null; then
        bat --set-terminal-title --style full "${@}"
    elif command -v cat &>/dev/null; then
        cat -n "${@}"
    else
        echo 'bat/cat not found'
    fi
}

function detach () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: detach <command>' && return
    (nohup "${1}" &) &>/dev/null
}

function codeman () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: codeman <command>' && return
    LC_ALL=C command man "${1}" 2>/dev/null | command code - --new-window --disable-extensions --sync off
}

function codesudo () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: codesudo <path>' && return
    local tmpdir; tmpdir="/tmp/vscode-sudo"; mkdir -pv "${tmpdir}/User"
    sudo bash -c "command code --disable-chromium-sandbox --disable-extensions --no-sandbox --reuse-window --sync off --user-data-dir ${tmpdir} ${1}"
}

function cpsync () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: cpsync <src> <dest>' && return
    command rsync --verbose --recursive --no-inc-recursive --compress-level=0 --human-readable --progress --stats --ipv4 "${@}" && command sync
}

function dmp3 () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: dwnmp3 <urls>' && return
    yt-dlp --verbose --force-ipv4 --preset-alias mp3 --audio-quality 0 -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" "${@}"
}

function dmp4 () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: dwnmp4 <urls>' && return
    yt-dlp --verbose --force-ipv4 --preset-alias mp4 -o "%(title)s.%(ext)s" "${@}"
}

if command -v starship &> /dev/null; then
    STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"; export STARSHIP_CONFIG
    function starship_win_title { echo -ne "\033]0; $USER@$HOSTNAME $PWD \007"; }
    starship_precmd_user_func="starship_win_title"
    eval "$(starship init bash)"
fi

function wttr () {
    [[ ! $(command -v curl) ]] && echo 'curl not found' && return
    [[ "${#}" -eq 0 ]] || [[ "${1}" =~ [[:space:]] ]] && echo 'syntax: now <city/city+name/pincode>' && return
    # printf '%12s : %s\n' "Now" "$(date +'%Y-%m-%d %a %H:%M:%S %Z')"
    # printf '%12s : %s\n' "Location" "$(curl -s -L -4 "wttr.in/${1}?format=%l")"
    # printf '%s\n' ''
    printf '%12s : %s\n' "Weather" "$(curl -s -L -4 "wttr.in/${1}?format=%C")"
    printf '%12s : %s\n' "UV Index" "$(curl -s -L -4 "wttr.in/${1}?format=%u")"
    printf '%12s : %s\n' "Temperature" "$(curl -s -L -4 "wttr.in/${1}?format=%t")"
    printf '%12s : %s\n' "FeelsLike" "$(curl -s -L -4 "wttr.in/${1}?format=%f")"
    printf '%s\n' ''
    printf '%12s : %s\n' "Rain" "$(curl -s -L -4 "wttr.in/${1}?format=%p")"
    printf '%12s : %s\n' "Wind" "$(curl -s -L -4 "wttr.in/${1}?format=%w")"
    printf '%12s : %s\n' "Humidity" "$(curl -s -L -4 "wttr.in/${1}?format=%h")"
    printf '%12s : %s\n' "Pressure" "$(curl -s -L -4 "wttr.in/${1}?format=%P")"
    printf '%s\n' ''
    printf '%12s : %s\n' "Dawn" "$(curl -s -L -4 "wttr.in/${1}?format=%D")"
    printf '%12s : %s\n' "Sunrise" "$(curl -s -L -4 "wttr.in/${1}?format=%S")"
    printf '%12s : %s\n' "Zenith" "$(curl -s -L -4 "wttr.in/${1}?format=%z")"
    printf '%12s : %s\n' "Sunset" "$(curl -s -L -4 "wttr.in/${1}?format=%s")"
    printf '%12s : %s\n' "Dusk" "$(curl -s -L -4 "wttr.in/${1}?format=%d")"
    printf '%s\n' ''
    printf '%12s : %s\n' "Moon Day" "$(curl -s -L -4 "wttr.in/${1}?format=%M")"
    printf '%12s : %s\n' "Moon Phase" "$(curl -s -L -4 "wttr.in/${1}?format=%m")"
}
