#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# killswitch-uninstall.sh
# KillSwitch
#
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# constants

VERSION_NUMBER="0.3.4"
SETTINGS_DIR="/home/${SUDO_USER}/.killswitch"

#-------------------------------------------------------------------------------
# start

echo ""

#-------------------------------------------------------------------------------
# check for root

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root. Use 'sudo killswitch-uninstall.sh'"
    echo ""
    exit 1
fi

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
rm /lib/systemd/system/killswitch-boot.service
echo "Done"

# remove monitor script
echo -n "Removing killswitch-boot.py from /usr/local/bin/... "
rm /usr/local/bin/killswitch-boot.py
echo "Done"

# remove shutodwn service script
echo -n "Removing killswitch-shutdown.service from /lib/systemd/system/... "
systemctl disable killswitch-shutdown.service
rm /lib/systemd/system/killswitch-shutdown.service
echo "Done"

# remove shutdown script
echo -n "Removing killswitch-shutdown.py from /usr/local/bin... "
rm /usr/local/bin/killswitch-shutdown.py
echo "Done"

# remove settings gui script
echo -n "Removing kilswitch-settings.sh from /usr/local/bin/... "
rm /usr/local/bin/killswitch-settings.sh
echo "Done"

# remove uninstaller script
echo -n "Removing kilswitch-uninstaller.sh from /usr/local/bin/... "
rm /usr/local/bin/killswitch-uninstall.sh
echo "Done"

# remove settings storage dir
if [ -d "$SETTINGS_DIR" ]; then
    echo -n "Removing ${SETTINGS_DIR}... "
    rm -r "${SETTINGS_DIR}"
    echo "Done"
fi

echo ""

#-------------------------------------------------------------------------------
# remove RetroPie port

if [ -d "/home/${SUDO_USER}/RetroPie" ]; then
	echo -n "Removing RetroPie port... "
	rm "/home/${SUDO_USER}/RetroPie/roms/ports/KillSwitch.sh"
	echo "Done"
    echo ""
fi

#-------------------------------------------------------------------------------
# stuff we can't undo
echo ""
echo "***************************************************"
echo ""
echo "The following dependencies may have been installed with KillSwitch:"
echo "dialog, python, python-gpiozero, python-serial, avrdude"
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
read -p "Do you want to reboot now? (Y/n) [default=yes]" answer
case $answer in
    [Nn]* ) exit;;
        * ) shutdown -r now;;
esac

# -)
