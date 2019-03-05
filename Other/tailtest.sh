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
    RESULT=$(dialog \
    --backtitle "test" \
    --title "title" \
    --prgbox \
    "this is some text" \
    "echo foo" \
    40 \
    40 \
    3>&1 1>&2 2>&3 3>&-)
fi
