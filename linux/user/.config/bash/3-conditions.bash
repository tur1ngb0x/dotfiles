printf "%s\n" "# loading conditions..."

# bash completion
if [[ -z "${BASH_COMPLETION_VERSINFO}" ]]; then
	source /usr/share/bash-completion/bash_completion
fi

# lsd for file listing
if command -v lsd &>/dev/null; then
    OPTIONS=(
        --almost-all
        --blocks 'permission,user,group,date,name'
        --classify
        --color 'auto'
        --date '+%Y/%m/%d %H:%M:%S'
        --group-dirs 'first'
        --hyperlink 'auto'
        --icon 'auto'
        --icon-theme 'fancy'
        --ignore-config
        --long
        --no-symlink
    )

    function ls() {
        command lsd "${OPTIONS[@]}" "$@"
    }

    function cd() {
        builtin cd "${1:-$HOME}" && command lsd "${OPTIONS[@]}" || return
    }
else
    OPTIONS=(
        --almost-all
        --classify
        --format=verbose
        --human-readable
        --time-style=+"%Y-%m-%d %a %H:%M:%S"
        --color=auto
    )

    function ls() {
        command ls "${OPTIONS[@]}" "${@}"
    }
	function cd() {
    	builtin cd "${1:-$HOME}" && command ls "${OPTIONS[@]}" || return
    }
fi

# fzf
if command -v fzf &> /dev/null; then
    function fuzzy-history() {
        local cmd; cmd=$(history | tac | fzf +s | awk '{ $1=$2=$3=$4=""; sub(/^ +/, ""); print }')
        if [[ -n "${cmd}" ]]; then
            READLINE_LINE="${cmd}"
            READLINE_POINT="${#cmd}"
        fi
    }
fi

# better man pages
if command -v bat &> /dev/null; then
	MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | batcat -p -lman'"; export MANPAGER
elif command -v batcat &>/dev/null; then
	MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | batcat -p -lman'"; export MANPAGER
elif command -v most &>/dev/null; then
	MANPAGER="most -s -t4 -w"; export MANPAGER
else
	MANPAGER="";
fi


# wsl2 specific
if grep -qw 'microsoft-standard-WSL2' /proc/sys/kernel/osrelease; then
    function outclip () {
        [[ -t 0 ]] && echo 'syntax: <command> | outclip' && return
        command clip.exe
    }

    function wsl-status () {
        [[ "${#}" -ne 0 ]] && echo 'syntax: wsl-list' && return
		command wsl.exe --version
		command wsl.exe --list --verbose
		command wsl.exe --status
    }

    function wsl-off () {
        [[ "${#}" -ne 0 ]] && echo 'syntax: wsl-off' && return
        command wsl.exe --shutdown
    }
fi

# starship prompt
if command -v starship &> /dev/null; then
    STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"; export STARSHIP_CONFIG
    function starship_win_title { echo -ne "\033]0; $USER@$HOSTNAME $PWD \007"; }
    starship_precmd_user_func="starship_win_title"
    eval "$(starship init bash)"
fi
