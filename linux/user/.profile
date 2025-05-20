
set_shell () {
    if [ -n "${BASH_VERSION}" ] && [ -f "${HOME}/.bashrc" ]; then
        . "${HOME}"/.bashrc
    fi
}

set_xdg () {
    XDG_CACHE_HOME="${HOME}/.cache"
    XDG_CONFIG_HOME="${HOME}/.config"
    XDG_DATA_HOME="${HOME}/.local/share"
    XDG_STATE_HOME="${HOME}/.local/state"
    export XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME
}

set_fonts () {
    FREETYPE_PROPERTIES=""

	# stem darkening for non-CFF fonts (e.g., TTF, TTC, bitmap fonts)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}autofitter:no-stem-darkening=0 "
	# stem darkening for CFF fonts (e.g., OTF with PostScript outlines)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}cff:no-stem-darkening=0 "
	# font warping for non-CFF fonts (e.g., TTF, TTC, bitmap fonts)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}autofitter:warping=0 "
	# cleartype hinting for TTF, TTC fonts
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}truetype:interpreter-version=40"

    export FREETYPE_PROPERTIES
}

set_qtct() {
    if command -v qt6ct; then
        QT_QPA_PLATFORMTHEME="qt6ct"
	elif command -v qt5ct; then
		QT_QPA_PLATFORMTHEME="qt5ct"
	else
		QT_QPA_PLATFORMTHEME=""
    fi
	export QT_QPA_PLATFORMTHEME
}

main () {
    set_shell
    set_xdg
    set_fonts
    set_qtct
}

# begin script from here
main "${@}"
