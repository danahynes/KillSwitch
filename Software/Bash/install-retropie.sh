#!/usr/bin/env bash

#-------------------------------------------------------------------------------
# install-retropie.py
# KillSwitch
#
# Copyright © 2019 Dana Hynes <danahynes@gmail.com>
# This work is free. You can redistribute it and/or modify it under the terms
# of the Do What The Fuck You Want To Public License, Version 2, as published
# by Sam Hocevar. See the LICENSE file for more details.
#-------------------------------------------------------------------------------

VERSION_NUMBER="0.1.23"


#-------------------------------------------------------------------------------
# Add RetroPie menu entry
#-------------------------------------------------------------------------------
# create shortcut in RetroPie menu
RETROPIE_DATA_DIR="/home/${SUDO_USER}/RetroPie"
if [ -d "${RETROPIE_DATA_DIR}" ]; then
    echo -n "Creating RetroPie menu entry... "

    RETROPIE_MENU_DIR="${RETROPIE_DATA_DIR}/retropiemenu"
    RETROPIE_CONFIG_DIR=\
"/opt/retropie/configs/all/emulationstation/gamelists/retropie"
    GAMELIST_XML="${RETROPIE_MENU_DIR}/gamelist.xml"

    # link the installed file to the menu
    ln -sf "/usr/local/bin/killswitch-settings.sh" \
"${RETROPIE_MENU_DIR}/killswitch-settings.sh" &> /dev/null
    check_error "Failed"

    # copy menu icon
    cp ../../Pics/killswitch.png "${RETROPIE_MENU_DIR}/icons"

    cp -nv "${RETROPIE_CONFIG_DIR}/gamelist.xml" "${GAMELIST_XML}"
    if ! grep -q "<path>./killswitch-settings.sh</path>" "${GAMELIST_XML}"
    then
        xmlstarlet ed -L -P -s "/gameList" -t elem -n "gameTMP" \
            -s "//gameTMP" -t elem -n path -v "./killswitch-settings.sh" \
            -s "//gameTMP" -t elem -n name -v "KillSwitch Settings" \
            -s "//gameTMP" -t elem -n desc -v "Turn your RetroPie on and off \
using an infrared remote" \
            -s "//gameTMP" -t elem -n image -v "./icons/killswitch.png" \
            -r "//gameTMP" -v "game" \
            "${GAMELIST_XML}"

        # XXX: I don't know why the -P (preserve original formatting) isn't
        # working, the new xml elements for killswitch are all in only one line.
        # So let's format gamelist.xml.
        TMP_XML=$(mktemp)
        xmlstarlet fo -t "${GAMELIST_XML}" > "${TMP_XML}"
        cat "${TMP_XML}" > "${GAMELIST_XML}"
        rm -f "${TMP_XML}"
    fi

    # needed for proper permissions for gamelist.xml and icons/killswitch.png
    chown -R ${SUDO_USER}:${SUDO_USER} "${RETROPIE_MENU_DIR}"

    echo "Done"
    echo ""
fi
