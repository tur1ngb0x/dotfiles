# SHELL
set_shell() {
    if [ -n "${BASH_VERSION}" ] && [ -f "${HOME}/.bashrc" ]; then
        . "${HOME}/.bashrc"
    fi
}

# XDG
set_xdg() {
    XDG_CACHE_HOME="${HOME}/.cache";       export XDG_CACHE_HOME
    XDG_CONFIG_HOME="${HOME}/.config";     export XDG_CONFIG_HOME
    XDG_DATA_HOME="${HOME}/.local/share";  export XDG_DATA_HOME
    XDG_STATE_HOME="${HOME}/.local/state"; export XDG_STATE_HOME
}

#PATH
set_path() {
    PATH="${HOME}/src/adb:${PATH}"
    PATH="${HOME}/.local/bin:${PATH}"
    PATH="${HOME}/scripts/linux:${PATH}"
    PATH="${HOME}/src/scripts/linux:${PATH}"
    PATH="$(printf '%s' "${PATH}" | awk -v RS=: -v ORS= '!a[$0]++ {if (NR>1) printf(":"); printf("%s", $0) }')"; export PATH
}

# VARIABLES
set_variables() {
    CLICOLOR='1';                                    export CLICOLOR
    COLORTERM='truecolor';                           export COLORTERM
    VISUAL='micro';                                  export VISUAL
    EDITOR="${VISUAL}";                              export EDITOR
    MANPAGER='most -s -t4 -w';                       export MANPAGER
    PAGER="${MANPAGER}";                             export PAGER
    HISTFILE="${XDG_DATA_HOME}/bash_history";        export HISTFILE
    HISTCONTROL='ignorespace:ignoredups:erasedups';  export HISTCONTROL
    HISTFILESIZE='10000';                            export HISTFILESIZE
    HISTSIZE='2000';                                 export HISTSIZE
    HISTTIMEFORMAT='%Y-%m-%d %a %H:%M:%S  ';         export HISTTIMEFORMAT
}

# FONTS
set_fonts () {
    FREETYPE_PROPERTIES=""
    # stem darkening for non-CFF fonts (TTF, TTC, BMP)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}autofitter:no-stem-darkening=0 "
    # font warping for non-CFF fonts (TTF, TTC, BMP)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}autofitter:warping=0 "
    # stem darkening for CFF fonts (OTF)
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}cff:no-stem-darkening=0 "
    # stem widths for TTF, TTC fonts
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}truetype:gray-strong-stem-widths=1 "
    # font warping for for TTF, TTC fonts
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}truetype:warping=0 "
    # cleartype hinting for TTF, TTC fonts
    FREETYPE_PROPERTIES="${FREETYPE_PROPERTIES}truetype:interpreter-version=40"
    export FREETYPE_PROPERTIES
}

# QTCT
set_qtct() {
    local QTCT=""
    if command -v qt6ct; then
        QTCT="qt6ct"
    elif command -v qt5ct; then
        QTCT="qt5ct"
    fi
    if [ -n "${QTCT}" ]; then
        QT_QPA_PLATFORMTHEME="${QTCT}"
        export QT_QPA_PLATFORMTHEME
    fi
}

# DISPLAY
set_display() {
    if command -v xrandr; then
        xrandr --output 'HDMI-1' --primary --set 'Broadcast RGB' 'Full' --size '1920x1080' --refresh '60' --dpi '96'
    fi
}

# MAIN
main () {
    set_shell
    set_xdg
    set_path
    set_variables
    #set_fonts
    set_qtct
    set_display
}

# BEGIN
main "${@}" &> /dev/null
