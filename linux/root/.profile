# bash
if test -f "${HOME}"/.bashrc; then . "${HOME}"/.bashrc; fi

# qt5ct
if test -f /usr/bin/qt5ct; then export QT_QPA_PLATFORMTHEME="qt5ct"; fi
