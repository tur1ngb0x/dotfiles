
# Behaviour
[[ "${-}" != *i* ]] && return
[[ -z "$BASH_COMPLETION_VERSINFO" ]] && source /usr/share/bash-completion/bash_completion
shopt -s checkwinsize direxpand histappend histverify
stty -ixon

# Helpers
function set_variable { eval "${1}=\"${*:2}\"; export ${1}"; }
function set_alias { alias "${1}"="command ${*:2}"; }
function set_function { eval "function ${1} { \"${*:2}\" ; }; export -f ${1}"; }
function set_path { PATH="${PATH}:${1}"; PATH="$(printf '%s' "${PATH}" | awk -v RS=: -v ORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }')"; export PATH; }

# PATH
set_path '/var/lib/flatpak/exports/bin'
set_path "${HOME}/.cargo/bin"
set_path "${HOME}/.local/bin"
set_path "${HOME}/.local/share/flatpak/exports/share"
set_path "${HOME}/src/scripts/linux"

# Variables
set_variable 'CLICOLOR'         '1'
set_variable 'EDITOR'           'micro'
set_variable 'HISTCONTROL'      'ignorespace:ignoredups:erasedups'
set_variable 'HISTFILESIZE'     '10000'
set_variable 'HISTSIZE'         '2000'
set_variable 'HISTTIMEFORMAT'   '%Y-%m-%d %a %H:%M:%S    '
set_variable 'MANPAGER'         'most -s -t4 -w'
set_variable 'PAGER'            "${MANPAGER}"
set_variable 'PROMPT_COMMAND'   'history -a'
set_variable 'PS1'              "$(tput rev) \u@\h \w $(tput sgr0)\n\$ "
set_variable 'PS1'              "\[\e]0;\u@\h \w\a\]${PS1}"
set_variable 'STARSHIP_CONFIG'  "${HOME}/.config/starship/starship.toml"
set_variable 'VISUAL'           'micro'

# Functions
set_function 'datenow'          'date +"%Y-%m-%d %a %H:%M:%S %Z %z"'
set_function 'outclip'          'xclip -selection clipboard'
set_function 'outcode'          'code -'
set_function 'outcurl'          'curl --ipv4 --form "clbin=<-" https://clbin.com'
set_function 'path'             "echo ${PATH} | tr ':' '\n'"
set_function 'pyv'              "source ${PWD}/bin/activate"
set_function 'refreshell'       "clear; reset; source ${HOME}/.bashrc"

# Aliases
set_alias 'catt'                'bat --style full'
set_alias 'chmod'               'chmod --verbose'
set_alias 'chown'               'chown --verbose'
set_alias 'cp'                  'cp --verbose'
set_alias 'diff'                'diff --color=auto'
set_alias 'grep'                'grep --color=auto'
set_alias 'ln'                  'ln --verbose'
set_alias 'ls'                  'ls --almost-all --classify --format=verbose --human-readable --time-style=+"%Y%m%d-%a-%H%M%S" --color=always'
set_alias 'mkdir'               'mkdir --verbose'
set_alias 'mv'                  'mv --verbose'
set_alias 'rmdir'               'rmdir --verbose'
set_alias 'rmm'                 'trash --verbose --interactive'
