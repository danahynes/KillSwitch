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
import zipfile

#-------------------------------------------------------------------------------
# Constants

VERSION_NUMBER = "0.5.3-b1"

# TODO: hide this
GITHUB_TOKEN = "3868839158c75239f3ed89a4aedfe620e72156b4"
GITHUB_URL = "https://api.github.com/repos/danahynes/KillSwitch/releases/latest"

HOME_DIR = os.path.expanduser("~")

#-------------------------------------------------------------------------------
# Init

# set locale
locale.setlocale(locale.LC_ALL, '')

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
    #doDownloadError()
    #return
    pass

# get path to actual source
UPDATE_URL = JSON["zipball_url"]

# change to download location
os.chdir(HOME_DIR)

# fudge some names
ZIP_NAME = os.path.basename(UPDATE_URL)
SHORT_NAME = "KillSwitch-" + ZIP_NAME
ZIP_FILE_NAME = SHORT_NAME + ".zip"

# remove old dir if necessary
for file in os.listdir("."):
    if fnmatch.fnmatch(file, "KillSwitch-*"):
        shutil.rmtree(file, ignore_errors = True)

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
    #doDownloadError()
    #return
    pass

# unzip
ZIP_FILE = zipfile.ZipFile(ZIP_FILE_NAME)
LONG_NAME = ZIP_FILE.namelist()[0]
ZIP_FILE.extractall()
os.rename(LONG_NAME, SHORT_NAME)
os.remove(ZIP_FILE_NAME)
os.chdir(SHORT_NAME)

# run installer
os.chdir("Software/Bash")
os.chmod("killswitch-install.sh", 0o0755)
subprocess.call([
    "sudo",
    "./killswitch-install.sh"
])

# remove unzipped folder and one-liner
os.chdir("../../../")
shutil.rmtree(SHORT_NAME)
os.remove("install-latest.py")

# cleanup
sys.exit(0)

# -)
