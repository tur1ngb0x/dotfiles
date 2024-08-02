# shellcheck disable=SC2148,1091

# bash
if [[ -f "${HOME}"/.bashrc ]]; then source "${HOME}"/.bashrc; fi

# qt5ct
if [[ -f /usr/bin/qt5ct ]]; then export QT_QPA_PLATFORMTHEME="qt5ct"; fi
