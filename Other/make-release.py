#! /usr/bin/env python3

#-------------------------------------------------------------------------------
# make-release.py
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
import re
import shutil
import subprocess
import sys
import time

#-------------------------------------------------------------------------------
# Constants

VERSION_NUMBER = "0.5.21"

# set locale
locale.setlocale(locale.LC_ALL, '')

# change install-latest
os.chdir("..")

FILE = "install-latest.py"
REGEX = re.compile("VERSION_NUMBER = \".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX, "VERSION_NUMBER = \"" + VERSION_NUMBER + "\"",
    FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

# change firmware
os.chdir("Firmware/")

FILE = "src/KillSwitch.cpp"
REGEX = re.compile("VERSION_NUMBER\[] PROGMEM = \".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX, "VERSION_NUMBER[] PROGMEM = \"" + VERSION_NUMBER +
    "\"", FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

# change hardware
os.chdir("../Hardware/Pi3")
DATE = time.strftime("%Y-%m-%d")

FILE = "killswitch-pi3.sch"
REGEX_DATE = re.compile("Date \".*\"")
REGEX_VERSION = re.compile("Rev \".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX_DATE, "Date \"" + DATE + "\"", FILE_TEXT)
FILE_TEXT = re.sub(REGEX_VERSION, "Rev \"" + VERSION_NUMBER + "\"", FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

FILE = "killswitch-pi3.kicad_pcb"
REGEX_DATE = re.compile("date \".*\"")
REGEX_VERSION = re.compile("rev \".*\"")
REGEX_TEXT = re.compile("gr_text \"KillSwitch.*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX_DATE, "date \"" + DATE + "\"", FILE_TEXT)
FILE_TEXT = re.sub(REGEX_VERSION, "rev \"" + VERSION_NUMBER + "\"", FILE_TEXT)
FILE_TEXT = re.sub(REGEX_TEXT, "gr_text \"KillSwitch\\\\nv" + VERSION_NUMBER +
    "\"", FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

os.chdir("../Pi0")

FILE = "killswitch-pi0.sch"
REGEX_DATE = re.compile("Date \".*\"")
REGEX_VERSION = re.compile("Rev \".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX_DATE, "Date \"" + DATE + "\"", FILE_TEXT)
FILE_TEXT = re.sub(REGEX_VERSION, "Rev \"" + VERSION_NUMBER + "\"", FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

FILE = "killswitch-pi0.kicad_pcb"
REGEX_DATE = re.compile("date \".*\"")
REGEX_VERSION = re.compile("rev \".*\"")
REGEX_TEXT = re.compile("gr_text \"KillSwitch.*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX_DATE, "date \"" + DATE + "\"", FILE_TEXT)
FILE_TEXT = re.sub(REGEX_VERSION, "rev \"" + VERSION_NUMBER + "\"", FILE_TEXT)
FILE_TEXT = re.sub(REGEX_TEXT, "gr_text \"KillSwitch\\\\nv" + VERSION_NUMBER +
    "\"", FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

# change software
os.chdir("../../Software/Bash")

FILE = "killswitch-install.sh"
REGEX = re.compile("VERSION_NUMBER=\".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX, "VERSION_NUMBER=\"" + VERSION_NUMBER + "\"",
    FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

FILE = "killswitch-uninstall.sh"
REGEX = re.compile("VERSION_NUMBER=\".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX, "VERSION_NUMBER=\"" + VERSION_NUMBER + "\"",
    FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

os.chdir("../Python")

FILE = "killswitch-boot.py"
REGEX = re.compile("VERSION_NUMBER = \".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX, "VERSION_NUMBER = \"" + VERSION_NUMBER + "\"",
    FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

FILE = "killswitch-shutdown.py"
REGEX = re.compile("VERSION_NUMBER = \".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX, "VERSION_NUMBER = \"" + VERSION_NUMBER + "\"",
    FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

FILE = "killswitch-settings.py"
REGEX = re.compile("VERSION_NUMBER = \".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX, "VERSION_NUMBER = \"" + VERSION_NUMBER + "\"",
    FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

os.chdir("../Services")

FILE = "killswitch-boot.service"
REGEX = re.compile("VERSION_NUMBER = \".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX, "VERSION_NUMBER = \"" + VERSION_NUMBER + "\"",
    FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

FILE = "killswitch-shutdown.service"
REGEX = re.compile("VERSION_NUMBER = \".*\"")
with open(FILE, "r") as file:
    FILE_TEXT = file.read()
FILE_TEXT = re.sub(REGEX, "VERSION_NUMBER = \"" + VERSION_NUMBER + "\"",
    FILE_TEXT)
with open(FILE, "w") as file:
    file.write(FILE_TEXT)

# build firmware
os.chdir("../../Firmware")
subprocess.call(["pio", "run"])

# remove old hex file
for file in os.listdir("."):
    if fnmatch.fnmatch(file, "killswitch-firmware_*"):
        os.remove(file)

# bring up new hex file
os.chdir(".pioenvs/uno")
shutil.copyfile("firmware.hex", "../../killswitch-firmware_" + VERSION_NUMBER +
    ".hex")

# cleanup
sys.exit(0)

# -)
