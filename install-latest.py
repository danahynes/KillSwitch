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

import os
import requests
import subprocess
import zipfile

HOME_DIR = os.path.expanduser("~")

# TODO: hide this
GITHUB_TOKEN = "3868839158c75239f3ed89a4aedfe620e72156b4"
GITHUB_URL = "https://api.github.com/repos/danahynes/KillSwitch/releases/latest"

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
ZIP_NAME = os.path.basename(UPDATE_URL)

os.chdir(HOME_DIR)

# get version number for zip/folder name
ZIP_FILE_NAME = "KillSwitch-" + ZIP_NAME + ".zip"

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
SHORT_NAME = "KillSwitch-" + ZIP_NAME
ZIP_FILE.extractall()
os.rename(LONG_NAME, SHORT_NAME)
os.remove(ZIP_FILE_NAME)

# run installer
os.chdir(SHORT_NAME + "/Software/Bash")
os.chmod("killswitch-install.sh", 0o0744)
subprocess.call([
    "sudo",
    "./killswitch-install.sh",
    "&"
])

os.remove(SHORT_NAME)

# -)
