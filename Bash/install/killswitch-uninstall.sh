#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# killswitch-uninstall.sh
# KillSwitch
#
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

VERSION_NUMBER="0.1"
VERSION_BUILD="19.01.07"

# check for root
if [ $EUID -ne 0 ]; then
   echo "This script must be run as root. Use 'sudo ./killswitch-uninstall.sh'" 
   exit 1
fi

echo "KillSwitch Uninstaller v${VERSION_NUMBER} (${VERSION_BUILD}) (c) 2019 \
Dana Hynes"
echo ""

echo "Uninstalling KillSwitch..."
echo ""

#-------------------------------------------------------------------------------
# remove files

# remove monitor script
echo -n "Removing killswitch_monitor.py from /usr/local/bin/... "
rm /usr/local/bin/killswitch_monitor.py
echo "Done"

# remove boot service script
echo -n "Removing killswitch-boot.service from /lib/systemd/system/... "
systemctl disable killswitch-boot.service
rm /lib/systemd/system/killswitch-boot.service
echo "Done"

# remove shutdown script
echo -n "Remove killswitch-shutdown.sh from /lib/systemd/systemd-shutdown... "
rm /lib/systemd/system-shutdown/killswitch-shutdown.sh
echo "Done"

# remove settings gui script
echo -n "Removing kilswitch-settings.sh from /usr/local/bin/... "
rm /usr/local/bin/killswitch-settings.sh
echo "Done"

# remove settings storage file
echo -n "Removing kilswitch-settings.conf from ${SETTINGS_DIR}... "
rm "${SETTINGS_FILE}"
echo "Done"

#-------------------------------------------------------------------------------
# finish up

if [ -d "/home/$(logname)/RetroPie" ]; then
	echo -n "Removing RetroPie port... "
	rm "/home/$(logname)/RetroPie/roms/ports/KillSwitch.sh"
	echo "Done"
fi

# stuff we can't undo
echo ""
echo "***************************************************"
echo ""
echo "The following dependencies may have been installed with KillSwitch:"
echo "dialog, python, python-gpiozero, python-serial, avrdude"
echo "You can remove them if you wish using apt-get"
echo ""
echo "If you wish to turn on the login console back on, you can use the \
retropie-setup script."

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
