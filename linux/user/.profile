# bash
if [[ -f "${HOME}"/.bashrc ]]; then source "${HOME}"/.bashrc; fi

# qt5ct
if [[ -f /usr/bin/qt5ct ]]; then QT_QPA_PLATFORMTHEME="qt5ct"; export QT_QPA_PLATFORMTHEME; fi

# fonts
unset FREETYPE_PROPERTIES
FREETYPE_PROPERTIES=""
FREETYPE_PROPERTIES+="autofitter:no-stem-darkening=0 "     # enables stem darkening
FREETYPE_PROPERTIES+="autofitter:warping=0 "               # enable font warping
FREETYPE_PROPERTIES+="cff:no-stem-darkening=0 "            # enables stem darkening
FREETYPE_PROPERTIES+="truetype:interpreter-version=40"     # enables cleartype hinting
export FREETYPE_PROPERTIES

# starship
STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
export STARSHIP_CONFIG

# xdg
XDG_CACHE_HOME="${HOME}/.cache"
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME
