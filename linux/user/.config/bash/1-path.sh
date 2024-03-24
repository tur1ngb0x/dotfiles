
# xdg
PATH="${PATH}:${HOME}/.local/bin"

# anaconda
PATH="${PATH}:${HOME}/.anaconda/bin"

# rust
PATH="${PATH}:${HOME}/.cargo/bin"

# golang
PATH="${PATH}:${HOME}/.go/bin"

# jetbrains toolbox
PATH="${PATH}:${HOME}/.local/share/JetBrains/Toolbox/scripts"

# custom
PATH="${PATH}:${HOME}/src/scripts/linux"
PATH="${PATH}:${HOME}/src/binaries"

# remove duplicates
PATH="$(printf %s "${PATH}" | awk -vRS=: -vORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }' )"

# set path
export PATH
