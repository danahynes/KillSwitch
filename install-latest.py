#! /usr/bin/env python3

#-------------------------------------------------------------------------------
# install-latest.py
# KillSwitch
#
# Copyright © 2019 Dana Hynes <danahynes@gmail.com>
# This work is free. You can redistribute it and/or modify it under the terms
# of the Do What The Fuck You Want To Public License, Version 2, as published
# by Sam Hocevar. See the LICENSE file for more details.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Imports

import fnmatch
import locale
import os
import requests
import shutil
import subprocess
import sys
import zipfile

#-------------------------------------------------------------------------------
# Constants

VERSION_NUMBER = "0.5.21"

# TODO: hide this
GITHUB_TOKEN = "3868839158c75239f3ed89a4aedfe620e72156b4"
GITHUB_URL = "https://api.github.com/repos/danahynes/KillSwitch/releases/latest"

HOME_DIR = os.path.expanduser("~")
SETTINGS_DIR = HOME_DIR + "/.killswitch"
DOWNLOAD_DIR = SETTINGS_DIR + "/latest"

#-------------------------------------------------------------------------------
# Init

# set locale
locale.setlocale(locale.LC_ALL, '')

#-------------------------------------------------------------------------------
# Functions

def doError(error):
    print("Installation failed: ", error)

    # TODO: need to delete anything create by now (.killswitch)

    sys.exit(1)

#-------------------------------------------------------------------------------
# Main code

# step 1
try:
    print("Getting URL to latest release...")

    # get latest JSON
    headers = {
        "Authorization" : "token " + GITHUB_TOKEN,
        "Accept" : "application/vnd.github.v3.raw"
    }
    response = requests.get(GITHUB_URL, headers = headers)
    JSON = response.json()

    # get path to zip file
    UPDATE_URL = JSON["zipball_url"]
except:
    doError("error in step 1: " + str(sys.exc_info()[1]))

# step 2
try:
    print("Removing old directories...")

    # remove any old downloads
    if os.path.exists(DOWNLOAD_DIR):
        shutil.rmtree(DOWNLOAD_DIR)

    # create download dir and change to it
    os.makedirs(DOWNLOAD_DIR)
    os.chdir(DOWNLOAD_DIR)
except:
    doError("error in step 2: " + str(sys.exc_info()[1]))

# step 3
try:

    print("Creating path names...")

    # fudge some names
    ZIP_NAME = os.path.basename(UPDATE_URL)
    SHORT_NAME = "KillSwitch-" + ZIP_NAME
    ZIP_FILE_NAME = SHORT_NAME + ".zip"
except:
    doError("error in step 3: " + str(sys.exc_info()[1]))

# step 4
try:
    print("Downloading latest release...")

    # get actual source
    headers = {
        "Authorization" : "token " + GITHUB_TOKEN,
        "Accept" : "application/vnd.github.v3.raw"
    }
    response = requests.get(UPDATE_URL, headers = headers)
    with open(ZIP_FILE_NAME, "wb") as file:
        file.write(response.content)
except:
    doError("error in step 4: " + str(sys.exc_info()[1]))

# step 5
try:
    print("Unzipping latest release...")

    # unzip
    ZIP_FILE = zipfile.ZipFile(ZIP_FILE_NAME)
    LONG_NAME = ZIP_FILE.namelist()[0]
    ZIP_FILE.extractall()

    # rename and change into unzipped folder
    os.rename(LONG_NAME, SHORT_NAME)
    os.remove(ZIP_FILE_NAME)
    os.chdir(SHORT_NAME)
except:
    doError("error in step 5: " + str(sys.exc_info()[1]))

# step 6
try:
    print("Running installer...")
    print("")

    # run installer (forked)
    os.chdir("Software/Bash")
    os.chmod("killswitch-install.sh", 0o0755)
    subprocess.call([
        "sudo",
        "./killswitch-install.sh"
    ])
except:
    doError("error in step 6: " + str(sys.exc_info()[1]))

# exit cleanly
sys.exit(0)

# -)
