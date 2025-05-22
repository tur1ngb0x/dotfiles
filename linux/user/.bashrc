
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
alias rm="rm --verbose --interactive once"
alias rmdir='rmdir --verbose'



# FUNCTIONS
function ls () {
	command ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y%m%d-%a-%H%M%S" --color=always "${@}" \
    	| awk 'NR>1 { $2=""; $5=""; gsub(/  +/, " "); print }'
	return "${PIPESTATUS[0]}"
}
function today () { date +"%Y-%m-%d %^a %H:%M:%S %^Z %z"; }
function ddc () { sudo bash -c "modprobe i2c-dev && ddcutil setvcp 10 ${1}"; }
function outclip () { xclip -selection clipboard; }
function outpaste () { "${HOME}"/src/gitlab/pastelo/pastelo; }
function outcode () { code -; }
function path () { tr ':' '\n' <<< "${PATH}"; }
function pyv () { source "${PWD}/bin/activate"; }
function refreshell () { clear; reset; source "${HOME}/.bashrc"; }



# SHOW
function show () {
    if command -v batcat &>/dev/null; then
        batcat --set-terminal-title --style full "${@}"
    else
        cat -n "${@}"
    fi
}



# VSCODE
function codeman () {
    [[ -z "${1}" ]] && echo 'syntax: codeman <argument>' && return
    LC_ALL=C man "${1}" 2>/dev/null | code - --new-window --disable-extensions --sync off
}

function codesudo () {
    [[ -z "${1}" ]] && echo 'syntax: codesudo <argument>' && return
    local tmpdir; tmpdir="/tmp/vscode-sudo"; mkdir -pv "${tmpdir}/User"

    cat << EOF | sudo tee "${tmpdir}/User/settings.json"
{
    "security.workspace.trust.banner": "never",
    "security.workspace.trust.enabled": false,
    "telemetry.telemetryLevel": "off",
    "telemetry.feedback.enabled": false,
}
EOF
    sudo bash -c "code --disable-chromium-sandbox --disable-extensions --no-sandbox --reuse-window --sync off --user-data-dir ${tmpdir} ${1}"
}



# SHELL
# 0-9(basic), 30-37 (fg), 40-47(bg), 90-97(fgb), 100-107(bgb)
PROMPT_COMMAND='history -a';
PS1="\[\e[1;92m\]\u@\h \[\e[1;96m\]\w \[\e[1;93m\]\n\[\e[0m\]\$ "
PS1="\[\e]0;\u@\h \w\a\]${PS1}"



# STARSHIP
if command -v starship &> /dev/null; then
    STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
    function starship_win_title { echo -ne "\033]0; $USER@$HOSTNAME $PWD \007"; }
    starship_precmd_user_func="starship_win_title"
    eval "$(starship init bash)"
fi



# ZSH
# if command -v zsh &> /dev/null; then
# 	exec zsh --login --interactive
# fi
