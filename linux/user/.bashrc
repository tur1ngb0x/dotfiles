# #####################################################################
# behaviour
# #####################################################################
[[ -z "${PS1}" ]] && return
source /usr/share/bash-completion/bash_completion
shopt -s checkwinsize direxpand histappend histverify
stty -ixon

# #####################################################################
# path
# #####################################################################
PATH="${PATH}:${HOME}/src/scripts/linux"
PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/.cargo/bin"
PATH="${PATH}:/var/lib/flatpak/exports/bin"
PATH="${PATH}:${HOME}/.local/share/flatpak/exports/share"
PATH="$(printf '%s' "${PATH}" | awk '-vRS=:' '-vORS=' '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }' )"
export PATH

# #####################################################################
# variables
# #####################################################################
CLICOLOR="1"
EDITOR="micro"
HISTCONTROL="ignorespace:ignoredups:erasedups"
HISTFILESIZE="10000"
HISTSIZE="2000"
HISTTIMEFORMAT="%Y-%m-%d %a %H:%M:%S    "
LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
MANPAGER="most -s -t4 -w"
PAGER="most -s -t4 -w"
PROMPT_COMMAND="history -a"
STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
VISUAL="micro"
export CLICOLOR EDITOR HISTCONTROL HISTFILESIZE HISTSIZE HISTTIMEFORMAT LS_COLORS MANPAGER PAGER PROMPT_COMMAND STARSHIP_CONFIG VISUAL

# #####################################################################
# functions
# #####################################################################
function adbopt { adb shell cmd package bg-dexopt-job; }
function datenow { date +"%Y-%m-%d %a %H:%M:%S"; }
function stext { grep --color=always --ignore-case --binary-files=without-match --with-filename --recursive --line-number "${1}" . | less -r; }
function out-clip { xclip -selection clipboard; }
function out-code { code -; }
function out-curl { curl --form "clbin=<-" https://clbin.com; }
function refreshell { clear; reset; source "${HOME}"/.bashrc; }
function path { echo "${PATH}" | sed 's|:|\n|g'; }
#function gitlog { git --no-pager log --date='format:%Y-%m-%d %a %H:%M:%S' --pretty='format:| %C(red)%h%C(reset) | %C(blue)%ad%C(reset) | %C(green)%s%C(reset) | %C(yellow)%an%C(reset) |'; }
function gitlog { git --no-pager log --date='format:%Y-%m-%d %H:%M:%S' --pretty='format:%C(red)%h%C(reset) %C(blue)%ad%C(reset) %C(green)%s%C(reset) %C(yellow)(%an)%C(reset)'; }


# #####################################################################
# aliases
# #####################################################################
alias apt='sudo apt'
alias apt-get='sudo apt-get'
alias dnf='sudo dnf'
alias pacman='sudo pacman'
alias chmod='command chmod --verbose'
alias chown='command chown --verbose'
alias cp='command cp --verbose'
alias diff='command diff --color=auto'
alias grep='command grep --color=auto'
alias ln='command ln --verbose'
alias mkdir='command mkdir --verbose'
alias mv='command mv --verbose'
alias rm='command rm --verbose'
alias rmdir='command rmdir --verbose'

# #####################################################################
# better ls
# #####################################################################
if [[ $(command -v lsd) ]]; then
	alias ls='command lsd --almost-all --classify --human-readable --long'
	function cd { builtin cd "$@" && lsd --almost-all --classify --human-readable --long; }
else
	alias ls='command ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto'
	function cd { builtin cd "$@" && command ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y-%m-%d %a %H:%M:%S" --color=auto; }
fi

# #####################################################################
# shell prompt
# #####################################################################
# function ps1_datime { printf '%s' "$(date +'%Y-%m-%d %a %H:%M:%S')"; }
# function ps1_status { printf '%s' "${?}"; }
# function ps1_git {
# 	if [[ $(git rev-parse --is-inside-git-repository 2> /dev/null) ]]; then
# 		git_branch="$(git branch --no-color --show-current)"
# 		git_status="$(git status --porcelain | wc -l)"
# 		if [[ "${git_status}" -eq 0 ]]; then
# 			printf '\e[93;1;7m %s \e[0m' "${git_branch}"
# 		else
# 			printf '\e[93;1;7m %s %s \e[0m' "${git_branch}" "${git_status}"
# 		fi
# 	fi
# }

# function ps1_userhost { printf '\e[92;1;7m %s@%s \e[0m' "$(id --user --name)" "$(hostname --short)"; }
# function ps1_dir { printf '\e[94;1;7m %s \e[0m' "$(pwd -L)"; }
# function ps1_git { printf '%s' "$(git branch --no-color --show-current 2> /dev/null)"; }
# function ps1_sign { printf '%s' "$"; }
# PS1='$(ps1_userhost) $(ps1_dir) $(ps1_git)\n$(ps1_sign) '
PS1='\n$(tput rev) \u@\h \w $(tput sgr0) $(git branch --show-current 2>/dev/null)\n\$ '; PS1="\[\e]0;\u@\h \w\a\]${PS1}"
# #####################################################################
# misc
# #####################################################################
#eval "$(starship init bash)" 2>/dev/null
