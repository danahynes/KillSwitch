#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# killswitch-install.sh
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
VERSION_NUMBER="0.1.42"
CHIP_ID="atmega328p"
SETTINGS_DIR="/home/${SUDO_USER}/.killswitch"
AVRDUDE_FILE="${SETTINGS_DIR}/killswitch-avrdude.conf"

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
check_error() {
    if [ "$?" != "0" ]; then
        echo "${1}"
        echo "Aborting install"

        # clean up (remove) any dirs created at this point (.killswitch)
        # and any copied files
        rm -rf "${SETTINGS_DIR}"

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
    echo "This script must be run as root. Try 'sudo ./killswitch-install.sh'"
    echo ""
    exit 1
fi

#-------------------------------------------------------------------------------
# About
#-------------------------------------------------------------------------------
echo "KillSwitch Installer v${VERSION_NUMBER} (c) 2019 Dana Hynes"
echo ""

#-------------------------------------------------------------------------------
# Do update/upgrade
#-------------------------------------------------------------------------------
echo "Running apt-get update..."
apt-get update

echo "Running apt-get upgrade..."
apt-get upgrade

#-------------------------------------------------------------------------------
# Dependencies
#-------------------------------------------------------------------------------
DEPS=(\
    avrdude \
    dialog \
    python3 \
    python3-gpiozero \  # only for reboot-test and shutdown-test
)

echo "Installing dependencies..."
echo ""

# build list of deps on one line
INSTALL_STR=""
for i in ${DEPS[@]}; do
    INSTALL_STR+="${i} "
done

# no quotes for no globbing (all deps are seperate params)
apt-get install $INSTALL_STR
check_error "Error installing dependencies"

# a little cleanup if needed
echo "Running apt-get autoremove..."
apt-get autoremove

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# Let's go!
#-------------------------------------------------------------------------------
echo "Installing KillSwitch..."
echo ""

#-------------------------------------------------------------------------------
# Set up serial port
#-------------------------------------------------------------------------------
echo "Setting up serial port..."
echo ""

#-------------------------------------------------------------------------------
# Reconfigure cmdline.txt for serial port
#-------------------------------------------------------------------------------
echo -n "Turning off login console... "

# filenames
CMD_FILE_OLD="/boot/cmdline.txt"
CMD_FILE_NEW="/boot/cmdline_tmp.txt"

# move everything except login console to new file
cat < "${CMD_FILE_OLD}" | sed 's/ console=.*,[0-9]*//' > "${CMD_FILE_NEW}"

# move new file to old file
mv "${CMD_FILE_NEW}" "${CMD_FILE_OLD}"
check_error "Failed"

echo "Done"

#-------------------------------------------------------------------------------
# Reconfigure config.txt for serial port
#-------------------------------------------------------------------------------
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
check_error "Failed"

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# Set permissions
#-------------------------------------------------------------------------------
# this is needed on RetroPie because we don't have permission to
# shutdown/reboot. Otherwise we would need to run killswitch-boot.py as sudo

echo "Setting up permissions..."
echo ""

#-------------------------------------------------------------------------------
# Shutdown
#-------------------------------------------------------------------------------
echo -n "Setting shutdown permission... "

# filenames
CFG_FILE_OLD="/home/${SUDO_USER}/.bash_aliases"
CFG_FILE_NEW="/home/${SUDO_USER}/.bash_aliases_tmp"

# move everything except old shutdown (if present) to new file
if [[ -f "${CFG_FILE_OLD}" ]]; then
    grep -v "alias shutdown=" "${CFG_FILE_OLD}" > "${CFG_FILE_NEW}"
fi

# add new shutdown line
echo "alias shutdown='sudo shutdown -h now'" >> "${CFG_FILE_NEW}"

# move new file to old file
mv "${CFG_FILE_NEW}" "${CFG_FILE_OLD}"
check_error "Failed"

echo "Done"

#-------------------------------------------------------------------------------
# Reboot
#-------------------------------------------------------------------------------
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
check_error "Failed"

echo "Done"

#-------------------------------------------------------------------------------
# Finish permissions
#-------------------------------------------------------------------------------
echo -n "Finishing permissions... "

# set owner of .bash_aliases
chown "${SUDO_USER}:${SUDO_USER}" "/home/${SUDO_USER}/.bash_aliases"
check_error "Failed"

# pull in new bash aliases
source "/home/${SUDO_USER}/.bash_aliases"

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# Copy files
#-------------------------------------------------------------------------------
echo "Copying files..."
echo ""

# copy boot service script
echo -n "Copying killswitch-boot.service to /lib/systemd/system/... "
cp ../Services/killswitch-boot.service /lib/systemd/system/
check_error "Failed"
systemctl enable killswitch-boot.service
check_error "Failed"
echo "Done"

# copy boot script
echo -n "Copying killswitch-boot.py to /usr/local/bin/... "
cp ../Python/killswitch-boot.py /usr/local/bin/
check_error "Failed"
chmod +x /usr/local/bin/killswitch-boot.py
check_error "Failed"
echo "Done"

# copy shutodwn service script
echo -n "Copying killswitch-shutdown.service to /lib/systemd/system/... "
sudo cp ../Services/killswitch-shutdown.service /lib/systemd/system/
check_error "Failed"
systemctl enable killswitch-shutdown.service
check_error "Failed"
echo "Done"

# copy shutdown script
echo -n "Copying killswitch-shutdown.py to /usr/local/bin/... "
cp ../Python/killswitch-shutdown.py /usr/local/bin/
check_error "Failed"
chmod +x /usr/local/bin/killswitch-shutdown.py
check_error "Failed"
echo "Done"

# copy settings gui script
echo -n "Copying killswitch-settings.sh to /usr/local/bin/... "
cp killswitch-settings.sh /usr/local/bin/
check_error "Failed"
chmod +x /usr/local/bin/killswitch-settings.sh
check_error "Failed"
echo "Done"
#
# # copy installer script
# echo -n "Copying killswitch-install.sh to /usr/local/bin/... "
# cp killswitch-install.sh /usr/local/bin/
# check_error "Failed"
# chmod +x /usr/local/bin/killswitch-install.sh
# check_error "Failed"
# echo "Done"

# copy retropie script
echo -n "Copying killswitch-install-retropie.sh to /usr/local/bin... "
cp killswitch-install-retropie.sh /usr/local/bin
check_error "Failed"
chmod +x /usr/local/bin/killswitch-install-retropie.sh
check_error "Failed"
echo "Done"
#
# # copy install-latest script
# echo -n "Copying killswitch-install-latest.sh to /usr/local/bin/... "
# cp ../../killswitch-install-latest.sh /usr/local/bin/
# check_error "Failed"
# chmod +x /usr/local/bin/killswitch-install-latest.sh
# check_error "Failed"
# echo "Done"

# copy uninstaller script
echo -n "Copying killswitch-uninstall.sh to /usr/local/bin... "
cp killswitch-uninstall.sh /usr/local/bin
check_error "Failed"
chmod +x /usr/local/bin/killswitch-uninstall.sh
check_error "Failed"
echo "Done"

# copy reboot test script
echo -n "Copying reboot-test.sh to /usr/local/bin... "
cp ../../Other/reboot-test.sh /usr/local/bin
check_error "Failed"
chmod +x /usr/local/bin/reboot-test.sh
check_error "Failed"
echo "Done"

# copy shutdown test script
echo -n "Copying shutdown-test.sh to /usr/local/bin... "
cp ../../Other/shutdown-test.sh /usr/local/bin
check_error "Failed"
chmod +x /usr/local/bin/shutdown-test.sh
check_error "Failed"
echo "Done"

echo ""

#-------------------------------------------------------------------------------
# Create settings dir
#-------------------------------------------------------------------------------
echo -n "Creating settings directory... "

if [ ! -d "${SETTINGS_DIR}" ]; then
    mkdir -p "${SETTINGS_DIR}"
    check_error "Failed"
    chown "${SUDO_USER}:${SUDO_USER}" "${SETTINGS_DIR}"
    check_error "Failed"
fi

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# Configure avrdude
#-------------------------------------------------------------------------------
echo -n "Setting up avrdude... "

# avrdude conf file
# rewrite no matter what in case pins change
if [ -f "${AVRDUDE_FILE}" ]; then
    rm "${AVRDUDE_FILE}"
    check_error "Failed"
fi
touch "${AVRDUDE_FILE}"
check_error "Failed"
chown "${SUDO_USER}" "${AVRDUDE_FILE}"
check_error "Failed"
AVRDUDE_TEXT="programmer\n"
AVRDUDE_TEXT+="  id    = \"killswitch\";\n"
AVRDUDE_TEXT+="  desc  = \"Update KillSwitch firmware using GPIO\";\n"
AVRDUDE_TEXT+="  type  = \"linuxgpio\";\n"
AVRDUDE_TEXT+="  reset = 4;\n"
AVRDUDE_TEXT+="  sck   = 2;\n"
AVRDUDE_TEXT+="  mosi  = 14;\n"
AVRDUDE_TEXT+="  miso  = 15;\n"
AVRDUDE_TEXT+=";\n"
echo -e "${AVRDUDE_TEXT}" > "${AVRDUDE_FILE}"

echo "Done"
echo ""

echo -n "Running firmware installer... "

# NB: do hardware first because software may cause reboot

# do avrdude update with hex file
cd ../../Firmware/
check_error "Failed"
FIRMWARE_FILE=$(find . -name "killswitch-firmware_*.hex")
check_error "Failed"
avrdude \
        -p "${CHIP_ID}" \
        -C +"${AVRDUDE_FILE}" \
        -c "killswitch" \
        -U flash:w:"${FIRMWARE_FILE}":i \
        -U flash:v:"${FIRMWARE_FILE}":i

# NB: don't return here if we can still try software update
# so don't use check_error
RES=$?
if [ $RES -ne 0 ]; then
    echo "Failed"
fi

#-------------------------------------------------------------------------------
# Add RetroPie menu entry
#-------------------------------------------------------------------------------
cd ../Software/Bash
killswitch-install-retropie.sh
check_error "Failed"

#-------------------------------------------------------------------------------
# Ask for reboot
#-------------------------------------------------------------------------------
echo "***************************************************"
echo ""
echo "You need to reboot the pi to complete installation."
read -p "Do you want to reboot now? (Y/n) [default=yes]" ANSWER
case "${ANSWER}" in
    [Nn]* ) exit 0;;
        * ) shutdown -r now;;
esac

# -)
