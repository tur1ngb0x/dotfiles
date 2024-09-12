# init
[[ -z "${PS1}" ]] && return
source /usr/share/bash-completion/bash_completion

# behaviour
shopt -s checkwinsize
shopt -s histappend

# shell prompt
function ps1_git {
	if [[ $(git rev-parse --is-inside-git-repository 2> /dev/null) ]]; then
		git_branch="$(git branch --no-color --show-current)"
		if [[ $(git status --porcelain | wc -l) -ne 0 ]]; then
			git_status="$(git status --porcelain | wc -l)"
			printf '\e[93;1;7m %s %s \e[0m' "${git_branch}" "!${git_status}"
		fi
	fi
}
PS1='\[\e[91;1;7m\] \u@\h \[\e[0m\] \[\e[96;1;7m\] \w \[\e[0m\] $(ps1_git)\n\\$ '
PS1="\[\e]0;\u@\h \w\a\]${PS1}"
