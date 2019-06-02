#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# install-latest.sh
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
VERSION_NUMBER="0.1.15"
GITHUB_URL="https://api.github.com/repos/danahynes/KillSwitch/releases/latest"
SETTINGS_DIR="${HOME}/.killswitch"
DOWNLOAD_DIR="${SETTINGS_DIR}/latest"

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
echo -n "Getting URL to latest release... "

# get latest JSON
JSON=$(curl -s "${GITHUB_URL}")
check_error "Failed"

# get path to zip file
UPDATE_URL=$(echo "${JSON}" | grep 'zipball_url' | cut -d '"' -f4)
check_error "Failed"
echo "Done"

echo -n "Removing old directories... "

remove any old downloads
if [ -d "${DOWNLOAD_DIR}" ]; then
    rm -rf "${DOWNLOAD_DIR}"
    check_error "Failed"
fi

# create download dir and change to it
mkdir -p "${DOWNLOAD_DIR}"
check_error "Failed"
cd "${DOWNLOAD_DIR}"
check_error "Failed"
echo "Done"

echo -n "Creating path names... "

# fudge some names
ZIP_NAME=$(basename "${UPDATE_URL}")
check_error "Failed"
SHORT_NAME="KillSwitch-${ZIP_NAME}"
ZIP_FILE_NAME="${SHORT_NAME}.zip"
echo "Done"

echo -n "Downloading latest release... "

# get lastest release from github and save to settings dir
curl -Lso "${ZIP_FILE_NAME}" "${UPDATE_URL}"
check_error "Failed"
echo "Done"

echo -n "Unzipping latest release... "

# get long name
LONG_NAME=$(echo $(unzip -qql "${ZIP_FILE_NAME}" | head -n1 | tr -s ' ' \
        | cut -d ' ' -f5-))
check_error "Failed"

# unzip
unzip -qq "${ZIP_FILE_NAME}"
check_error "Failed"

# rename
mv "${LONG_NAME}" "${SHORT_NAME}"
check_error "Failed"

# delete
rm "${ZIP_FILE_NAME}" > /dev/null
check_error "Failed"
cd "${SHORT_NAME}"
check_error "Failed"
echo "Done"

echo -n "Running installer... "

# NB: do hardware first because software may cause reboot

# do avrdude update with hex file
# cd Firmware/
# FIRMWARE_FILE=$(find . -name "killswitch-firmware_*.hex")
# avrdude \
#         -p "${CHIP_ID}" \
#         -C +"${SETTINGS_DIR}/killswitch-avrdude.conf" \
#         -c "killswitch" \
#         -U flash:w:"${FIRMWARE_FILE}":i \
#         -U flash:v:"${FIRMWARE_FILE}":i

# RES=$?
# if [ $RES -ne 0 ]; then
#     doHardwareUpdateError
#
#     # NB: don't return here if we can still try software update
#     #return
# fi

# NB: here we have two choices. fork the installer, which would allow us to do
# some cleanup (i.e. delete the unzipped folder, but not run the new settings)
# or wait for the installer, which would not let us clean up as the user will
# most likely reboot at the end of the installer.

# run installer for software
cd Software/Bash/
check_error "Failed"
chmod +x killswitch-install.sh
check_error "Failed"
sudo ./killswitch-install.sh
check_error "Failed"
echo "Done"

echo -n "Cleaning up... "

# remove unzipped folder
cd ../../..
check_error "Failed"
rm -r "KillSwitch-${ZIP_NAME}"
check_error "Failed"

# run new settings and close this one
killswitch-settings.sh &
exit 0
