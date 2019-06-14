#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# killswitch-install-latest.sh
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
VERSION_NUMBER="0.1.48"
GITHUB_URL="https://api.github.com/repos/danahynes/KillSwitch/releases/latest"
SETTINGS_DIR="${HOME}/.killswitch"
DOWNLOAD_DIR="${SETTINGS_DIR}/latest"

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
check_error() {
    if [ "$?" != "0" ]; then
        echo "${1}"
        echo "Aborting install latest"

        # clean up (remove) any dirs created at this point (.killswitch)
        #rm -r "${SETTINGS_DIR}"

        # and any files copied to /usr/local/bin
        #find /usr/local/bin/ -name "killswitch-*" -delete

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

# remove any old downloads (but not settings)
if [ -d "${DOWNLOAD_DIR}" ]; then
    rm -r "${DOWNLOAD_DIR}"
    check_error "Failed"
fi

# create download dir and change to it
mkdir -p "${DOWNLOAD_DIR}"
check_error "Failed"
chown "${USER}:${USER}" "${DOWNLOAD_DIR}"
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
rm "${ZIP_FILE_NAME}"
check_error "Failed"
cd "${SHORT_NAME}"
check_error "Failed"
echo "Done"

echo -n "Running installer... "

# run installer
cd Software/Bash/
check_error "Failed"
sudo ./killswitch-install.sh
check_error "Failed"

# never called if reboot
#rm -r "${DOWNLOAD_DIR}"
#rm -- "$0"

# close this script
exit 0

# -)
