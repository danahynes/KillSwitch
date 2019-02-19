#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# killswitch-install.sh
# KillSwitch
#
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# version

VERSION_NUMBER="0.2"
VERSION_BUILD="19.02.18"

#-------------------------------------------------------------------------------
# start

echo ""

#-------------------------------------------------------------------------------
# check for root

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root. Use 'sudo ./killswitch-install.sh'"
    echo ""
    exit 1
fi

#-------------------------------------------------------------------------------
# about

echo "KillSwitch Installer v${VERSION_NUMBER} (${VERSION_BUILD}) (c) 2019 Dana \
Hynes"
echo ""

#-------------------------------------------------------------------------------
# dependencies

echo "Installing dependencies..."
echo ""
apt-get install dialog python python-gpiozero python-serial avrdude
echo ""

#-------------------------------------------------------------------------------
# let's go!

echo "Installing KillSwitch..."
echo ""

#-------------------------------------------------------------------------------
# set up serial port
#
echo "Setting up serial port..."
echo ""

#-------------------------------------------------------------------------------
# reconfigure cmdline.txt for serial port

echo -n "Turning off login console... "

# filenames
CMD_FILE_OLD="/boot/cmdline.txt"
CMD_FILE_NEW="/boot/cmdline_tmp.txt"

# move everthing except login console to new file
echo $(cat < "${CMD_FILE_OLD}") | sed 's/ console=.*,[0-9]*//' > \
"${CMD_FILE_NEW}"

# move new file to old file
mv "${CMD_FILE_NEW}" "${CMD_FILE_OLD}"

echo "Done"

#-------------------------------------------------------------------------------
# reconfigure config.txt for serial port

echo -n "Turning on serial hardware... "

# filenames
CFG_FILE_OLD="/boot/config.txt"
CFG_FILE_NEW="/boot/config_tmp.txt"

# move everything except old enable_uart (if present) to new file
grep -v "enable_uart=" "${CFG_FILE_OLD}" > "${CFG_FILE_NEW}"

# add new enable_uart line
echo "enable_uart=1" >> "${CFG_FILE_NEW}"

# move new file to old file
mv "${CFG_FILE_NEW}" "${CFG_FILE_OLD}"

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# set permissions

echo "Setting up permissions..."
echo ""

#-------------------------------------------------------------------------------
# shutdown

echo -n "Setting shutdown permission... "

# filenames
CFG_FILE_OLD="/home/${SUDO_USER}/.bash_aliases"
CFG_FILE_NEW="/home/${SUDO_USER}/.bash_aliases_tmp"

# move everything except old shutdown (if present) to new file
grep -v "alias shutdown=" "${CFG_FILE_OLD}" > "${CFG_FILE_NEW}"

# add new shutdown line
echo "alias shutdown='sudo shutdown -h now'" >> "${CFG_FILE_NEW}"

# move new file to old file
mv "${CFG_FILE_NEW}" "${CFG_FILE_OLD}"

echo "Done"

#-------------------------------------------------------------------------------
# reboot

echo -n "Setting reboot permission... "

# filenames
CFG_FILE_OLD="/home/${SUDO_USER}/.bash_aliases"
CFG_FILE_NEW="/home/${SUDO_USER}/.bash_aliases_tmp"

# move everything except old reboot (if present) to new file
grep -v "alias reboot=" "${CFG_FILE_OLD}" > "${CFG_FILE_NEW}"

# add new reboot line
echo "alias reboot='sudo shutdown -r now'" >> "${CFG_FILE_NEW}"

# move new file to old file
mv "${CFG_FILE_NEW}" "${CFG_FILE_OLD}"

echo "Done"

#-------------------------------------------------------------------------------
# finish permissions

echo -n "Finishing permissions... "

# pull in new bash aliases
source "/home/${SUDO_USER}/.bash_aliases"

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# copy files

echo "Copying files..."
echo ""

# copy boot service script
echo -n "Copying killswitch-boot.service to /lib/systemd/system/... "
cp ../Services/killswitch-boot.service /lib/systemd/system/
systemctl enable killswitch-boot.service
echo "Done"

# copy boot script
echo -n "Copying killswitch-boot.py to /usr/local/bin/... "
cp ../Python/killswitch-boot.py /usr/local/bin/
chmod +x /usr/local/bin/killswitch-boot.py
echo "Done"

# copy shutodwn service script
echo -n "Copying killswitch-shutdown.service to /lib/systemd/system/... "
cp ../Services/killswitch-shutdown.service /lib/systemd/system/
systemctl enable killswitch-shutdown.service
echo "Done"

# copy shutdown script
echo -n "Copying killswitch-shutdown.py to /usr/local/bin/... "
cp ../Python/killswitch-shutdown.py /usr/local/bin/
chmod +x /usr/local/bin/killswitch-shutdown.py
echo "Done"

# copy settings gui script
echo -n "Copying kilswitch-settings.sh to /usr/local/bin/... "
cp killswitch-settings.sh /usr/local/bin/
chmod +x /usr/local/bin/killswitch-settings.sh
echo "Done"

# copy uninstaller script
echo -n "Copying killswitch-uninstall.sh to /usr/local/bin... "
cp killswitch-uninstall.sh /usr/local/bin
chmod +x /usr/local/bin/killswitch-uninstall.sh
echo "Done"

echo ""

#-------------------------------------------------------------------------------
# configure avrdude

echo -n "Setting up avrdude..."

# avrdude conf file
AVRDUDE_CONF="/etc/avrdude.conf"

# check if already set up
grep -q "killswitch" "${AVRDUDE_CONF}"
IS_SETUP=$?

if [ $IS_SETUP -ne 0 ]; then
    echo "programmer" >> "${AVRDUDE_CONF}"
    echo "  id    = \"killswitch\";" >> "${AVRDUDE_CONF}"
    echo "  desc  = \"Update KillSwitch firmware using GPIO\";" >> \
    "${AVRDUDE_CONF}"
    echo "  type  = \"linuxgpio\";" >> "${AVRDUDE_CONF}"
    echo "  reset = 4;" >> "${AVRDUDE_CONF}"
    echo "  sck   = 2;" >> "${AVRDUDE_CONF}"
    echo "  mosi  = 14;" >> "${AVRDUDE_CONF}"
    echo "  miso  = 15;" >> "${AVRDUDE_CONF}"
fi

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# add RetroPie port

# create shortcut in RetroPie menu
if [ -d "/home/${SUDO_USER}/RetroPie" ]; then
    echo -n "Creating RetroPie port... "
	mkdir -p "/home/${SUDO_USER}/RetroPie/roms/ports"
	ln -s  "/usr/local/bin/killswitch-settings.sh" \
	    "/home/${SUDO_USER}/RetroPie/roms/ports/KillSwitch.sh" &> /dev/null
	echo "Done"
    echo ""
fi

#-------------------------------------------------------------------------------
# ask for reboot
echo ""
echo "***************************************************"
echo ""
echo "You need to reboot the pi to complete installation."
read -p "Do you want to reboot now? (Y/n) [default=yes]" answer
case $answer in
    [Nn]* ) exit;;
        * ) shutdown -r now;;
esac

# -)