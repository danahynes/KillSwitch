#! /usr/bin/env python3

#-------------------------------------------------------------------------------
# killSwitch-settings.py
# KillSwitch
#
# Copyright © 2019 Dana Hynes <danahynes@gmail.com>
# This work is free. You can redistribute it and/or modify it under the terms
# of the Do What The Fuck You Want To Public License, Version 2, as published
# by Sam Hocevar. See the LICENSE file for more details.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Imports

import dialog
import getpass
import json
import locale
import os
import pwd
import requests
import serial
import shutil
import subprocess
import sys
import zipfile

#-------------------------------------------------------------------------------
# Constants

VERSION_NUMBER = "0.1.0"

DEBUG = os.uname()[4].startswith("arm")

if DEBUG == False:

    # laptop (test) serial port
    SERIAL_PORT = "/dev/pts/5"
else:

    # pi serial port
    SERIAL_PORT = "/dev/ttyS0"
SERIAL_SPEED = 9600

# TODO: hide this
GITHUB_TOKEN = "3868839158c75239f3ed89a4aedfe620e72156b4"
GITHUB_URL = "https://api.github.com/repos/danahynes/KillSwitch/releases/latest"

CHIP_ID = "atmega328p"

HOME_DIR = os.path.expanduser("~")

SETTINGS_DIR = HOME_DIR + "/.killswitch"
SETTINGS_FILE = SETTINGS_DIR + "/killswitch-settings.json"
SETTINGS_DICT = {}

DOWNLOAD_DIR = SETTINGS_DIR + "/latest"
AVRDUDE_FILE = SETTINGS_DIR + "/killswitch-avrdude.conf"

LEDN_DEFAULT = 255            # 0-255
LPT_DEFAULT = 5               # in seconds

ACTION_START = "?"
ACTION_SEPARATOR = "|"
ACTION_END = "!"

STATE_ON = "on"
STATE_OFF = "off"

WINDOW_TITLE = "KillSwitch Settings v{0} (c) 2019 Dana Hynes".format(
    VERSION_NUMBER)
OK_LABEL = "OK"
BACK_LABEL = "Back"
EXIT_LABEL = "Exit"
CANCEL_LABEL = "Cancel"

MENU_TITLE = "KillSwitch Settings"
MENU_TEXT = "Choose an item:"
MENU_HEIGHT = 15
MENU_WIDTH = 40
MENU_ITEM_HEIGHT = 8
MENU_TAGS = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8"
]
MENU_ITEMS = [
    "LED options",
    "Start recording",
    "Long press time",
    "Long press action",
    "Restart after power failure",
    "Install RetroPie shortcut",
    "Update",
    "Uninstall"
]
MENU_HELP = [
	"Set the status LED options",
	"Start recording new remote codes",
	"Set how long to hold the button for a long press action",
	"Set the action to take when the button is held",
    "Automatically boot the Pi after a power failure if it was previously on",
    "Install RetroPie shortcut in Ports",
    "Check for updates to the software on the Pi and the firmware in the " \
    "device",
	"Uninstall all KillSwitch software from the Pi"
]

LED_MENU_TITLE = "LED Options"
LED_MENU_TEXT = "Choose an item:"
LED_MENU_HEIGHT = 11
LED_MENU_WIDTH = 40
LED_MENU_ITEM_HEIGHT = 4
LED_MENU_TAGS = [
    "1",
    "2",
    "3",
    "4"
]
LED_MENU_ITEMS = [
    "LED type",
    "LED style",
    "LED on brightness",
    "LED off brightness"
]
LED_MENU_HELP = [
    "Set the LED type to on or off",
    "Set the LED style to flash or pulse",
    "Set the brightness when the LED is on",
    "Set the brightness when the LED is off"
]

LEDT_TITLE = "LED type"
LEDT_TEXT = "Set the LED type:"
LEDT_HEIGHT = 10
LEDT_WIDTH = 40
LEDT_ITEM_HEIGHT = 2
LEDT_TAGS = [
    "1",
    "2"
]
LEDT_ITEMS = [
    "On",
    "Off"
]

# NB: escaping backslashes works fine on laptop, but crashes on pi. only thing
# that works is the code below, but only gives us single quotes. i can live
# with it for now.
LEDT_HELP = [
    "LED at '"'On'"' brightness when Pi is on, and '"'Off'"' brightness when Pi is off",
    "The LED is always off, except when programming"
]
LEDT_SETTING = "LTP"
LEDT_ACTION = "LTP"

