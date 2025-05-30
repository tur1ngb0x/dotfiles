
# INIT
[[ "${-}" != *i* ]] && return
[[ -z "${BASH_COMPLETION_VERSINFO-}" ]] && source /usr/share/bash-completion/bash_completion
function show () { (set -x; "${@:?}"); }



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
alias chmod='command chmod --verbose'
alias chown='command chown --verbose'
alias cp='command cp --verbose'
alias diff='command diff --color=auto'
alias grep='command grep --color=auto'
alias ln='command ln --verbose'
# alias ls='ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto'
alias mkdir='command mkdir --verbose'
alias mv='command mv --verbose'
alias rm="command rm --verbose --interactive=once"
alias rmdir='command rmdir --verbose'



# FUNCTIONS
function today () { command date +"%Y-%m-%d %a %H:%M:%S %^Z %z"; }
function ddc () { command ddcutil setvcp 10 "${1}"; }
function outclip () { command xclip -selection clipboard; }
function outpaste () { "${HOME}"/src/gitlab/pastelo/pastelo; }
function outcode () { command code -; }
function path () { command tr ':' '\n' <<< "${PATH}"; }
function pyv () { command source "${PWD}/bin/activate"; }
function refreshell () { command clear; command reset; command source "${HOME}/.bashrc"; }


# SHELL - 0-9(basic), 30-37 (fg), 40-47(bg), 90-97(fgb), 100-107(bgb)
PROMPT_COMMAND='history -a'; export PROMPT_COMMAND
PS1="\[\e[1;92m\]\u@\h \[\e[1;96m\]\w \[\e[1;93m\]\n\[\e[0m\]\$ "; PS1="\[\e]0;\u@\h \w\a\]${PS1}"; export PS1



# MISC
function cheat () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: cheat <arg1> <arg2>' && return
    [[ -n "${1}" ]] && [[ -z "${2}" ]] && command curl -L https://cheat.sh/"${1}"
    [[ -n "${1}" ]] && [[ -n "${2}" ]] && command curl -L https://cheat.sh/"${1}"/"${2}"
}

if command -v lsd &> /dev/null; then
    alias ls='command lsd --almost-all --blocks 'permission,user,group,date,name' --classify --color auto --date "+%Y%m%d-%H%M%S" --group-dirs first --hyperlink auto --icon auto --icon-theme fancy --ignore-config --long --no-symlink --permission octal'
fi

function cd () {
    dir="${1:-${HOME}}"
    builtin cd "${dir}" && ls || return
    unset
}

function print () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: show <path>' && return
    if command -v batcat &>/dev/null; then
        command batcat --set-terminal-title --style full "${@}"
    elif command -v bat &>/dev/null; then
        command bat --set-terminal-title --style full "${@}"
    elif command -v cat &>/dev/null; then
        command cat -n "${@}"
    else
        echo 'bat/cat not found'
    fi
}

function detach () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: detach <command>' && return
    (command nohup "${1}" &) &>/dev/null
}

function codeman () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: codeman <command>' && return
    LC_ALL=C command man "${1}" 2>/dev/null | command code - --new-window --disable-extensions --sync off
}

function codesudo () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: codesudo <path>' && return
    local tmpdir; tmpdir="/tmp/vscode-sudo"; command mkdir -pv "${tmpdir}/User"
    sudo bash -c "command code --disable-chromium-sandbox --disable-extensions --no-sandbox --reuse-window --sync off --user-data-dir ${tmpdir} ${1}"
}

function cpsync () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: cpsync <src> <dest>' && return
    command rsync --verbose --recursive --no-inc-recursive --compress-level=0 --human-readable --progress --stats --ipv4 "${@}" && command sync
}

function dmp3 () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: dwnmp3 <urls>' && return
    command yt-dlp --verbose --force-ipv4 --preset-alias mp3 --audio-quality 0 -o "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" "${@}"
}

function dmp4 () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: dwnmp4 <urls>' && return
    command yt-dlp --verbose --force-ipv4 --preset-alias mp4 -o "%(title)s.%(ext)s" "${@}"
}

# function a2v () {
#     for f in *.mp3; do
#         base="${f%.mp3}"
#         ffmpeg -loop 1 \
#             -i cover.jpg \
#             -i "${f}" \
#             -c:v libx264rgb \
#             -crf 0 \
#             -r 1 \
#             -tune stillimage \
#             -s 720x720 \
#             -c:a copy \
#             -preset veryslow \
#             -shortest \
#             "${base}.mp4"
#     done
# }



