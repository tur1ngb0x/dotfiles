# bash
if test -n "${BASH_VERSION}" && test -f "${HOME}"/.bashrc; then . "${HOME}"/.bashrc; fi

# qt5ct
if test -f /usr/bin/qt5ct; then export QT_QPA_PLATFORMTHEME="qt5ct"; fi

# $HOME/.xsession-errors fix
export ERRFILE="/tmp/xsession-errors.log"; fi
