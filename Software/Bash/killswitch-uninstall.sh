#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# killswitch-uninstall.sh
# KillSwitch
#
# Copyright © 2019 Dana Hynes <danahynes@gmail.com>
# This work is free. You can redistribute it and/or modify it under the terms
# of the Do What The Fuck You Want To Public License, Version 2, as published
# by Sam Hocevar. See the LICENSE file for more details.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Constants
#-------------------------------------------------------------------------------
VERSION_NUMBER="0.1.37"
SETTINGS_DIR="/home/${SUDO_USER}/.killswitch"

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
check_error() {
    if [ "$?" != "0" ]; then
        echo "${1}"
        echo "Aborting uninstall"
        exit 1
    fi
}

#-------------------------------------------------------------------------------
# Start
#-------------------------------------------------------------------------------
echo ""

#-------------------------------------------------------------------------------
# Check for root
#-------------------------------------------------------------------------------
if [ $EUID -ne 0 ]; then
    echo "This script must be run as root. Try 'sudo killswitch-uninstall.sh'"
    echo ""
    exit 1
fi

#-------------------------------------------------------------------------------
# About
#-------------------------------------------------------------------------------
echo "KillSwitch Uninstaller v${VERSION_NUMBER} (c) 2019 Dana Hynes"
echo ""

#-------------------------------------------------------------------------------
# Let's go!
#-------------------------------------------------------------------------------
echo "Uninstalling KillSwitch..."
echo ""

#-------------------------------------------------------------------------------
# Remove files
#-------------------------------------------------------------------------------
echo "Removing files..."
echo ""

# remove boot service script
echo -n "Removing killswitch-boot.service from /lib/systemd/system/... "
systemctl disable killswitch-boot.service
check_error "Failed"
rm /lib/systemd/system/killswitch-boot.service
check_error "Failed"
echo "Done"

# remove boot script
echo -n "Removing killswitch-boot.py from /usr/local/bin/... "
rm /usr/local/bin/killswitch-boot.py
check_error "Failed"
echo "Done"

# remove shutdown service script
echo -n "Removing killswitch-shutdown.service from /lib/systemd/system/... "
systemctl disable killswitch-shutdown.service
check_error "Failed"
rm /lib/systemd/system/killswitch-shutdown.service
check_error "Failed"
echo "Done"

# remove shutdown script
echo -n "Removing killswitch-shutdown.py from /usr/local/bin... "
rm /usr/local/bin/killswitch-shutdown.py
check_error "Failed"
echo "Done"

# remove settings gui script
echo -n "Removing killswitch-settings.sh from /usr/local/bin/... "
rm /usr/local/bin/killswitch-settings.sh
check_error "Failed"
echo "Done"

# remove install script
echo -n "Removing killswitch-install.sh from /usr/local/bin/... "
rm /usr/local/bin/killswitch-install.sh
check_error "Failed"
echo "Done"

# remove retropie install script
echo -n "Removing killswitch-install-retropie.sh from /usr/local/bin/... "
rm /usr/local/bin/killswitch-install-retropie.sh
check_error "Failed"
echo "Done"

# remove install-latest script
echo -n "Removing killswitch-install-latest.sh from /usr/local/bin/... "
rm /usr/local/bin/killswitch-install-latest.sh
check_error "Failed"
echo "Done"

# remove uninstall script
echo -n "Removing killswitch-uninstall.sh from /usr/local/bin/... "
rm /usr/local/bin/killswitch-uninstall.sh
check_error "Failed"
echo "Done"

# remove reboot test script
echo -n "Removing reboot-test.sh from /usr/local/bin/... "
rm /usr/local/bin/reboot-test.sh
check_error "Failed"
echo "Done"

# remove shutdown test script
echo -n "Removing shutdown-test.sh from /usr/local/bin/... "
rm /usr/local/bin/shutdown-test.sh
check_error "Failed"
echo "Done"

#-------------------------------------------------------------------------------
# Remove settings dir
#-------------------------------------------------------------------------------
echo -n "Removing settings directory... "

if [ -d "${SETTINGS_DIR}" ]; then
    rm -r "${SETTINGS_DIR}"
    check_error "Failed"
fi

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# Remove RetroPie menu entry
#-------------------------------------------------------------------------------
# remove shortcut from RetroPie menu
RETROPIE_DATA_DIR="/home/${SUDO_USER}/RetroPie"
if [ -d "${RETROPIE_DATA_DIR}" ]; then
    echo -n "Removing RetroPie menu entry... "

    RETROPIE_MENU_DIR="${RETROPIE_DATA_DIR}/retropiemenu"
    RETROPIE_CONFIG_DIR=\
"/opt/retropie/configs/all/emulationstation/gamelists/retropie"
    GAMELIST_XML="${RETROPIE_MENU_DIR}/gamelist.xml"

    # remove link to menu
    rm -f "${RETROPIE_MENU_DIR}/killswitch-settings.sh"
    check_error "Failed"

    # delete icon
    rm "${RETROPIE_MENU_DIR}/icons/killswitch.png"
    check_error "Failed"

    # delete menu entry
    xmlstarlet ed -P -L -d \
"/gameList/game[contains(path,'killswitch-settings.sh')]" "${GAMELIST_XML}"
    check_error "Failed"

    echo "Done"
    echo ""
fi

#-------------------------------------------------------------------------------
# Stuff we can't undo
#-------------------------------------------------------------------------------
echo "***************************************************"
echo ""
echo "The following dependencies may have been installed with KillSwitch:"
echo "avrdude, dialog, python3"
echo "You can remove them using apt-get."
echo ""
echo "If you want to turn the login console back on, you can use the "
echo "raspi-config script."

#-------------------------------------------------------------------------------
# Ask for reboot
#-------------------------------------------------------------------------------
echo ""
echo "***************************************************"
echo ""
echo "You need to reboot the pi to complete uninstallation."
read -p "Do you want to reboot now? (Y/n) [default=yes]" ANSWER
case "${ANSWER}" in
    [Nn]* ) exit 0;;
        * ) shutdown -r now;;
esac

# -)
