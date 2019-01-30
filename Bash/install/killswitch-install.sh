#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# killswitch-install.sh
# KillSwitch
#
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

VERSION_NUMBER="0.1"
VERSION_BUILD="19.01.07"

# check for root
if [ $EUID -ne 0 ]; then
   echo "This script must be run as root. Use 'sudo ./killswitch-install.sh'"
   exit 1
fi

echo "KillSwitch Installer v${VERSION_NUMBER} (${VERSION_BUILD}) (c) 2019 Dana \
Hynes"
echo ""

echo "Installing dpendencies..."
apt-get install dialog python python-gpiozero python-serial avrdude
echo ""

echo "Installing KillSwitch..."
echo ""

echo "Setting up serial port..."

#-------------------------------------------------------------------------------
# reconfigure cmdline.txt for serial port

echo -n "Turning off login console... "

# filenames
cmd_file_old="/boot/cmdline.txt"
cmd_file_new="/boot/cmdline_tmp.txt"

# move everthing except login console to new file
echo $(cat < "$cmd_file_old") | sed 's/ console=.*,[0-9]*//' > "$cmd_file_new"

# move new file to old file
mv "$cmd_file_new" "$cmd_file_old"

echo "Done"

#-------------------------------------------------------------------------------
# reconfigure config.txt for serial port

echo -n "Turning on serial hardware... "

# filenames
config_file_old="/boot/config.txt"
config_file_new="/boot/config_tmp.txt"

# move everything except old enable_uart (if present) to new file
grep -v "enable_uart=" "$config_file_old" > "$config_file_new"

# add new enable_uart line
echo "enable_uart=1" >> "$config_file_new"

# move new file to old file
mv "$config_file_new" "$config_file_old"

echo "Done"

#-------------------------------------------------------------------------------
# shutdown

echo -n "Setting shutdown permissions... "

# filenames
config_file_old="/home/pi/.bash_aliases"
config_file_new="/home/pi/.bash_aliases_tmp"

# move everything except old shutdown (if present) to new file
grep -v "alias shutdown=" "$config_file_old" > "$config_file_new"

# add new shutdown line
echo "alias shutdown='sudo shutdown -h now'" >> "$config_file_new"

# move new file to old file
mv "$config_file_new" "$config_file_old"

echo "Done"

#-------------------------------------------------------------------------------
# reboot

echo -n "Setting reboot permissions... "

# filenames
config_file_old="/home/pi/.bash_aliases"
config_file_new="/home/pi/.bash_aliases_tmp"

# move everything except old reboot (if present) to new file
grep -v "alias reboot=" "$config_file_old" > "$config_file_new"

# add new reboot line
echo "alias reboot='sudo shutdown -r now'" >> "$config_file_new"

# move new file to old file
mv "$config_file_new" "$config_file_old"

echo "Done"

#-------------------------------------------------------------------------------
# finish permissions

echo -n "Finishing permissions... "

# pull in new bash aliases
source "/home/pi/.bash_aliases"

echo "Done"

#-------------------------------------------------------------------------------
# copy files

# copy monitor script
echo -n "Copying killswitch_monitor.py to /usr/local/bin/... "
cp ../services/killswitch_monitor.py /usr/local/bin/
chmod +x /usr/local/bin/killswitch_monitor.py
echo "Done"

# copy boot service script
echo -n "Copying killswitch-boot.service to /lib/systemd/system/... "
cp ../services/killswitch-boot.service /lib/systemd/system/
systemctl daemon-reload
systemctl enable killswitch-boot.service
echo "Done"

# copy shutdown script
echo -n "Copying killswitch-shutdown.sh to /lib/systemd/systemd-shutdown... "
cp ../services/killswitch-shutdown.sh /lib/systemd/system-shutdown/
chmod +x /lib/systemd/system-shutdown/killswitch-shutdown.sh
echo "Done"

# copy settings gui script
echo -n "Copying kilswitch-settings.sh to /usr/local/bin/... "
cp ../settings/killswitch-settings.sh /usr/local/bin/
chmod +x /usr/local/bin/killswitch-settings.sh
echo "Done"

# copy uninstaller script
echo -n "Copying killswitch-uninstall.sh to /usr/local/bin... "
cp killswitch-uninstall.sh /usr/local/bin
chmod +x /usr/local/bin/killswitch-uninstall.sh
echo "Done"

#-------------------------------------------------------------------------------
# configure avrdude

echo -n "Setting up avrdude..."

# avrdude conf file
AVRDUDE_CONF="/etc/avrdude.conf"

# check if already set up
grep "killswitch" "$AVRDUDE_CONF"
IS_SETUP=$?

if [ $IS_SETUP -ne 0 ]; then
    echo "programmer" >> "$AVRDUDE_CONF"
    echo "  id    = "\""killswitch"\"";" >> "$AVRDUDE_CONF"
    echo "  desc  = \"Update KillSwitch firmware using GPIO\";" >> \
    "$AVRDUDE_CONF"
    echo "  type  = \"linuxgpio\";" >> "$AVRDUDE_CONF"
    echo "  reset = 4;" >> "$AVRDUDE_CONF"
    echo "  sck   = 2;" >> "$AVRDUDE_CONF"
    echo "  mosi  = 14;" >> "$AVRDUDE_CONF"
    echo "  miso  = 15;" >> "$AVRDUDE_CONF"
fi

echo "Done"

#-------------------------------------------------------------------------------
# finish up

# create shortcut in RetroPie menu
if [ -d "/home/pi/RetroPie" ]; then
    echo -n "Creating RetroPie port... "
	mkdir -p "/home/pi/RetroPie/roms/ports"
	ln -s  "/usr/local/bin/killswitch-settings.sh" \
	    "/home/pi/RetroPie/roms/ports/KillSwitch.sh" &> /dev/null
	echo "Done"
fi

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
