# INIT
[[ -z "${PS1}" ]] && return
source /usr/share/bash-completion/bash_completion
shopt -s checkwinsize direxpand histverify

# PATH
PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/src/scripts/linux"
PATH="${PATH}:${HOME}/.local/share/flatpak/exports/share"
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
VISUAL="micro"
export EDITOR HISTCONTROL HISTFILESIZE HISTSIZE HISTTIMEFORMAT MANPAGER PAGER VISUAL

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

# shell prompt
function ps1_git {
	if [[ $(git rev-parse --is-inside-git-repository 2> /dev/null) ]]; then
		git_branch="$(git branch --no-color --show-current)"
		git_status="$(git status --porcelain | wc -l)"
		if [[ "${git_status}" -eq 0 ]]; then
			printf '\e[93;1;7m %s \e[0m' "${git_branch}"
		else
			printf '\e[93;1;7m %s %s \e[0m' "${git_branch}" "${git_status}"
		fi
	fi
}
PS1='\[\e[92;1;7m\] \u@\h \[\e[0m\] \[\e[96;1;7m\] \w \[\e[0m\] $(ps1_git)\n\\$ '
PS1="\[\e]0;\u@\h \w\a\]${PS1}"
