
PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/.anaconda/bin"
PATH="${PATH}:${HOME}/.cargo/bin"
PATH="${PATH}:${HOME}/.go/bin"
PATH="${PATH}:${HOME}/.local/share/JetBrains/Toolbox/scripts"
PATH="${PATH}:${HOME}/src/scripts/linux"
PATH="${PATH}:${HOME}/src/binaries"

PATH="$(printf %s "${PATH}" | awk -vRS=: -vORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }' )"
export PATH