LEDS_TITLE = "LED style"
LEDS_TEXT = "Select the LED style:"
LEDS_HEIGHT = 9
LEDS_WIDTH = 40
LEDS_ITEM_HEIGHT = 2
LEDS_TAGS = [
    "1",
    "2"
]
LEDS_ITEMS = [
    "Flash",
    "Pulse"
]
LEDS_SETTING = "LPL"
LEDS_ACTION = "LPL"

LEDN_TITLE = "LED on brightness"
LEDN_TEXT = "Set the LED on brightness (0-255):"
LEDN_HEIGHT = 0
LEDN_WIDTH = 40
LEDN_MIN = 0
LEDN_MAX = 255
LEDN_SETTING = "LBN"
LEDN_ACTION = "LBN"

LEDF_TITLE = "LED off brightness"
LEDF_TEXT = "Set the LED off brightness (0-255):"
LEDF_HEIGHT = 0
LEDF_WIDTH = 40
LEDF_MIN = 0
LEDF_MAX = 255
LEDF_SETTING = "LBF"
LEDF_ACTION = "LBF"

REC_TITLE = "Start recording"
REC_TEXT = "Press OK to start recording new codes on the device. The status " \
"LED will begin flashing rapidly. Point the remote at the device and press " \
"the button for 'on'. When you see the status LED flash once slowly, point " \
"the remote at the device and press the button for 'off'. When the LED " \
"flashes slowly twice, recording is complete."
REC_HEIGHT = 14
REC_WIDTH = 40
REC_ACTION = "REC"

LPT_TITLE = "Long press time"
LPT_TEXT = "Set the long press time in seconds (1-10):"
LPT_HEIGHT = 3
LPT_WIDTH = 40
LPT_MIN = 1
LPT_MAX = 10
LPT_SETTING = "LPT"
LPT_ACTION = "LPT"

LPA_TITLE = "Long press action"
LPA_TEXT = "Set the long press action:"
LPA_HEIGHT = 9
LPA_WIDTH = 40
LPA_ITEM_HEIGHT = 2
LPA_TAGS = [
    "1",
    "2"
]
LPA_ITEMS = [
    "Reboot",
    "Force quit"
]
LPA_SETTING = "LPA"
LPA_ACTION = "LPA"

PWR_TITLE = "Restart after power failure"
PWR_TEXT = "Check the setting to automatically boot after a power failure:"
PWR_HEIGHT = 10
PWR_WIDTH = 40
PWR_ITEM_HEIGHT = 1
PWR_TAG = "1"
PWR_ITEM = "Restart after power failure"
PWR_SETTING = "PWR"
PWR_ACTION = "PWR"

UPDATE_TITLE = "Update"
UPDATE_HEIGHT = 13
UPDATE_WIDTH = 40
UPDATE_TEXT_CURRENT = "Current version: "
UPDATE_TEXT_NEW = "Latest version:  "
UPDATE_UPDATE_TEXT = "Are you sure you want to update KillSwitch?\n\n(Note " \
"that you will need a keyboard attached to enter the root password when the " \
"installer starts)"
UPDATE_OK_TEXT = "Your firmware and software are up to date."

ERROR_TITLE = "Error"
ERROR_TEXT_DOWNLOAD = "There was an error downloading. Please check your " \
"internet connection and try again."
ERROR_TEXT_HARDWARE = "There was an error updating the hardware. Please " \
"check your device connection and try again."
ERROR_TEXT_SOFTWARE = "There was an error updating the software. Please " \
"check your device connection and try again."
ERROR_HEIGHT = 10
ERROR_WIDTH = 40

UNINSTALL_TITLE = "Uninstall"
UNINSTALL_TEXT = "Are you sure you want to uninstall KillSwitch?\n\n(Note " \
"that you will need a keyboard attached to enter the root password when the " \
"uninstaller starts)"
UNINSTALL_HEIGHT = 10
UNINSTALL_WIDTH = 40
UNINSTALL_COMMAND = "/usr/local/bin/killswitch-uninstall.sh"

# TODO: RetroPie
# JOY_2_KEY_DIR = HOME_DIR + "/RetroPie/scriptmodules/supplementary/runcommand/"
# JOY_2_KEY_CMD = "joy2key.py"
# JOY_2_KEY_DEVICE = "/dev/input/jsX"
# JOY_2_KEY_PARAMS = ["kcub1", "kcuf1", "kcuu1", "kcud1", "0x0a", "0x20"]

