#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# make-release.sh
# KillSwitch
#
# Copyright © 2019 Dana Hynes <danahynes@gmail.com>
# This work is free. You can redistribute it and/or modify it under the terms
# of the Do What The Fuck You Want To Public License, Version 2, as published
# by Sam Hocevar. See the LICENSE file for more details.
#-------------------------------------------------------------------------------

VERSION_NUMBER="0.4.5"

# change firmware
cd ../Firmware/

FILE="src/KillSwitch.cpp"
REP=$(cat "${FILE}" | sed 's/VERSION_NUMBER\[] PROGMEM = "[0-9]*\+.[0-9]*\+.[0-9]*"/VERSION_NUMBER\[] PROGMEM = "'${VERSION_NUMBER}'"/')
echo "${REP}" > "${FILE}"

# change hardware
cd ../Hardware/
DATE=`date +%Y-%m-%d`

FILE="killswitch_84.sch"
REP=$(cat "${FILE}" | sed 's/Date "[0-9]*\+-[0-9]*\+-[0-9]*"/Date "'${DATE}'"/')
REP=$(echo "${REP}" | sed 's/Rev "[0-9]*\+.[0-9]*\+.[0-9]*"/Rev "'${VERSION_NUMBER}'"/')
echo "${REP}" > "${FILE}"

FILE="killswitch_84.kicad_pcb"
REP=$(cat "${FILE}" | sed 's/(date [0-9]*\+-[0-9]*\+-[0-9]*)/(date '${DATE}')/')
REP=$(echo "${REP}" | sed 's/(rev [0-9]*\+.[0-9]*\+.[0-9]*)/(rev '${VERSION_NUMBER}')/')
REP=$(echo "${REP}" | sed 's/(gr_text "KillSwitch\\nv[0-9]*\+.[0-9]*\+.[0-9]*"/(gr_text "KillSwitch\\nv'${VERSION_NUMBER}'"/')
echo "${REP}" > "${FILE}"

# change software
cd ../Software/
cd Bash/

FILE="killswitch-install.sh"
REP=$(cat "${FILE}" | sed 's/VERSION_NUMBER="[0-9]*\+.[0-9]*\+.[0-9]*"/VERSION_NUMBER="'${VERSION_NUMBER}'"/')
echo "${REP}" >"${FILE}"

FILE="killswitch-settings.sh"
REP=$(cat "${FILE}" | sed 's/VERSION_NUMBER="[0-9]*\+.[0-9]*\+.[0-9]*"/VERSION_NUMBER="'${VERSION_NUMBER}'"/')
echo "${REP}" > "${FILE}"

FILE="killswitch-uninstall.sh"
REP=$(cat "${FILE}" | sed 's/VERSION_NUMBER="[0-9]*\+.[0-9]*\+.[0-9]*"/VERSION_NUMBER="'${VERSION_NUMBER}'"/')
echo "${REP}" > "${FILE}"

cd ../Python/

FILE="killswitch-boot.py"
REP=$(cat "${FILE}" | sed 's/VERSION_NUMBER = "[0-9]*\+.[0-9]*\+.[0-9]*"/VERSION_NUMBER = "'${VERSION_NUMBER}'"/')
echo "${REP}" > "${FILE}"

FILE="killswitch-settings.py"
REP=$(cat "${FILE}" | sed 's/VERSION_NUMBER = "[0-9]*\+.[0-9]*\+.[0-9]*"/VERSION_NUMBER = "'${VERSION_NUMBER}'"/')
echo "${REP}" > "${FILE}"

FILE="killswitch-shutdown.py"
REP=$(cat "${FILE}" | sed 's/VERSION_NUMBER = "[0-9]*\+.[0-9]*\+.[0-9]*"/VERSION_NUMBER = "'${VERSION_NUMBER}'"/')
echo "${REP}" > "${FILE}"

cd ../Services/

FILE="killswitch-boot.service"
REP=$(cat "${FILE}" | sed 's/VERSION_NUMBER = [0-9]*\+.[0-9]*\+.[0-9]*/VERSION_NUMBER = '${VERSION_NUMBER}'/')
echo "${REP}" > "${FILE}"

FILE="killswitch-shutdown.service"
REP=$(cat "${FILE}" | sed 's/VERSION_NUMBER = [0-9]*\+.[0-9]*\+.[0-9]*/VERSION_NUMBER = '${VERSION_NUMBER}'/')
echo "${REP}" > "${FILE}"

#-------------------------------------------------------------------------------
# build firmware

cd ../../Firmware
pio run

#-------------------------------------------------------------------------------
# move hex file

# delete old file
OLD_NAME=$(find . -name "killswitch-firmware_*.hex")
rm "${OLD_NAME}" > /dev/null 2>&1

# get to the build dir
cd .pioenvs/uno/

# copy the file and add the numbers
cp firmware.hex "../../killswitch-firmware_${VERSION_NUMBER}.hex"
