printf "%s\n" "# loading functions..."

function cheat()
{
    command curl -4 -L "https://cheat.sh/${1}"
}

function locatee () {
    command locate "${@}" | sort
}

function gogh () {
    wget -4 -O /tmp/gogh.sh 'https://raw.githubusercontent.com/Mayccoll/Gogh/master/gogh.sh'
    chmod -v +x /tmp/gogh.sh
    /tmp/gogh.sh
}

function fmtcmd()
{
    [[ "${#}" -eq 0 ]] && echo 'syntax: fmtcmd <command>' && return
    local printable status
    printf -v printable '%q ' "${@}"
    printf '%s INPUT: %s\n$ %s\n' "$(tput rev)" "$(tput sgr0)" "${printable}"
    printf '%s OUTPUT: %s\n' "$(tput rev)" "$(tput sgr0)"
    "${@}"
    status="${?}"
    printf '%s STATUS: %s\n%s\n' "$(tput rev)" "$(tput sgr0)" "${status}"
    return "${status}"
}

function now()
{
    command date +"%Y-%m-%d %a %H:%M:%S %^Z %z"
}

function outclip()
{
    [[ -t 0 ]] && echo 'syntax: <command> | outclip' && return
    command xclip -selection clipboard
}

function outcode()
{
    [[ -t 0 ]] && echo 'syntax: <command> | outcode' && return
    command code -
}

function outpaste()
{
    [[ -t 0 ]] && echo 'syntax: <command> | outpaste' && return
    chmod +x "${HOME}"/src/gitlab/pastelo/pastelo
    "${HOME}"/src/gitlab/pastelo/pastelo
}

function pastelo()
{
    chmod +x "${HOME}"/src/gitlab/pastelo/pastelo
    [[ "${#}" -eq 0 ]] && "${HOME}"/src/gitlab/pastelo/pastelo --help && return
    "${HOME}"/src/gitlab/pastelo/pastelo
}

function path()
{
    command tr ':' '\n' <<< "${PATH}"
}

function pyv()
{
    command source "${PWD}/bin/activate"
}

function refreshell()
{
    command clear
    command reset
    command source "${HOME}/.bashrc"
}

function detach()
{
    [[ "${#}" -eq 0 ]] && echo 'syntax: detach <command>' && return
    (command nohup "${1}" &) &> /dev/null
}

function editor() {
    for e in code codium subl kate gedit xed mousepad micro nano vim; do
        if command -v "${e}" >/dev/null 2>&1; then
            echo "Using ${e}..."
            "${e}" "$@"
            return
        fi
    done
    echo "Editor not found."
    return 1
}

function codeman()
{
    [[ "${#}" -eq 0 ]] && echo 'syntax: codeman <command>' && return
    LC_ALL=C command man "${1}" 2> /dev/null | command code - --new-window --disable-extensions --sync off
}

function codesudo()
{
    [[ "${#}" -eq 0 ]] && echo 'syntax: codesudo <p>' && return
    if command -v code &> /dev/null; then CODE="code"; fi
    if command -v codium &> /dev/null; then CODE="codium"; fi
    TMPDIR="/tmp/codesudo/User"
    command mkdir -pv "${TMPDIR}"
    sudo bash -c "command ${CODE} --disable-chromium-sandbox --disable-extensions --no-sandbox --reuse-window --sync off --user-data-dir ${TMPDIR} ${@}"
}

function cpsync()
{
    [[ "${#}" -eq 0 ]] && echo 'syntax: cpsync <src> <dest>' && return
    command rsync --verbose --recursive --no-inc-recursive --compress-level=0 --human-readable --progress --stats --ipv4 "${@}" && command sync
}

function dw-art()
{
    [[ "${#}" -eq 0 ]] && echo 'syntax: dw-art <URL>' && return
    command yt-dlp --verbose --force-ipv4 --skip-download --playlist-items 1 --write-thumbnail --convert-thumbnails 'jpg' -o "cover.%(ext)s" "${1}"
}

function dw-mp3()
{
    [[ "${#}" -eq 0 ]] && echo 'syntax: dw-mp3 <url(s)>' && return
    command yt-dlp --verbose --force-ipv4 --preset-alias 'mp3' --audio-quality 0 --embed-subs --embed-thumbnail --embed-metadata --embed-chapters -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' "${@}"
}

function dw-mp4()
{
    [[ "${#}" -eq 0 ]] && echo 'syntax: dw-mp4 <url(s)>' && return
    command yt-dlp --verbose --force-ipv4 --preset-alias 'mp4' --prefer-free-formats --sub-langs 'en.*' --embed-subs --embed-thumbnail --embed-metadata --embed-chapters -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' "${@}"
}

function ddc()
{
    hour="$(date +%-H)"
    value=""

    if [ "${#}" -eq 0 ]; then
        if ((hour >= 6 && hour < 18)); then
            value="100"
        elif ((hour >= 18 && hour < 21)); then
            value="50"
        else
            value="0"
        fi
        command ddcutil setvcp 10 "${value}"
    elif [ "${#}" -eq 1 ]; then
        value="${1}"
        command ddcutil setvcp 10 "${value}"
    else
        echo "syntax: ddc <value>"
    fi
}

function search() {
    local q="${1:?search <arg>}"; shift
    local d=("${@:-.}")
    command find "${d[@]}" -iname "*${q}*" | sort
}