#-------------------------------------------------------------------------------
# Variables

MENU_SEL = ""
LED_MENU_SEL = ""
LEDT_STATES = [
    STATE_ON,
    STATE_OFF
]
LEDS_STATES = [
    STATE_ON,
    STATE_OFF
]
LPA_STATES = [
    STATE_ON,
    STATE_OFF
]
PWR_STATE = STATE_OFF
UPDATE_TEXT = ""
UPDATE_URL = ""

#-------------------------------------------------------------------------------
# Helpers

def readPropsFile(key):
    return SETTINGS_DICT[key]

def writePropsFile(key, value):
    SETTINGS_DICT[key] = value
    with open(SETTINGS_FILE, "wt") as file:
        json.dump(SETTINGS_DICT, file)

def writeSerial(key, value):
    CMD = ACTION_START + key + ACTION_SEPARATOR + str(value) + ACTION_END + "\n"
    ser.write(bytes(CMD, 'UTF-8'))

#-------------------------------------------------------------------------------
# Screens

def doMain():

    global MENU_SEL
    RES = ""

    CODE, TAG = dlg.menu(
        MENU_TEXT,
        title = MENU_TITLE,
        cancel_label = EXIT_LABEL,
        item_help = True,
        height = MENU_HEIGHT,
        width = MENU_WIDTH,
        menu_height = MENU_ITEM_HEIGHT,
        default_item = MENU_SEL,
        choices=[
            (MENU_TAGS[0], MENU_ITEMS[0], MENU_HELP[0]),
            (MENU_TAGS[1], MENU_ITEMS[1], MENU_HELP[1]),
            (MENU_TAGS[2], MENU_ITEMS[2], MENU_HELP[2]),
            (MENU_TAGS[3], MENU_ITEMS[3], MENU_HELP[3]),
            (MENU_TAGS[4], MENU_ITEMS[4], MENU_HELP[4]),
            (MENU_TAGS[5], MENU_ITEMS[5], MENU_HELP[5]),
            (MENU_TAGS[6], MENU_ITEMS[6], MENU_HELP[6]),
            (MENU_TAGS[7], MENU_ITEMS[7], MENU_HELP[7])
        ]
    )

    if CODE == dlg.OK:

        # save highlighted item
        MENU_SEL = TAG

        if TAG == MENU_TAGS[0]:

            # menu loop
            RES = doLEDMenu()
            while RES == dlg.OK:
                RES = doLEDMenu()
        elif TAG == MENU_TAGS[1]:
            RES = doStartRecording()
        elif TAG == MENU_TAGS[2]:
            RES = doLongPressTime()
        elif TAG == MENU_TAGS[3]:
            RES = doLongPressAction()
        elif TAG == MENU_TAGS[4]:
            RES = doPower()
        elif TAG == MENU_TAGS[5]:
            RES = doRetroPie()
        elif TAG == MENU_TAGS[6]:
            RES = doUpdate()
        elif TAG == MENU_TAGS[7]:
            RES = doUninstall()

    # quit app
    if RES == dlg.ESC:
        return RES

    return CODE

def doLEDMenu():

    global LED_MENU_SEL
    RES = ""

    CODE, TAG = dlg.menu(
        LED_MENU_TEXT,
        title = LED_MENU_TITLE,
        cancel_label = BACK_LABEL,
        item_help = True,
        height = LED_MENU_HEIGHT,
        width = LED_MENU_WIDTH,
        menu_height = LED_MENU_ITEM_HEIGHT,
        default_item = LED_MENU_SEL,
        choices=[
            (LED_MENU_TAGS[0], LED_MENU_ITEMS[0], LED_MENU_HELP[0]),
            (LED_MENU_TAGS[1], LED_MENU_ITEMS[1], LED_MENU_HELP[1]),
            (LED_MENU_TAGS[2], LED_MENU_ITEMS[2], LED_MENU_HELP[2]),
            (LED_MENU_TAGS[3], LED_MENU_ITEMS[3], LED_MENU_HELP[3])
        ]
    )

    if CODE == dlg.OK:

        # save highlighted item
        LED_MENU_SEL = TAG

        if TAG == LED_MENU_TAGS[0]:
            RES = doLEDType()
        elif TAG == LED_MENU_TAGS[1]:
            RES = doLEDStyle()
        elif TAG == LED_MENU_TAGS[2]:
            RES = doLEDOnBrightness()
        elif TAG == LED_MENU_TAGS[3]:
            RES = doLEDOffBrightness()

    # quit app
    if RES == dlg.ESC:
        return RES

    return CODE

