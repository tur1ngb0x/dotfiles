
# if already sourced, dont do anything and return from the common.sh
[[ -n "${COMMON_SH_SOURCED}" ]] && return

# set locale
LC_ALL=C; export LC_ALL

# get current directory name
CWD="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd -P)"; export CWD

# print and run the command
function ShowCmd {
    (set -x; "${@:?}")
}

# print simple text
function PrintText {
    printf "%s\n" "${1}";
}

# print header text
function PrintHeader {
    tput rev
    printf " %s \n" "${1}"
    tput sgr0
}

# print error text
function PrintError {
    tput setaf 1
    printf "# Error: %s\n" "${1}"
    tput sgr0
}

# prompt the user for Y or y to continue
function PromptUser {
    local answer
    printf "%s\n" "$1"
    read -p "Input: " -n 1 -r answer
    echo ''
    if [[ ! "${answer}" =~ ^[Yy]$ ]]; then
        return
    fi
}

# check if requirements are met
function CheckCmd {
    for cmd in "${@}"; do
        if command -v "${cmd}" &> /dev/null; then
            echo "${cmd} found in PATH"
        else
            echo "${cmd} not found in PATH"
            return
        fi
    done
}

function CreateDir {
    local dir="${1:?Directory path required}"
    if [[ ! -d "${dir}" ]]; then
        mkdir -p "${dir}"
    else
        PrintText "Directory already exists: ${dir}"
    fi
}

function CreateLink {
    local source="${1:?Source path required}"
    local link="${2:?Link name required}"

    if [[ ! -e "${source}" ]]; then
        PrintError "Source does not exist: ${source}"
        return 1
    fi

    if [[ -L "${link}" || -e "${link}" ]]; then
        PrintText "Overwriting existing link at: ${link}"
        ln -fs "${source}" "${link}"
    else
        PrintText "Creating symbolic link: ${link} points to ${source}"
        ln -s "${source}" "${link}"
    fi
}

# set flag to true after sourcing the entire file
COMMON_SH_SOURCED=1
