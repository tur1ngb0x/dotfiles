
function set_xdg () {
    XDG_CACHE_HOME="${HOME}/.cache";       command mkdir -p "${XDG_CACHE_HOME}";  builtin export XDG_CACHE_HOME
    XDG_CONFIG_HOME="${HOME}/.config";     command mkdir -p "${XDG_CONFIG_HOME}"; builtin export XDG_CONFIG_HOME
    XDG_DATA_HOME="${HOME}/.local/share";  command mkdir -p "${XDG_DATA_HOME}";   builtin export XDG_DATA_HOME
    XDG_STATE_HOME="${HOME}/.local/state"; command mkdir -p "${XDG_STATE_HOME}";  builtin export XDG_STATE_HOME

    XDG_APP_HOME="${HOME}/.apps";          command mkdir -p "${XDG_APP_HOME}";    builtin export XDG_APP_HOME
    XDG_BIN_HOME="${HOME}/.local/bin";     command mkdir -p "${XDG_BIN_HOME}";    builtin export XDG_BIN_HOME
}

function set_freetype () {
    FREETYPE_PROPERTIES=""
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}autofitter:no-stem-darkening=0 "     # stem darkening for non-CFF fonts (TTF, TTC, BMP)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}autofitter:warping=0 "               # font warping for non-CFF fonts (TTF, TTC, BMP)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}cff:no-stem-darkening=0 "            # stem darkening for CFF fonts (OTF)    
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}truetype:gray-strong-stem-widths=1 " # stem widths for TTF, TTC fonts
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}truetype:warping=0 "                 # font warping for for TTF, TTC fonts
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}truetype:interpreter-version=40"     # cleartype hinting for TTF, TTC fonts
    builtin export FREETYPE_PROPERTIES
}

function set_display () {
    [[ $# -ne 1 ]] && builtin printf 'usage: set_display <connector>\n' && builtin return
    local connector="${1}"
    if command -v xrandr &>/dev/null; then
        if command xrandr | grep -q "^${connector} connected"; then
			builtin printf 'Setting properties for %s\n' "${connector}"
            command xrandr --output "${connector}" --primary --size 1920x1080 --refresh 60 --dpi 96 --set 'Broadcast RGB' Full
        else
            builtin printf '%s not connected\n' "${connector}"
        fi
    else
        builtin printf 'xrandr not found in PATH\n'
    fi
}

function set_shell () {
    if [[ -f "${HOME}/.bashrc" ]]; then
        source "${HOME}/.bashrc"
    fi
}

function main () {
    set_xdg
    set_freetype
    set_display 'HDMI-1'
}

main "${@}"
