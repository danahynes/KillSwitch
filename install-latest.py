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

VERSION_NUMBER = "0.5.18"

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
    sys.exit(1)

#-------------------------------------------------------------------------------
# Main code

# get latest JSON
headers = {
    "Authorization" : "token " + GITHUB_TOKEN,
    "Accept" : "application/vnd.github.v3.raw"
}

try:
    response = requests.get(GITHUB_URL, headers = headers)
    JSON = response.json()
except:
    doError("error in step 1: " + str(sys.exc_info()[1]))

# get path to actual source
UPDATE_URL = JSON["zipball_url"]

# remove any old downloads
if os.path.exists(DOWNLOAD_DIR):
    shutil.rmtree(DOWNLOAD_DIR)

# create download dir and change to it
try:
    os.makedirs(DOWNLOAD_DIR)
    os.chdir(DOWNLOAD_DIR)
except:
    doError("error in step 2: " + str(sys.exc_info()[1]))

# fudge some names
try:
    ZIP_NAME = os.path.basename(UPDATE_URL)
    SHORT_NAME = "KillSwitch-" + ZIP_NAME
    ZIP_FILE_NAME = SHORT_NAME + ".zip"
except:
    doError("error in step 3: " + str(sys.exc_info()[1]))

# NB: we really shouldn't delete directories if we aren't 100% sure they're
# ours. this dir would be in the user's home folder, so they could have another
# folder that starts with "KillSwitch-" and deleting it would be bad. better to
# let the user worry about deleting when done, or the installer could delete
# its ../.. owner folder, or overwrite when unzipping, etc.
# this code is left for posterity
#
# remove old dir if necessary
# try:
#     for file in os.listdir("."):
#         if fnmatch.fnmatch(file, "KillSwitch-*"):
#             shutil.rmtree(file, ignore_errors = True)
# except:
#     doError(sys.exc_info()[0])

# get actual source
headers = {
    "Authorization" : "token " + GITHUB_TOKEN,
    "Accept" : "application/vnd.github.v3.raw"
}

try:
    response = requests.get(UPDATE_URL, headers = headers)
    with open(ZIP_FILE_NAME, "wb") as file:
        file.write(response.content)
except:
    doError("error in step 4: " + str(sys.exc_info()[1]))

# unzip
try:
    ZIP_FILE = zipfile.ZipFile(ZIP_FILE_NAME)
    LONG_NAME = ZIP_FILE.namelist()[0]
    ZIP_FILE.extractall()
    os.rename(LONG_NAME, SHORT_NAME)
    os.remove(ZIP_FILE_NAME)
    os.chdir(SHORT_NAME)
except:
    doError("error in step 5: " + str(sys.exc_info()[1]))

# remove ourself
# try:
#     os.chdir(os.getcwd())
#     os.remove("install-latest.py")
# except:
#     doError("error in step 6: " + str(sys.exec_info()[1]))

# run installer
try:
    os.chdir("Software/Bash")
    os.chmod("killswitch-install.sh", 0o0755)
    subprocess.call([
        "sudo",
        "./killswitch-install.sh"
    ])
except:
    doError("error in step 7: " + str(sys.exc_info()[1]))

# NB: this won't get called if the user reboots after install

# cleanup
# remove unzipped folder and one-liner
print("remove from latest")
try:
    #os.chdir(HOME_DIR)
    shutil.rmtree(DOWNLOAD_DIR)
    #os.remove("install-latest.py")
except:
    doError("error in step 8: " + str(sys.exc_info()[1]))

# exit cleanly
sys.exit(0)

# -)
