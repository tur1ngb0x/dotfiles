# bash
if test -n "${BASH_VERSION}" && test -f "${HOME}"/.bashrc; then . "${HOME}"/.bashrc; fi

# qt5ct
if test -f /usr/bin/qt5ct; then export QT_QPA_PLATFORMTHEME="qt5ct"; fi

# xsession-errors
if grep -q 'ERRFILE=$HOME/.xsession-errors' /etc/X11/Xsession; then export ERRFILE=/tmp/xsession-errors.log; fi