def doLEDType():

    # get previous value
    LEDT_VALUE = readPropsFile(LEDT_SETTING)

    # clear all values
    i = 0
    while i < len(LEDT_STATES):
        LEDT_STATES[i] = STATE_OFF
        i += 1

    # set the new value
    LEDT_STATES[LEDT_VALUE] = STATE_ON

    CODE, TAG = dlg.radiolist(
        LEDT_TEXT,
        title = LEDT_TITLE,
        cancel_label = BACK_LABEL,
        default_item = LEDT_ITEMS[LEDT_VALUE],
        item_help = True,
        height = LEDT_HEIGHT,
        width = LEDT_WIDTH,
        list_height = LEDT_ITEM_HEIGHT,
        choices = [
            (LEDT_TAGS[0], LEDT_ITEMS[0], LEDT_STATES[0], LEDT_HELP[0]),
            (LEDT_TAGS[1], LEDT_ITEMS[1], LEDT_STATES[1], LEDT_HELP[1])
        ]
    )

    if CODE == dlg.OK:

        # save index instead of actual tag
        i = 0
        while i < len(LEDT_TAGS):
            if LEDT_TAGS[i] == TAG:

                # save/write
                writePropsFile(LEDT_SETTING, i)
                writeSerial(LEDT_ACTION, i)
                break

            i += 1

    return CODE

def doLEDStyle():

    # get previous value
    LEDS_VALUE = readPropsFile(LEDS_SETTING)

    # clear all values
    i = 0
    while i < len(LEDS_STATES):
        LEDS_STATES[i] = STATE_OFF
        i += 1

    # set the new state
    LEDS_STATES[LEDS_VALUE] = STATE_ON

    CODE, TAG = dlg.radiolist(
        LEDS_TEXT,
        title = LEDS_TITLE,
        cancel_label = BACK_LABEL,
        default_item = LEDS_ITEMS[LEDS_VALUE],
        height = LEDS_HEIGHT,
        width = LEDS_WIDTH,
        list_height = LEDS_ITEM_HEIGHT,
        choices = [
            (LEDS_TAGS[0], LEDS_ITEMS[0], LEDS_STATES[0]),
            (LEDS_TAGS[1], LEDS_ITEMS[1], LEDS_STATES[1])
        ]
    )

    if CODE == dlg.OK:

        # save index instead of actual tag
        i = 0
        while i < len(LEDS_TAGS):
            if LEDS_TAGS[i] == TAG:

                # save/write
                writePropsFile(LEDS_SETTING, i)
                writeSerial(LEDS_ACTION, i)
                break
            i += 1

    return CODE

def doLEDOnBrightness():

    # get previous value
    LEDN_VALUE = readPropsFile(LEDN_SETTING)

    CODE, VALUE = dlg.rangebox(
        LEDN_TEXT,
        title = LEDN_TITLE,
        cancel_label = BACK_LABEL,
        height = LEDN_HEIGHT,
        width = LEDN_WIDTH,
        min = LEDN_MIN,
        max = LEDN_MAX,
        init = LEDN_VALUE
    )

    if CODE == dlg.OK:

        # save/write
        writePropsFile(LEDN_SETTING, VALUE)
        writeSerial(LEDN_ACTION, VALUE)

    return CODE

def doLEDOffBrightness():

    # get previous value
    LEDF_VALUE = readPropsFile(LEDF_SETTING)

    CODE, VALUE = dlg.rangebox(
        LEDF_TEXT,
        title = LEDF_TITLE,
        cancel_label = BACK_LABEL,
        height = LEDF_HEIGHT,
        width = LEDF_WIDTH,
        min = LEDF_MIN,
        max = LEDF_MAX,
        init = LEDF_VALUE
    )

    if CODE == dlg.OK:

        # save/write
        writePropsFile(LEDF_SETTING, VALUE)
        writeSerial(LEDF_ACTION, VALUE)

    return CODE