function grepp () {
    [[ $# -eq 0 ]] && echo 'syntax: grepp <pattern> [directory]' && return
    command grep --color=always --ignore-case --binary-files=without-match --dereference-recursive --line-number  "${1}" ${2:-.} 2>/dev/null
}

# function nerdfont () {
#     [[ "$1" == '-h' || "$1" == '--help' || $# -eq 0 ]] && echo 'https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts' && return
#     mkdir -pv /tmp/nerd-fonts; curl -4 -L -o "/tmp/nerd-fonts/${1}.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${1}.tar.xz"
#     mkdir -pv "${HOME}/.local/share/fonts/${1}"; tar --verbose --file "/tmp/nerd-fonts/${1}.tar.xz" --extract --xz --directory "${HOME}/.local/share/fonts/${1}"
#     sudo chown -Rc "${USER}":"${USER}" "${HOME}/.local/share/fonts"; fc-cache -r
# }

function nerdfont () {
    [[ "$1" == '-h' || "$1" == '--help' || $# -eq 0 ]] && echo 'https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts' && return
    mkdir -pv /tmp/nerd-fonts
    curl -4fL -o "/tmp/nerd-fonts/${1}.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${1}.tar.xz"
    mkdir -pv "${HOME}/.local/share/fonts/${1}"
    tar --verbose --file "/tmp/nerd-fonts/${1}.tar.xz" --extract --xz --directory "${HOME}/.local/share/fonts/${1}"
    sudo chown -Rc "${USER}":"${USER}" "${HOME}/.local/share/fonts"
    fc-cache -r
}

function upgrade () {
    show() { printf '\033[7m # %s \033[0m\n' "${*}"; eval "${@:?}"; }
    if command -v code; then    show "code --update-extensions"; fi
    if command -v pipx; then    show "pipx upgrade-all"; fi
    if command -v flatpak; then show "flatpak update --noninteractive"; fi
    if command -v snap; then    show "sudo bash -c 'snap refresh'"; fi
    if command -v apt-get; then show "sudo bash -c 'apt-get clean && apt-get update && apt-get dist-upgrade'" && return; fi
    if command -v dnf; then     show "sudo bash -c 'dnf upgrade --refresh'" && return; fi
    if command -v pacman; then  show "sudo bash -c 'pacman -Syyu'" && return; fi
}

function osfetch()
{
    if command -v fastfetch &> /dev/null; then
        echo 'using fastfetch'; command fastfetch "${@}"        # --logo none
    elif command -v screenfetch &> /dev/null; then
        echo 'using screenfetch'; command screenfetch "${@}"    # -n
    elif command -v neofetch &> /dev/null; then
        echo 'using neofetch'; command neofetch "${@}"          # -off
    elif command -v distrofetch.sh &> /dev/null; then
        echo 'using distrofetch.sh'; command distrofetch.sh
    fi
}

function wttr()
{
    function usage(){
        cat << EOF
Description:
Bash wrapper for https://github.com/chubin/wttr.in

Syntax:
wttr <City+Name>       wttr 'Salt+Lake+City'
wttr <Pincode>         wttr '110001'
EOF
    }
    [[ ! $(command -v curl) ]] && echo 'curl not found' && return
    [[ "${#}" -eq 0 ]] || [[ "${1}" =~ [[:space:]] ]] && usage && return
    printf '%12s : %s\n' "Now" "$(date +'%Y-%m-%d %a %H:%M:%S %Z')"
    printf '%12s : %s\n' "Location" "$(command curl -sfL4 "https://wttr.in/${1}?format=%l" | sed 's/+/ /g')"
    printf '%12s : %s\n' "Weather" "$(command curl -sL4 "https://wttr.in/${1}?format=%C")"
    printf '%12s : %s\n' "UV Index" "$(command curl -sL4 "https://wttr.in/${1}?format=%u")"
    printf '%12s : %s\n' "Temperature" "$(command curl -sL4 "https://wttr.in/${1}?format=%t")"
    printf '%12s : %s\n' "FeelsLike" "$(command curl -sL4 "https://wttr.in/${1}?format=%f")"
    printf '%12s : %s\n' "Rain" "$(command curl -sL4 "https://wttr.in/${1}?format=%p")"
    printf '%12s : %s\n' "Wind" "$(command curl -sL4 "https://wttr.in/${1}?format=%w")"
    printf '%12s : %s\n' "Humidity" "$(command curl -sL4 "https://wttr.in/${1}?format=%h")"
    printf '%12s : %s\n' "Pressure" "$(command curl -sL4 "https://wttr.in/${1}?format=%P")"
    # printf '%12s : %s\n' "Dawn" "$(command curl -sL4 "https://wttr.in/${1}?format=%D")"
    # printf '%12s : %s\n' "Sunrise" "$(command curl -sL4 "https://wttr.in/${1}?format=%S")"
    # printf '%12s : %s\n' "Zenith" "$(command curl -sL4 "https://wttr.in/${1}?format=%z")"
    # printf '%12s : %s\n' "Sunset" "$(command curl -sL4 "https://wttr.in/${1}?format=%s")"
    # printf '%12s : %s\n' "Dusk" "$(command curl -sL4 "https://wttr.in/${1}?format=%d")"
    # printf '%12s : %s\n' "Moon Day" "$(command curl -sL4 "https://wttr.in/${1}?format=%M")"
    # printf '%12s : %s\n' "Moon Phase" "$(command curl -sL4 "https://wttr.in/${1}?format=%m")"
}; wttr 411068
