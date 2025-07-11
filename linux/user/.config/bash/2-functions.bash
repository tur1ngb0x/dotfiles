printf "%s\n" "# loading functions..."

function cheat()
{
    command curl -4 -L "https://cheat.sh/${1}"
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

function codeman()
{
    [[ "${#}" -eq 0 ]] && echo 'syntax: codeman <command>' && return
    LC_ALL=C command man "${1}" 2> /dev/null | command code - --new-window --disable-extensions --sync off
}

function codesudo()
{
    [[ "${#}" -eq 0 ]] && echo 'syntax: codesudo <path>' && return
    command mkdir -pv /tmp/vscode-sudo/User
    sudo bash -c "command code --disable-chromium-sandbox --disable-extensions --no-sandbox --reuse-window --sync off --user-data-dir /tmp/vscode-sudo/User ${@}"
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

function search()
{
    [[ "${#}" -ne 3 ]] && echo 'syntax: search <path> <type> <query>' && return
    command find "${1}" -type "${2}" -iname "${3}"
}


function osfetch()
{
    if command -v fastfetch &> /dev/null; then
		echo '$ fastfetch'; command fastfetch "${@}"        # --logo none
    elif command -v screenfetch &> /dev/null; then
        echo '$ screenfetch'; command screenfetch "${@}"    # -n
    elif command -v neofetch &> /dev/null; then
        echo '$ neofetch'; command neofetch "${@}"          # -off
    elif command -v distrofetch.sh &> /dev/null; then
        echo '$ distrofetch.sh'; command distrofetch.sh
    fi
}