def doStartRecording():
    CODE = dlg.yesno(
        REC_TEXT,
        title = REC_TITLE,
        yes_label = OK_LABEL,
        no_label = BACK_LABEL,
        height = REC_HEIGHT,
        width = REC_WIDTH
    )

    if CODE == dlg.OK:
        writeSerial(REC_ACTION, "")

    return CODE

def doLongPressTime():

    # get previous value
    LPT_VALUE = readPropsFile(LPT_SETTING)

    CODE, VALUE = dlg.rangebox(
        LPT_TEXT,
        title = LPT_TITLE,
        cancel_label = BACK_LABEL,
        height = LPT_HEIGHT,
        width = LPT_WIDTH,
        min = LPT_MIN,
        max = LPT_MAX,
        init = LPT_VALUE
    )

    if CODE == dlg.OK:

        # save/write
        writePropsFile(LPT_SETTING, VALUE)
        writeSerial(LPT_ACTION, VALUE)

    return CODE

def doLongPressAction():

    # get previous value
    LPA_VALUE = readPropsFile(LPA_SETTING)

    # clear all values
    i = 0
    while i < len(LPA_STATES):
        LPA_STATES[i] = STATE_OFF
        i += 1

    LPA_STATES[LPA_VALUE] = STATE_ON

    CODE, TAG = dlg.radiolist(
        LPA_TEXT,
        title = LPA_TITLE,
        cancel_label = BACK_LABEL,
        default_item = LPA_ITEMS[LPA_VALUE],
        height = LPA_HEIGHT,
        width = LPA_WIDTH,
        list_height = LPA_ITEM_HEIGHT,
        choices = [
            (LPA_TAGS[0], LPA_ITEMS[0], LPA_STATES[0]),
            (LPA_TAGS[1], LPA_ITEMS[1], LPA_STATES[1])
        ]
    )

    if CODE == dlg.OK:

        # save index instead of actual tag
        i = 0
        while i < len(LPA_TAGS):
            if LPA_TAGS[i] == TAG:

                # save/write
                writePropsFile(LPA_SETTING, i)
                writeSerial(LPA_ACTION, i)
                break

            i += 1

    return CODE

def doPower():

    # get previous value
    PWR_VALUE = readPropsFile(PWR_SETTING)

    # clear old value
    PWR_STATE = STATE_OFF

    # set new value
    if PWR_VALUE == 1:
        PWR_STATE = STATE_ON

    CODE_TAGS = dlg.checklist(
        PWR_TEXT,
        title = PWR_TITLE,
        cancel_label = BACK_LABEL,
        height = PWR_HEIGHT,
        width = PWR_WIDTH,
        list_height = PWR_ITEM_HEIGHT,
        choices = [
            (PWR_TAG, PWR_ITEM, PWR_STATE)
        ]
    )

    if CODE_TAGS[0] == dlg.OK:

        # if tag is present, save a 1 else save a 0
        i = 0
        VALUE_ARRAY = CODE_TAGS[1]
        if len(VALUE_ARRAY) > 0:
            VALUE = VALUE_ARRAY[0]
            if VALUE == PWR_TAG:
                i = 1

        # save/write
        writePropsFile(PWR_SETTING, i)
        writeSerial(PWR_ACTION, i)

    return CODE_TAGS[0]

def doRetroPie():
    # TODO: RetroPie
    pass
    # if os.path.isdir(HOME_DIR + "/RetroPie"):
    #     if not os.path.isdir(HOME_DIR + "/RetroPie/roms/ports"):
    #         #USER_NAME = getpass.getuser()
    #         #USER_ID = pwd.getpwnam(USER_NAME).pw_uid
    #         os.makedirs(HOME_DIR + "/RetroPie/roms/ports")
    #     if not os.path.exists(HOME_DIR + "/RetroPie/roms/ports/KillSwitch"):
    #         os.symlink("/usr/local/bin/killswitch-settings.py", \
    #         HOME_DIR + "/RetroPie/roms/ports/KillSwitch")

def doDownloadError():
    CODE = dlg.msgbox(
        ERROR_TEXT_DOWNLOAD,
        title = ERROR_TITLE,
        height = ERROR_HEIGHT,
        width = ERROR_WIDTH
    )

    if CODE == dlg.OK:
        pass
    else:
        pass

    return CODE

def doHardwareUpdateError():
    CODE = dlg.msgbox(
        ERROR_TEXT_HARDWARE,
        title = ERROR_TITLE,
        height = ERROR_HEIGHT,
        width = ERROR_WIDTH
    )

    if CODE == dlg.OK:
        pass
    else:
        pass

    return CODE

