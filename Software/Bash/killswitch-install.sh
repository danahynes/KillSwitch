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
# constants

VERSION_NUMBER="0.5.16"
SETTINGS_DIR="/home/${SUDO_USER}/.killswitch"

#-------------------------------------------------------------------------------
# helpers

check_error() {
    if [ "$?" != "0" ]; then
        echo "${1}"
        echo "Aborting install"

        # TODO: clean up (remove) any dirs created at this point (.killswitch)
        # and any copied files

        exit 1
    fi
}

#-------------------------------------------------------------------------------
# start

echo ""

#-------------------------------------------------------------------------------
# check for root

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root. Try 'sudo ./killswitch-install.sh'"
    echo ""
    exit 1
fi

#-------------------------------------------------------------------------------
# set working dir
cd ${0%/*}

#-------------------------------------------------------------------------------
# about

echo "KillSwitch Installer v${VERSION_NUMBER} (c) 2019 Dana Hynes"
echo ""

#-------------------------------------------------------------------------------
# dependencies

DEPS=(\
    avrdude \
    python3 \
    python3-dialog \
    python3-gpiozero \
    python3-requests \
    python3-serial \
)

# echo "Checking dependencies..."
# echo ""
#
# # TODO: if no python3-dialog, need "pip3 install pythondialog" (on laptop)
#
# for i in ${DEPS[@]}; do
#     echo -n "Searching for ${i}... "
#     RES=$(apt-cache search "^${i}$")
#     if [ "$RES" != "" ]; then
#         echo "Found"
#     else
#         echo "Not found"
#         echo "Aborting install"
#         exit 1
#     fi
# done
#
# echo ""

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
apt-get autoremove

echo "Done"
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

# move everything except login console to new file
cat < "${CMD_FILE_OLD}" | sed 's/ console=.*,[0-9]*//' > "${CMD_FILE_NEW}"

# move new file to old file
mv "${CMD_FILE_NEW}" "${CMD_FILE_OLD}"
check_error "Failed"

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
check_error "Failed"

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# set permissions

# this is needed on RetroPie because we don't have permission to
# shutdown/reboot. otherwise we would need to run killswitch-boot.py as sudo

echo "Setting up permissions..."
echo ""

#-------------------------------------------------------------------------------
# shutdown

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
check_error "Failed"
systemctl enable killswitch-boot.service > /dev/null 2>&1
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
cp ../Services/killswitch-shutdown.service /lib/systemd/system/
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
echo -n "Copying kilswitch-settings.py to /usr/local/bin/... "
cp ../Python/killswitch-settings.py /usr/local/bin/
check_error "Failed"
chmod +x /usr/local/bin/killswitch-settings.py
check_error "Failed"
echo "Done"

# copy uninstaller script
echo -n "Copying killswitch-uninstall.sh to /usr/local/bin... "
cp killswitch-uninstall.sh /usr/local/bin
check_error "Failed"
chmod +x /usr/local/bin/killswitch-uninstall.sh
check_error "Failed"
echo "Done"

echo ""

#-------------------------------------------------------------------------------
# (re)create settings dir

echo -n "Creating settings directory... "

if [ ! -d "${SETTINGS_DIR}" ]; then
    mkdir -p "${SETTINGS_DIR}"
    check_error "Failed"
    chown "${SUDO_USER}" "${SETTINGS_DIR}"
    check_error "Failed"
fi

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# configure avrdude

echo -n "Setting up avrdude... "

# avrdude conf file
# rewrite no matter what in case pins change
AVRDUDE_CONF="${SETTINGS_DIR}/killswitch-avrdude.conf"
rm "${AVRDUDE_CONF}" &> /dev/null
touch "${AVRDUDE_CONF}"
check_error "Failed"
chown "${SUDO_USER}" "${AVRDUDE_CONF}"
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
echo -e "${AVRDUDE_TEXT}" > "${AVRDUDE_CONF}"

echo "Done"
echo ""

#-------------------------------------------------------------------------------
# add RetroPie port
# TODO: RetroPie
# create shortcut in RetroPie menu
#if [ -d "/home/${SUDO_USER}/RetroPie" ]; then
#    echo -n "Creating RetroPie port... "
#
	#echo "Done"
    #echo ""
#fi

#-------------------------------------------------------------------------------
# ask for reboot

echo "***************************************************"
echo ""
echo "You need to reboot the pi to complete installation."
read -p "Do you want to reboot now? (Y/n) [default=yes]" ANSWER
case "${ANSWER}" in
    [Nn]* ) exit;;
        * ) shutdown -r now;;
esac

# -)
