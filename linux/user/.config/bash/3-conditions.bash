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