def doSoftwareUpdateError():
    CODE = dlg.msgbox(
        ERROR_TEXT_SOFTWARE,
        title = ERROR_TITLE,
        height = ERROR_HEIGHT,
        width = ERROR_WIDTH
    )

    if CODE == dlg.OK:
        pass
    else:
        pass

    return CODE

def doActualUpdate():
    CODE = dlg.yesno(
        UPDATE_TEXT,
        title = UPDATE_TITLE,
        height = UPDATE_HEIGHT,
        width = UPDATE_WIDTH
    )

    if CODE == dlg.OK:

        # step 2
        try:

            # remove any old downloads
            if os.path.exists(DOWNLOAD_DIR):
                shutil.rmtree(DOWNLOAD_DIR)

            # create download dir and change to it
            os.makedirs(DOWNLOAD_DIR)
            os.chdir(DOWNLOAD_DIR)
        except:
            doDownloadError()
            return

        # step 3
        try:

            # get version number for zip/folder name
            ZIP_NAME = os.path.basename(UPDATE_URL)
            SHORT_NAME = "KillSwitch-" + ZIP_NAME
            ZIP_FILE_NAME = SHORT_NAME + ".zip"
        except:
            doDownloadError()
            return

        # step 4
        try:

            # get actual source
            headers = {
                "Authorization" : "token " + GITHUB_TOKEN,
                "Accept" : "application/vnd.github.v3.raw"
            }
            response = requests.get(UPDATE_URL, headers = headers)
            with open(ZIP_FILE_NAME, "wb") as file:
                file.write(response.content)
        except:
            doDownloadError()
            return

        # step 5
        try:

            # unzip
            ZIP_FILE = zipfile.ZipFile(ZIP_FILE_NAME)
            LONG_NAME = ZIP_FILE.namelist()[0]
            ZIP_FILE.extractall()

            # rename and change into unzipped folder
            os.rename(LONG_NAME, SHORT_NAME)
            os.remove(ZIP_FILE_NAME)
            os.chdir(SHORT_NAME)
        except:
            doDownloadError()
            return

        # do hardware first because software may cause reboot
        try:

            # do avrdude update with hex file
            os.chdir("Firmware")
            for file in os.listdir("."):
                if file.endswith(".hex"):
                    FIRMWARE_FILE = file

            RET = subprocess.call([
                "avrdude",
                "-p", CHIP_ID,
                "-C", "+" + AVRDUDE_FILE,
                "-c", "killswitch",
                "-U", "flash:w:" + FIRMWARE_FILE + ":i",
                "-U", "flash:v:" + FIRMWARE_FILE + ":i"
            ])

            if RET != 0:
                doHardwareUpdateError()

                # NB: don't return here if we can still try software update
                #return
        except:
            doHardwareUpdateError()
            return

        # step 6
        try:

            # run installer
            os.chdir("../Software/Bash")
            os.chmod("killswitch-install.sh", 0o0755)
            RET = subprocess.call([
                "sudo",
                "./killswitch-install.sh"
            ])

            if RET != 0:
                doSoftwareUpdateError()
                return
        except:
            doSoftwareUpdateError()
            return

        # if user did NOT reboot, re-run new settings in new shell
        subprocess.call([
            "/usr/local/bin/killswitch-settings.py",
            "&"
        ])

        # done with this shell
        sys.exit(0)

    return CODE

def doIsUpToDate():
    CODE = dlg.msgbox(
        UPDATE_TEXT,
        title = UPDATE_TITLE,
        height = UPDATE_HEIGHT,
        width = UPDATE_WIDTH
    )

    if CODE == dlg.OK:
        pass
    else:
        pass

    return CODE

