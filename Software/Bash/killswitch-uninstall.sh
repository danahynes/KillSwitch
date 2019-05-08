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
# constants

VERSION_NUMBER="0.5.20"
SETTINGS_DIR="/home/${SUDO_USER}/.killswitch"

#-------------------------------------------------------------------------------
# helpers

check_error() {
    if [ "$?" != "0" ]; then
        echo "${1}"
        echo "Aborting uninstall"
        exit 1
    fi
}

#-------------------------------------------------------------------------------
# start

echo ""

#-------------------------------------------------------------------------------
# check for root

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root. Try 'sudo killswitch-uninstall.sh'"
    echo ""
    exit 1
fi

#-------------------------------------------------------------------------------
# set working dir
cd ${0%/*}

#-------------------------------------------------------------------------------
# about

echo "KillSwitch Uninstaller v${VERSION_NUMBER} (c) 2019 Dana Hynes"
echo ""

#-------------------------------------------------------------------------------
# let's go!

echo "Uninstalling KillSwitch..."
echo ""

#-------------------------------------------------------------------------------
# remove files

echo "Removing files..."
echo ""

# remove boot service script
echo -n "Removing killswitch-boot.service from /lib/systemd/system/... "
systemctl disable killswitch-boot.service
check_error "Failed"
rm /lib/systemd/system/killswitch-boot.service
check_error "Failed"
echo "Done"

# remove monitor script
echo -n "Removing killswitch-boot.py from /usr/local/bin/... "
rm /usr/local/bin/killswitch-boot.py
check_error "Failed"
echo "Done"

# remove shutodwn service script
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
echo -n "Removing kilswitch-settings.py from /usr/local/bin/... "
rm /usr/local/bin/killswitch-settings.py
check_error "Failed"
echo "Done"

# remove uninstaller script
echo -n "Removing kilswitch-uninstaller.sh from /usr/local/bin/... "
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

# remove settings storage dir
if [ -d "$SETTINGS_DIR" ]; then
    echo -n "Removing ${SETTINGS_DIR}... "
    rm -r "${SETTINGS_DIR}"
    check_error "Failed"
    echo "Done"
fi

echo ""

#-------------------------------------------------------------------------------
# remove RetroPie port

# if [ -d "/home/${SUDO_USER}/RetroPie" ]; then
# 	echo -n "Removing RetroPie port... "
# 	rm "/home/${SUDO_USER}/RetroPie/roms/ports/KillSwitch"
#     check_error "Failed"
# 	echo "Done"
#     echo ""
# fi

#-------------------------------------------------------------------------------
# stuff we can't undo

echo "***************************************************"
echo ""
echo "The following dependencies may have been installed with KillSwitch:"
echo "python3, python3-dialog, python3-gpiozero, python3-requests, \
python3-serial, avrdude"
echo "You can remove them if you wish using apt-get."
echo ""
echo "If you wish to turn the login console back on, you can use the "
echo "raspi-setup script."

#-------------------------------------------------------------------------------
# ask for reboot
echo ""
echo "***************************************************"
echo ""
echo "You need to reboot the pi to complete uninstallation."
read -p "Do you want to reboot now? (Y/n) [default=yes]" ANSWER
case "${ANSWER}" in
    [Nn]* ) exit;;
        * ) shutdown -r now;;
esac

# -)
