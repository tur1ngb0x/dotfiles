# INTERACTIVE
[[ "${-}" != *i* ]] && builtin return

# COMPLETION
[[ -z "${BASH_COMPLETION_VERSINFO}" ]] && builtin source /usr/share/bash-completion/bash_completion

# ADDONS
function addons_enable () {
		builtin source "${HOME}/src/dotfiles/linux/user/.config/bash/01-shell.bash"
		builtin source "${HOME}/src/dotfiles/linux/user/.config/bash/02-path.bash"
		builtin source "${HOME}/src/dotfiles/linux/user/.config/bash/03-variables.bash"
		builtin source "${HOME}/src/dotfiles/linux/user/.config/bash/04-aliases.bash"
		builtin source "${HOME}/src/dotfiles/linux/user/.config/bash/05-functions.bash"
		builtin source "${HOME}/src/dotfiles/linux/user/.config/bash/06-misc.bash"
}
addons_enable

# PROMPT
PROMPT_COMMAND='builtin history -a'
PS1='\[\e[1;35m\]\t\[\e[0m\] \[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;36m\]\w\[\e[0m\]$(command -p git rev-parse --git-dir &>/dev/null && builtin printf " \[\e[1;33m\](git:%s)\[\e[0m\]" "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)") \n\$ '
PS1="\[\e]0;\t \u@\h \w\a\]${PS1}"
