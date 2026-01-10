_profile_xdg () {
    XDG_CACHE_HOME="${HOME}/.cache";       /usr/bin/mkdir -p "${XDG_CACHE_HOME}";  export XDG_CACHE_HOME  # cache directory
    XDG_CONFIG_HOME="${HOME}/.config";     /usr/bin/mkdir -p "${XDG_CONFIG_HOME}"; export XDG_CONFIG_HOME # config directory
    XDG_DATA_HOME="${HOME}/.local/share";  /usr/bin/mkdir -p "${XDG_DATA_HOME}";   export XDG_DATA_HOME   # data directory
    XDG_STATE_HOME="${HOME}/.local/state"; /usr/bin/mkdir -p "${XDG_STATE_HOME}";  export XDG_STATE_HOME  # state directory
    XDG_APP_HOME="${HOME}/.apps";          /usr/bin/mkdir -p "${XDG_APP_HOME}";    export XDG_APP_HOME    # apps gui directory
    XDG_BIN_HOME="${HOME}/.local/bin";     /usr/bin/mkdir -p "${XDG_BIN_HOME}";    export XDG_BIN_HOME    # apps cli directory
}

_profile_freetype () {
    FREETYPE_PROPERTIES=""
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}autofitter:no-stem-darkening=0 "     # stem darkening for non-CFF fonts (TTF, TTC, BMP)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}autofitter:warping=0 "               # font warping for non-CFF fonts (TTF, TTC, BMP)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}cff:no-stem-darkening=0 "            # stem darkening for CFF fonts (OTF)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}truetype:gray-strong-stem-widths=1 " # stem widths for TTF, TTC fonts
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}truetype:warping=0 "                 # font warping for for TTF, TTC fonts
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}truetype:interpreter-version=40"     # cleartype hinting for TTF, TTC fonts
    export FREETYPE_PROPERTIES
}

_profile_bash () {
    if [ -n "$BASH_VERSION" ] && [ -f "${HOME}/.bashrc" ]; then
        . "${HOME}/.bashrc"
    fi
}

main() {
    _profile_xdg
    #_profile_freetype
    _profile_bash
}

main "${@}" >/dev/null 2>&1