function a2v () {
    [[ "${#}" -eq 0 ]] && echo 'syntax: a2v <url1> <url2> <url3> ... <urlN>' && return
    urls=("$@")
    for url in "${urls[@]}"; do
        tput rev; printf '%s\n' "getting playlist folder name"; tput sgr0
        playlist=$(command yt-dlp --quiet --force-ipv4 --skip-download --playlist-items 1 --get-filename -o "%(playlist)s" "${url}")
        if [ -z "${playlist}" ]; then
            printf '%s\n' "failed to get playlist folder"
            return
        fi
        echo "${playlist}"

        tput rev; printf '%s\n' "create playlist folder"; tput sgr0
        mkdir -pv "${playlist}"

        tput rev; printf '%s\n' "moving into playlist folder"; tput sgr0
        pushd "${playlist}" || return

        tput rev; printf '%s\n' "downloading playlist as mp3"; tput sgr0
        command yt-dlp --verbose --force-ipv4 --preset-alias mp3 --audio-quality 0 -o "%(playlist_index)s - %(title)s.%(ext)s" "${url}"

        tput rev; printf '%s\n' "download album art"; tput sgr0
        command yt-dlp --verbose --force-ipv4 --skip-download --playlist-items 1 --write-thumbnail --convert-thumbnails jpg -o "cover.%(ext)s" "${url}"

        tput rev; printf '%s\n' "generate album art"; tput sgr0
        if [ -f cover.jpg ]; then
            printf '%s\n' "cover.jpg already exists."
        else
            printf '%s\n' "Creating a black 720x720p cover.jpg"
            ffmpeg -f lavfi -i color=black:s=720x720 -frames:v 1 -update 1 cover.jpg
        fi

        tput rev; printf '%s\n' "convert jpg and mp3 to mp4"; tput sgr0
        for f in *.mp3; do
            base="${f%.mp3}"
            ffmpeg -loop 1 -i cover.jpg -i "${f}" -c:v libx264rgb -crf 0 -r 1 -tune stillimage -s 720x720 -c:a copy -preset veryslow -shortest "${base}".mp4
        done
        popd || return
done
}


function wttr () {
    [[ ! $(command -v curl) ]] && echo 'curl not found' && return
    [[ "${#}" -eq 0 ]] || [[ "${1}" =~ [[:space:]] ]] && echo 'syntax: now <city/city+name/pincode>' && return
    printf '%12s : %s\n' "Now" "$(date +'%Y-%m-%d %a %H:%M:%S %Z')"
    printf '%12s : %s\n' "Location" "$(command curl -sL4 "wttr.in/${1}?format=%l" | sed 's/+/ /g')"
    printf '%12s : %s\n' "Weather" "$(command curl -sL4 "wttr.in/${1}?format=%C")"
    printf '%12s : %s\n' "UV Index" "$(command curl -sL4 "wttr.in/${1}?format=%u")"
    printf '%12s : %s\n' "Temperature" "$(command curl -sL4 "wttr.in/${1}?format=%t")"
    printf '%12s : %s\n' "FeelsLike" "$(command curl -sL4 "wttr.in/${1}?format=%f")"
    printf '%12s : %s\n' "Rain" "$(command curl -sL4 "wttr.in/${1}?format=%p")"
    printf '%12s : %s\n' "Wind" "$(command curl -sL4 "wttr.in/${1}?format=%w")"
    printf '%12s : %s\n' "Humidity" "$(command curl -sL4 "wttr.in/${1}?format=%h")"
    printf '%12s : %s\n' "Pressure" "$(command curl -sL4 "wttr.in/${1}?format=%P")"
    printf '%12s : %s\n' "Dawn" "$(command curl -sL4 "wttr.in/${1}?format=%D")"
    printf '%12s : %s\n' "Sunrise" "$(command curl -sL4 "wttr.in/${1}?format=%S")"
    printf '%12s : %s\n' "Zenith" "$(command curl -sL4 "wttr.in/${1}?format=%z")"
    printf '%12s : %s\n' "Sunset" "$(command curl -sL4 "wttr.in/${1}?format=%s")"
    printf '%12s : %s\n' "Dusk" "$(command curl -sL4 "wttr.in/${1}?format=%d")"
    printf '%12s : %s\n' "Moon Day" "$(command curl -sL4 "wttr.in/${1}?format=%M")"
    printf '%12s : %s\n' "Moon Phase" "$(command curl -sL4 "wttr.in/${1}?format=%m")"
	printf '%12s : %s\n' "Moon Phase" "$(command curl -sL4 "wttr.in/${1}")"
}

if command -v starship &> /dev/null; then
    STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"; export STARSHIP_CONFIG
    function starship_win_title { echo -ne "\033]0; $USER@$HOSTNAME $PWD \007"; }
    starship_precmd_user_func="starship_win_title"
    eval "$(starship init bash)"
fi