def doUpdate():

    LOCAL_VERSION_NUMBERS = VERSION_NUMBER.split(".")

    LOCAL_VERSION_NUMBER_A = int(LOCAL_VERSION_NUMBERS[0])
    LOCAL_VERSION_NUMBER_B = int(LOCAL_VERSION_NUMBERS[1])
    LOCAL_VERSION_NUMBER_C = int(LOCAL_VERSION_NUMBERS[2])

    # step 1
    try:

        # get latest JSON
        headers = {
            "Authorization" : "token " + GITHUB_TOKEN,
            "Accept" : "application/vnd.github.v3.raw"
        }
        response = requests.get(GITHUB_URL, headers = headers)
        JSON = response.json()
    except:
        doDownloadError()
        return

    # get path to zip file
    global UPDATE_URL
    UPDATE_URL = JSON["zipball_url"]

    ZIP_NAME = os.path.basename(UPDATE_URL)
    REMOTE_VERSION_NUMBER = ZIP_NAME.split("v")[1]
    REMOTE_VERSION_NUMBERS = REMOTE_VERSION_NUMBER.split(".")

    REMOTE_VERSION_NUMBER_A = int(REMOTE_VERSION_NUMBERS[0])
    REMOTE_VERSION_NUMBER_B = int(REMOTE_VERSION_NUMBERS[1])
    REMOTE_VERSION_NUMBER_C = int(REMOTE_VERSION_NUMBERS[2])

    IS_NEWER = False

    if LOCAL_VERSION_NUMBER_A < REMOTE_VERSION_NUMBER_A:
        IS_NEWER = True
    elif LOCAL_VERSION_NUMBER_B < REMOTE_VERSION_NUMBER_B:
        IS_NEWER = True
    elif LOCAL_VERSION_NUMBER_C < REMOTE_VERSION_NUMBER_C:
        IS_NEWER = True

    global UPDATE_TEXT
    UPDATE_TEXT = UPDATE_TEXT_CURRENT
    UPDATE_TEXT += VERSION_NUMBER + "\n"
    UPDATE_TEXT += UPDATE_TEXT_NEW
    UPDATE_TEXT += REMOTE_VERSION_NUMBER
    UPDATE_TEXT += "\n\n"

    if IS_NEWER == True:
        UPDATE_TEXT += UPDATE_UPDATE_TEXT
        RES = doActualUpdate()
    else:
        UPDATE_TEXT += UPDATE_OK_TEXT
        RES = doIsUpToDate()

    return RES

def doUninstall():
    CODE = dlg.yesno(
        UNINSTALL_TEXT,
        title = UNINSTALL_TITLE,
        height = UNINSTALL_HEIGHT,
        width = UNINSTALL_WIDTH
    )

    if CODE == dlg.OK:
        subprocess.call(["sudo", UNINSTALL_COMMAND])
        CODE = dlg.ESC

    return CODE

#-------------------------------------------------------------------------------
# Init

# set locale
locale.setlocale(locale.LC_ALL, '')

# create dialog object and set common values
dlg = dialog.Dialog()
dlg.set_background_title(WINDOW_TITLE)

# if no settings file, create with defaults
if os.path.isfile(SETTINGS_FILE) == False:
    SETTINGS_DICT = {
        LEDT_SETTING : 0,
        LEDS_SETTING : 0,
        LEDN_SETTING : LEDN_DEFAULT,
        LEDF_SETTING : 0,
        LPT_SETTING : LPT_DEFAULT,
        LPA_SETTING : 0,
        PWR_SETTING : 0
        # add new settings here with their defaults
    }
    with open(SETTINGS_FILE, "w+") as file:
        json.dump(SETTINGS_DICT, file)
else:

    # file exists, read settings
    with open(SETTINGS_FILE, "rt") as file:
        SETTINGS_DICT = json.load(file)

    # add new settings here with their default

    # write new settings (if any) back to file
    with open(SETTINGS_FILE, "wt") as file:
        json.dump(SETTINGS_DICT, file)

# map joystick to keyboard if running RetroPie
# if os.path.isdir(JOY_2_KEY_DIR):
#
#     # TODO: RetroPie
#     # stolen from https://github.com/RetroPie/RetroPie-Setup/blob/master/scriptmodules/helpers.sh
#     # this code allows a joypad to navigate the dialogs when running on retropie
#     PID = subprocess.check_output(["pidof", "joy2key.py"])
#     if PID == "":
#         subprocess.call([
#             JOY_2_KEY_DIR + JOY_2_KEY_CMD,
#             JOY_2_KEY_DEVICE,
#             JOY_2_KEY_PARAMS
#         ])

# set up serial port
ser = serial.Serial(SERIAL_PORT, SERIAL_SPEED)

#-------------------------------------------------------------------------------
# Main loop

RES = doMain()
while RES == dlg.OK:
    RES = doMain()

#-------------------------------------------------------------------------------
# Cleanup

# TODO: does this work in retropie?
# clear screen
os.system('clear')

# python cleanup
sys.exit(0)

# -)
