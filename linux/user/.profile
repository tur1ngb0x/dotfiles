#!/usr/bin/env bash

function set_shell {
    if [[ -f "${HOME}"/.bashrc ]]; then
        source "${HOME}"/.bashrc; fi
}

function set_xdg {
    XDG_CACHE_HOME="${HOME}/.cache"
    XDG_CONFIG_HOME="${HOME}/.config"
    XDG_DATA_HOME="${HOME}/.local/share"
    XDG_STATE_HOME="${HOME}/.local/state"
    export XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME
}

function set_fonts {
    unset FREETYPE_PROPERTIES
    FREETYPE_PROPERTIES=""
    FREETYPE_PROPERTIES+="autofitter:no-stem-darkening=0 "     # enable stem darkening for non-CFF fonts (e.g., TTF, TTC, bitmap fonts)
    FREETYPE_PROPERTIES+="cff:no-stem-darkening=0 "            # enable stem darkening for CFF fonts (e.g., OTF with PostScript outlines)
    FREETYPE_PROPERTIES+="autofitter:warping=0 "               # disable font warping for non-CFF fonts (e.g., TTF, TTC, bitmap fonts)
    FREETYPE_PROPERTIES+="truetype:interpreter-version=40"     # enable cleartype hinting for TTF, TTC fonts
    export FREETYPE_PROPERTIES
}

function set_qt {
    if [[ -f /usr/bin/qt5ct ]]; then
        QT_QPA_PLATFORMTHEME="qt5ct"; export QT_QPA_PLATFORMTHEME; fi
}

function main {
    set_shell
    set_xdg
    set_fonts
    set_qt
}

# begin script from here
main "${@}"
