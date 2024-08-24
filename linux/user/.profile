# shellcheck disable=SC2148,1091

# bash
if [[ -f "${HOME}"/.bashrc ]]; then source "${HOME}"/.bashrc; fi

# qt5ct
if [[ -f /usr/bin/qt5ct ]]; then QT_QPA_PLATFORMTHEME="qt5ct"; export QT_QPA_PLATFORMTHEME; fi

# fonts
#export FREETYPE_PROPERTIES="truetype:interpreter-version=40 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0 autofitter:warping=0"

# fonts
unset FREETYPE_PROPERTIES
FREETYPE_PROPERTIES=""
FREETYPE_PROPERTIES+="autofitter:no-stem-darkening=0 "     # enables stem darkening
FREETYPE_PROPERTIES+="autofitter:warping=0 "               # enable font warping
FREETYPE_PROPERTIES+="cff:no-stem-darkening=0 "            # enables stem darkening
FREETYPE_PROPERTIES+="truetype:interpreter-version=40"     # enables cleartype hinting
export FREETYPE_PROPERTIES
