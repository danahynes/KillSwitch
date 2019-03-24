#! /usr/bin/env bash

RESULT=$(dialog \
--backtitle "test" \
--title "title" \
--msgbox \
"this is some text" \
10 \
40 \
3>&1 1>&2 2>&3 3>&-)

BTN=$?

if [ $BTN -eq 0 ]; then
    echo "OK"
    RESULT=$(sudo ../Software/Bash/killswitch-install.sh | dialog \
    --backtitle "test" \
    --title "title" \
    --progressbox \
    "this is some text" \
    30 \
    60 \
    3>&1 1>&2 2>&3 3>&-)
fi
