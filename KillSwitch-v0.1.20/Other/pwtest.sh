#! /usr/bin/env bash

PWD_DONE=0

function doPassword() {
    PWD_RESULT=$(dialog \
    --backtitle "password" \
    --title "password" \
    --passwordbox \
    "Enter the root password:" \
    10 \
    40 \
    3>&1 1>&2 2>&3 3>&-)

    PWD_BTN=$?

    echo "${PWD_RESULT}"

    cd /home/dana/Documents/Git/KillSwitch/Software/Bash/
    echo -e "${PWD_RESULT}\n" | sudo -S 
    PWD_DONE=1
}

while [ "${PWD_DONE}" -eq 0 ]; do
    doPassword
done
