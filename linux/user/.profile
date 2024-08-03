# shellcheck disable=SC2148,1091

# bash
if [[ -f "${HOME}"/.bashrc ]]; then source "${HOME}"/.bashrc; fi

# qt5ct
if [[ -f /usr/bin/qt5ct ]]; then export QT_QPA_PLATFORMTHEME="qt5ct"; fi

# fonts
export FREETYPE_PROPERTIES="truetype:interpreter-version=40 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0 autofitter:warping=0"
