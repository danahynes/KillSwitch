#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# killSwitch-settings.sh
# KillSwitch
#
# Copyright © 2019 Dana Hynes <danahynes@gmail.com>
# This work is free. You can redistribute it and/or modify it under the terms
# of the Do What The Fuck You Want To Public License, Version 2, as published
# by Sam Hocevar. See the LICENSE file for more details.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Constants

VERSION_NUMBER="0.5.1"

DEBUG=1

# TODO: hide this
GITHUB_TOKEN="3868839158c75239f3ed89a4aedfe620e72156b4"
GITHUB_URL="https://api.github.com/repos/danahynes/KillSwitch/releases/latest"

CHIP_ID=atmega328p

DIALOG_OK=0
DIALOG_CANCEL=1
DIALOG_ESCAPE=255

SETTINGS_DIR="${HOME}/.killswitch"
SETTINGS_FILE="${SETTINGS_DIR}/killswitch-settings.conf"

if [ $DEBUG -eq 1 ]; then

    # laptop (test) serial port
    SERIAL_PORT=/dev/pts/4
else

    # pi serial port
    SERIAL_PORT=/dev/ttyS0
    SERIAL_SPEED=9600
fi

LEDN_DEFAULT=255            # 0-255
LPT_DEFAULT=5               # in seconds

ACTION_START="?"
ACTION_SEPARATOR="|"
ACTION_END="!"

STATE_ON="on"
STATE_OFF="off"

WINDOW_TITLE="KillSwitch Settings v${VERSION_NUMBER} (c) 2019 Dana Hynes"
OK_LABEL="OK"
BACK_LABEL="Back"
EXIT_LABEL="Exit"
CANCEL_LABEL="Cancel"

MENU_TITLE="KillSwitch Settings"
MENU_TEXT="Choose an item:"
MENU_HEIGHT=14
MENU_WIDTH=40
MENU_ITEM_HEIGHT=7
MENU_TAGS=(\
    "1" \
    "2" \
    "3" \
    "4" \
    "5" \
    "6" \
    "7" \
)
MENU_ITEMS=(\
    "LED options" \
    "Start recording" \
    "Long press time" \
    "Long press action" \
    "Restart after power failure" \
    "Update" \
    "Uninstall" \
)
MENU_HELP=(\
	"Set the status LED options" \
	"Start recording new remote codes" \
	"Set how long to hold the button for a long press action" \
	"Set the action to take when the button is held" \
    "Automatically boot the Pi after a power failure if it was previously on" \
    "Check for updates to the software on the Pi and the firmware in the KillSwitch module" \
	"Uninstall all KillSwitch software from the Pi" \
)

LED_MENU_TITLE="LED Options"
LED_MENU_TEXT="Choose an item:"
LED_MENU_HEIGHT=11
LED_MENU_WIDTH=40
LED_MENU_ITEM_HEIGHT=10
LED_MENU_TAGS=(\
    "1" \
    "2" \
    "3" \
    "4" \
)
LED_MENU_ITEMS=(\
    "LED type" \
    "LED style" \
    "LED on brightness" \
    "LED off brightness" \
)
LED_MENU_HELP=(\
    "Set the LED type to normal, inverted, or off" \
    "Set the LED style to flash or pulse" \
    "Set the brightness when the LED is on" \
    "Set the brightness when the LED is off" \
)

LEDT_TITLE="LED type"
LEDT_TEXT="Set the LED type:"
LEDT_HEIGHT=10
LEDT_WIDTH=40
LEDT_ITEM_HEIGHT=3
LEDT_TAGS=("1" "2" "3")
LEDT_ITEMS=("Normal" "Inverted" "Off")
LEDT_HELP=(\
    "The LED is on when the Pi is on, and off when the Pi is off"\
    "The LED is off when the Pi is on, and on when the Pi is off"\
    "The LED is always off, except when programming"\
)
LEDT_SETTING="LTP"
LEDT_ACTION="LTP"

LEDS_TITLE="LED style"
LEDS_TEXT="Select the LED style:"
LEDS_HEIGHT=9
LEDS_WIDTH=40
LEDS_ITEM_HEIGHT=2
LEDS_TAGS=("1" "2")
LEDS_ITEMS=("Flash" "Pulse")
LEDS_SETTING="LPL"
LEDS_ACTION="LPL"

LEDN_TITLE="LED on brightness"
LEDN_TEXT="Set the LED on brightness (0-255):"
LEDN_HEIGHT=0
LEDN_WIDTH=40
LEDN_MIN=0
LEDN_MAX=255
LEDN_SETTING="LBN"
LEDN_ACTION="LBN"

LEDF_TITLE="LED off brightness"
LEDF_TEXT="Set the LED off brightness (0-255):"
LEDF_HEIGHT=0
LEDF_WIDTH=40
LEDF_MIN=0
LEDF_MAX=255
LEDF_SETTING="LBF"
LEDF_ACTION="LBF"

REC_TITLE="Start recording"
REC_TEXT="Press OK to start recording new codes on the device. The status LED \
will begin flashing rapidly. Point the remote at the device and press the \
button for 'on'. When you see the status LED flash once slowly, point the \
remote at the device and press the button for 'off'. When the LED flashes \
slowly twice, recording is complete."
REC_HEIGHT=14
REC_WIDTH=40
REC_ACTION="REC"

LPT_TITLE="Long press time"
LPT_TEXT="Set the long press time in seconds (1-10):"
LPT_HEIGHT=3
LPT_WIDTH=40
LPT_MIN=1
LPT_MAX=10
LPT_SETTING="LPT"
LPT_ACTION="LPT"

LPA_TITLE="Long press action"
LPA_TEXT="Set the long press action:"
LPA_HEIGHT=9
LPA_WIDTH=40
LPA_ITEM_HEIGHT=2
LPA_TAGS=("1" "2")
LPA_ITEMS=("Reboot" "Force quit")
LPA_SETTING="LPA"
LPA_ACTION="LPA"

PWR_TITLE="Restart after power failure"
PWR_TEXT="Check the setting to automatically boot after a power failure:"
PWR_HEIGHT=10
PWR_WIDTH=40
PWR_ITEM_HEIGHT=1
PWR_TAG="1"
PWR_ITEM="Restart after power failure"
PWR_SETTING="PWR"
PWR_ACTION="PWR"

UPDATE_TITLE="Update"
UPDATE_HEIGHT=13
UPDATE_WIDTH=40
UPDATE_TEXT_CURRENT="Current version: "
UPDATE_TEXT_NEW="Latest version:  "
UPDATE_UPDATE_TEXT="Are you sure you want to update KillSwitch?\n\n(Note that \
you will need a keyboard attached to enter the root password when the \
installer starts)"
UPDATE_OK_TEXT="Your firmware and software are up to date."

ERROR_TITLE="Error"
ERROR_TEXT_DOWNLOAD="There was an error downloading. Please check your \
internet connection and try again."
ERROR_TEXT_HARDWARE="There was an error updating the hardware. Please check \
your device connection and try again."
ERROR_TEXT_SOFTWARE="There was an error updating the software. Please check \
your device connection and try again."
ERROR_HEIGHT=10
ERROR_WIDTH=40

UNINSTALL_TITLE="Uninstall"
UNINSTALL_TEXT="Are you sure you want to uninstall KillSwitch?\n\n(Note that \
you will need a keyboard attached to enter the root password when the \
uninstaller starts)"
UNINSTALL_HEIGHT=10
UNINSTALL_WIDTH=40
UNINSTALL_COMMAND="/usr/local/bin/killswitch-uninstall.sh"

# NB don't change $scriptdir variable name (used by joy2keyStart)
scriptdir="${HOME}/RetroPie-Setup"

#-------------------------------------------------------------------------------
# Variables

MENU_DONE=0
MENU_SEL=""
LED_MENU_DONE=0
LED_MENU_SEL=""
LEDT_STATES=($STATE_ON $STATE_OFF $STATE_OFF)
LEDS_STATES=($STATE_ON $STATE_OFF)
LPA_STATES=($STATE_ON $STATE_OFF)
PWR_STATE=$STATE_OFF
UPDATE_TEXT=""
UPDATE_URL=""

#-------------------------------------------------------------------------------
# Helpers

function readPropsFile() {
    echo $(grep "${1}=" "${SETTINGS_FILE}" | cut -d "=" -f2)
}

function writePropsFile() {
    sed -i "s/^${1}=.*/${1}=${2}/g" "${SETTINGS_FILE}"
}

function readSerial() {
    read -r -t 30 LINE < $SERIAL_PORT
    echo "${LINE}"
}

function writeSerial() {
    CMD="${ACTION_START}${1}${ACTION_SEPARATOR}${2}${ACTION_END}"
    echo "${CMD}" > $SERIAL_PORT
}

#-------------------------------------------------------------------------------
# Screens

function doMain() {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$MENU_TITLE" \
    --cancel-label "$EXIT_LABEL" \
    --default-item "$MENU_SEL" \
    --item-help \
    --menu \
    "$MENU_TEXT" \
    $MENU_HEIGHT \
    $MENU_WIDTH \
    $MENU_ITEM_HEIGHT \
    "${MENU_TAGS[0]}" "${MENU_ITEMS[0]}" "${MENU_HELP[0]}" \
    "${MENU_TAGS[1]}" "${MENU_ITEMS[1]}" "${MENU_HELP[1]}" \
    "${MENU_TAGS[2]}" "${MENU_ITEMS[2]}" "${MENU_HELP[2]}" \
    "${MENU_TAGS[3]}" "${MENU_ITEMS[3]}" "${MENU_HELP[3]}" \
    "${MENU_TAGS[4]}" "${MENU_ITEMS[4]}" "${MENU_HELP[4]}" \
    "${MENU_TAGS[5]}" "${MENU_ITEMS[5]}" "${MENU_HELP[5]}" \
    "${MENU_TAGS[6]}" "${MENU_ITEMS[6]}" "${MENU_HELP[6]}" \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ ! $BTN -eq $DIALOG_OK ]; then
        MENU_DONE=1
        return
    fi

    MENU_SEL="$RESULT"
    if [ "$RESULT" = "${MENU_TAGS[0]}" ]; then
        LED_MENU_DONE=0
        while [ $LED_MENU_DONE -eq 0 ]; do
            doLEDMenu
        done
    elif [ "$RESULT" = "${MENU_TAGS[1]}" ]; then
        doStartRecording
    elif [ "$RESULT" = "${MENU_TAGS[2]}" ]; then
        doLongPressTime
    elif [ "$RESULT" = "${MENU_TAGS[3]}" ]; then
        doLongPressAction
    elif [ "$RESULT" = "${MENU_TAGS[4]}" ]; then
        doPower
    elif [ "$RESULT" = "${MENU_TAGS[5]}" ]; then
        doUpdate
    elif [ "$RESULT" = "${MENU_TAGS[6]}" ]; then
        doUninstall
    fi
}

function doLEDMenu () {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$LED_MENU_TITLE" \
    --cancel-label "$BACK_LABEL" \
    --default-item "$LED_MENU_SEL" \
    --item-help \
    --menu \
    "$LED_MENU_TEXT" \
    $LED_MENU_HEIGHT \
    $LED_MENU_WIDTH \
    $LED_MENU_ITEM_HEIGHT \
    "${LED_MENU_TAGS[0]}" "${LED_MENU_ITEMS[0]}" "${LED_MENU_HELP[0]}" \
    "${LED_MENU_TAGS[1]}" "${LED_MENU_ITEMS[1]}" "${LED_MENU_HELP[1]}" \
    "${LED_MENU_TAGS[2]}" "${LED_MENU_ITEMS[2]}" "${LED_MENU_HELP[2]}" \
    "${LED_MENU_TAGS[3]}" "${LED_MENU_ITEMS[3]}" "${LED_MENU_HELP[3]}" \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_CANCEL ]; then
        LED_MENU_DONE=1
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        LED_MENU_DONE=1
        MENU_DONE=1
        return
    fi

    LED_MENU_SEL="$RESULT"
    if [ "$RESULT" = "${LED_MENU_TAGS[0]}" ]; then
        doLEDType
    elif [ "$RESULT" = "${LED_MENU_TAGS[1]}" ]; then
        doLEDStyle
    elif [ "$RESULT" = "${LED_MENU_TAGS[2]}" ]; then
        doLEDOnBrightness
    elif [ "$RESULT" = "${LED_MENU_TAGS[3]}" ]; then
        doLEDOffBrightness
    fi
}

function doLEDType() {
    LEDT_VALUE=$(readPropsFile $LEDT_SETTING)

    # set highlighted item
    LEDT_HIGHLIGHT="${LEDT_ITEMS[$LEDT_VALUE]}"

    # size of array
    SIZE=${#LEDT_STATES[@]}

    # all off
    for (( i=0; i<$SIZE; i++ )); do
        LEDT_STATES[i]=$STATE_OFF
    done

    # set checked item
    LEDT_STATES[$LEDT_VALUE]=$STATE_ON

    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$LEDT_TITLE" \
    --cancel-label "$BACK_LABEL" \
    --default-item "$LEDT_HIGHLIGHT" \
    --item-help \
    --radiolist \
    "$LEDT_TEXT" \
    $LEDT_HEIGHT \
    $LEDT_WIDTH \
    $LEDT_ITEM_HEIGHT \
    "${LEDT_TAGS[0]}" "${LEDT_ITEMS[0]}" "${LEDT_STATES[0]}" "${LEDT_HELP[0]}" \
    "${LEDT_TAGS[1]}" "${LEDT_ITEMS[1]}" "${LEDT_STATES[1]}" "${LEDT_HELP[1]}" \
    "${LEDT_TAGS[2]}" "${LEDT_ITEMS[2]}" "${LEDT_STATES[2]}" "${LEDT_HELP[2]}" \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # save highlighted/selected item
        for (( i=0; i<$SIZE; i++ )); do
            if [ "${LEDT_TAGS[i]}" = "$RESULT" ]; then
                writePropsFile $LEDT_SETTING $i
                writeSerial $LEDT_ACTION $i
                break
            fi
        done
    elif [ $BTN == $DIALOG_ESCAPE ]; then
        LED_MENU_DONE=1
        MENU_DONE=1
    fi
}

function doLEDStyle() {
    LEDS_VALUE=$(readPropsFile $LEDS_SETTING)

    # set highlighted item
    LEDS_HIGHLIGHT="${LEDS_ITEMS[$LEDS_VALUE]}"

    # size of array
    SIZE=${#LEDS_STATES[@]}

    # all off
    for (( i=0; i<$SIZE; i++ )); do
        LEDS_STATES[i]=$STATE_OFF
    done

    # set checked item
    LEDS_STATES[$LEDS_VALUE]=$STATE_ON

    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$LEDS_TITLE" \
    --cancel-label "$BACK_LABEL" \
    --default-item "$LEDS_HIGHLIGHT" \
    --radiolist \
    "$LEDS_TEXT" \
    $LEDS_HEIGHT \
    $LEDS_WIDTH \
    $LEDS_ITEM_HEIGHT \
    "${LEDS_TAGS[0]}" "${LEDS_ITEMS[0]}" "${LEDS_STATES[0]}" \
    "${LEDS_TAGS[1]}" "${LEDS_ITEMS[1]}" "${LEDS_STATES[1]}" \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # save highlighted/selected item
        for (( i=0; i<$SIZE; i++ )); do
            if [ "${LEDS_TAGS[i]}" = "$RESULT" ]; then
                writePropsFile $LEDS_SETTING $i
                writeSerial $LEDS_ACTION $i
                break
            fi
        done
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        LED_MENU_DONE=1
        MENU_DONE=1
    fi
}

function doLEDOnBrightness() {
    LEDN_VALUE=$(readPropsFile $LEDN_SETTING)

    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$LEDN_TITLE" \
    --cancel-label "$BACK_LABEL" \
    --rangebox \
    "$LEDN_TEXT" \
    $LEDN_HEIGHT \
    $LEDN_WIDTH \
    $LEDN_MIN \
    $LEDN_MAX \
    $LEDN_VALUE \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # trim whitespace
        RESULT=$(echo $RESULT | xargs)
        writePropsFile $LEDN_SETTING $RESULT
        writeSerial $LEDN_ACTION $RESULT
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        LED_MENU_DONE=1
        MENU_DONE=1
    fi
}

function doLEDOffBrightness() {
    LEDF_VALUE=$(readPropsFile $LEDF_SETTING)

    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$LEDF_TITLE" \
    --cancel-label "$BACK_LABEL" \
    --rangebox \
    "$LEDF_TEXT" \
    $LEDF_HEIGHT \
    $LEDF_WIDTH \
    $LEDF_MIN \
    $LEDF_MAX \
    $LEDF_VALUE \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # trim whitespace
        RESULT=$(echo $RESULT | xargs)
        writePropsFile $LEDF_SETTING $RESULT
        writeSerial $LEDF_ACTION $RESULT
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        LED_MENU_DONE=1
        MENU_DONE=1
    fi
}

function doStartRecording() {
	RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$REC_TITLE" \
    --yes-label "$OK_LABEL" \
    --no-label "$BACK_LABEL" \
    --yesno \
    "$REC_TEXT" \
    $REC_HEIGHT \
    $REC_WIDTH \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then
         writeSerial $REC_ACTION ""
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doLongPressTime() {
    LPT_VALUE=$(readPropsFile $LPT_SETTING)

    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$LPT_TITLE" \
    --cancel-label "$BACK_LABEL" \
    --rangebox \
    "$LPT_TEXT" \
    $LPT_HEIGHT \
    $LPT_WIDTH \
    $LPT_MIN \
    $LPT_MAX \
    $LPT_VALUE \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # trim whitespace
        RESULT=$(echo $RESULT | xargs)
        writePropsFile $LPT_SETTING $RESULT
        writeSerial $LPT_ACTION $RESULT
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doLongPressAction() {
    LPA_VALUE=$(readPropsFile $LPA_SETTING)

    # set highlighted item
    LPA_HIGHLIGHT="${LPA_ITEMS[$LPA_VALUE]}"

    # size of array
    SIZE=${#LPA_STATES[@]}

    # all off
    for (( i=0; i<$SIZE; i++ )); do
        LPA_STATES[i]=$STATE_OFF
    done

    # set checked item
    LPA_STATES[$LPA_VALUE]=$STATE_ON

    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$LPA_TITLE" \
    --cancel-label "$BACK_LABEL" \
    --default-item "$LPA_HIGHLIGHT" \
    --radiolist \
    "$LPA_TEXT" \
    $LPA_HEIGHT \
    $LPA_WIDTH \
    $LPA_ITEM_HEIGHT\
    "${LPA_TAGS[0]}" "${LPA_ITEMS[0]}" "${LPA_STATES[0]}" \
    "${LPA_TAGS[1]}" "${LPA_ITEMS[1]}" "${LPA_STATES[1]}" \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # save highlighted/selected item
        for (( i=0; i<$SIZE; i++ )); do
            if [ "${LPA_TAGS[i]}" = "$RESULT" ]; then
                writePropsFile $LPA_SETTING $i
                writeSerial $LPA_ACTION $i
                break
            fi
        done
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doPower() {
    PWR_VALUE=$(readPropsFile $PWR_SETTING)

    PWR_STATE=$STATE_OFF

    # set checked state
    if [ $PWR_VALUE -eq 1 ]; then
        PWR_STATE=$STATE_ON
    fi

    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$PWR_TITLE" \
    --cancel-label "$BACK_LABEL" \
    --default-item "$PWR_HIGHLIGHT" \
    --checklist \
    "$PWR_TEXT" \
    $PWR_HEIGHT \
    $PWR_WIDTH \
    $PWR_ITEM_HEIGHT\
    "${PWR_TAG}" "${PWR_ITEM}" "${PWR_STATE}" \
    3>&1 1>&2 2>&3 3>&-)

    if [ ! "$RESULT" == "1" ]; then
        RESULT="0"
    fi

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # save highlighted/selected item
        writePropsFile $PWR_SETTING $RESULT
        writeSerial $PWR_ACTION $RESULT
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doDownloadError() {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$ERROR_TITLE" \
    --msgbox \
    "$ERROR_TEXT_DOWNLOAD" \
    $ERROR_HEIGHT \
    $ERROR_WIDTH \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doHardwareUpdateError() {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$ERROR_TITLE" \
    --msgbox \
    "$ERROR_TEXT_HARDWARE" \
    $ERROR_HEIGHT \
    $ERROR_WIDTH \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doSoftwareUpdateError() {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$ERROR_TITLE" \
    --msgbox \
    "$ERROR_TEXT_SOFTWARE" \
    $ERROR_HEIGHT \
    $ERROR_WIDTH \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doActualUpdate() {
    RESULT=$(dialog \
            --backtitle "${WINDOW_TITLE}" \
            --title "${UPDATE_TITLE}" \
            --yesno \
            "${UPDATE_TEXT}" \
            $UPDATE_HEIGHT \
            $UPDATE_WIDTH \
            3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        cd "${SETTINGS_DIR}"

        # get lastest release from github and save to settings dir
        RES=$(curl \
                -H "Authorization: token ${GITHUB_TOKEN}" \
                -H "Accept: application/vnd.github.v3.raw" \
                -O \
                -L \
                -s \
                "${UPDATE_URL}")

        RES=$?
        if [ $RES -ne 0 ]; then
            doDownloadError
            return
        else

            # time to get to work!

            # first unzip the file
            ZIP_NAME=$(basename "${UPDATE_URL}")
            LONG_NAME=$(echo $(unzip -qql "${ZIP_NAME}" | head -n1 | tr -s ' ' \
                    | cut -d ' ' -f5-))
            unzip -qq "${ZIP_NAME}"
            mv "${LONG_NAME}" "KillSwitch-${ZIP_NAME}"
            rm "${ZIP_NAME}" > /dev/null
            cd "KillSwitch-${ZIP_NAME}"

            # NB: do hardware first because software may cause reboot

            # do avrdude update with hex file
            cd Firmware/
            FIRMWARE_FILE=$(find . -name "killswitch-firmware_*.hex")
            avrdude \
                    -p "${CHIP_ID}" \
                    -C +"${SETTINGS_DIR}/killswitch-avrdude.conf" \
                    -c "killswitch" \
                    -U flash:w:"${FIRMWARE_FILE}":i \
                    -U flash:v:"${FIRMWARE_FILE}":i

            RES=$?
            if [ $RES -ne 0 ]; then
                doHardwareUpdateError

                # TODO: don't return here if we can still try software update
                return
            fi

            # run installer for software
            cd ../Software/Bash/
            sudo ./killswitch-install.sh

            RES=$?
            if [ $RES -ne 0 ]; then
                doSoftwareUpdateError
                return
            fi

            # remove unzipped folder
            cd ../../..
            rm -r "KillSwitch-${ZIP_NAME}"

            # run new settings and close this one
            killswitch-settings.sh
            exit
        fi
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doIsUpToDate() {
    RESULT=$(dialog \
            --backtitle "$WINDOW_TITLE" \
            --title "$UPDATE_TITLE" \
            --msgbox \
            "$UPDATE_TEXT" \
            $UPDATE_HEIGHT \
            $UPDATE_WIDTH \
            3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doUpdate() {

    # get version number from us (we all use the same number)
    LOCAL_VERSION_NUMBER=${VERSION_NUMBER}

    # break up current version number
    LOCAL_VERSION_NUMBER_A=$(echo $LOCAL_VERSION_NUMBER | \
            cut -d "." -f1)
    LOCAL_VERSION_NUMBER_B=$(echo $LOCAL_VERSION_NUMBER | \
            cut -d "." -f2)
    LOCAL_VERSION_NUMBER_C=$(echo $LOCAL_VERSION_NUMBER | \
            cut -d "." -f3)

    # get lastest firmware version from github
    JSON=$(curl \
            -H "Authorization: token ${GITHUB_TOKEN}" \
            -H "Accept: application/vnd.github.v3.raw" \
            -s \
            "${GITHUB_URL}")

    if [ $? -ne 0 ]; then
        doDownloadError
        return
    fi

    UPDATE_URL=$(echo "${JSON}" | grep 'zipball_url' | cut -d '"' -f 4)
    ZIP_NAME=$(basename "${UPDATE_URL}")
    REMOTE_VERSION_NUMBER=$(echo "${ZIP_NAME}" | cut -d 'v' -f 2)

    # break up remote version number
    REMOTE_VERSION_NUMBER_A=$(echo \
            $REMOTE_VERSION_NUMBER | cut -d "." -f1)
    REMOTE_VERSION_NUMBER_B=$(echo \
            $REMOTE_VERSION_NUMBER | cut -d "." -f2)
    REMOTE_VERSION_NUMBER_C=$(echo \
            $REMOTE_VERSION_NUMBER | cut -d "." -f3)

    # do comparison
    IS_NEWER=0

    if [ $LOCAL_VERSION_NUMBER_A -lt \
            $REMOTE_VERSION_NUMBER_A ]; then
        IS_NEWER=1
    elif [ $LOCAL_VERSION_NUMBER_B -lt \
            $REMOTE_VERSION_NUMBER_B ]; then
        IS_NEWER=1
    elif [ $LOCAL_VERSION_NUMBER_C -lt \
            $REMOTE_VERSION_NUMBER_C ]; then
        IS_NEWER=1
    fi

    # update text with version/build numbers
    UPDATE_TEXT="${UPDATE_TEXT_CURRENT}"
    UPDATE_TEXT+="${LOCAL_VERSION_NUMBER}\n"
    UPDATE_TEXT+="${UPDATE_TEXT_NEW}"
    UPDATE_TEXT+="${REMOTE_VERSION_NUMBER}\n"
    UPDATE_TEXT+="\n"

    #if newer, do yes/no
    if [ $IS_NEWER -eq 1 ]; then
        UPDATE_TEXT+="$UPDATE_UPDATE_TEXT"
        doActualUpdate

    # show message "up to date"
    else
        UPDATE_TEXT+="$UPDATE_OK_TEXT"
        doIsUpToDate
    fi
}

function doUninstall() {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$UNINSTALL_TITLE" \
    --yesno \
    "$UNINSTALL_TEXT" \
    $UNINSTALL_HEIGHT \
    $UNINSTALL_WIDTH \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # run uninstaller
        sudo "$UNINSTALL_COMMAND"
        MENU_DONE=1
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

#-------------------------------------------------------------------------------
# Init

# check if file exists
if [ ! -f "${SETTINGS_FILE}" ]; then

    # if not, write defaults
    touch "${SETTINGS_FILE}"
    echo $LEDT_SETTING"=0" >> "${SETTINGS_FILE}"
    echo $LEDS_SETTING"=0" >> "${SETTINGS_FILE}"
    echo $LEDN_SETTING"="$LEDN_DEFAULT >> "${SETTINGS_FILE}"
    echo $LEDF_SETTING"=0" >> "${SETTINGS_FILE}"
    echo $LPT_SETTING"="$LPT_DEFAULT >> "${SETTINGS_FILE}"
    echo $LPA_SETTING"=0" >> "${SETTINGS_FILE}"
    echo $PWR_SETTING"=0" >> "${SETTINGS_FILE}"
else

    # write defaults for any missing settings
    VALUE=$(readPropsFile $LEDT_SETTING)
    if [ "$VALUE" == "" ]; then
        echo $LEDT_SETTING"=0" >> "${SETTINGS_FILE}"
    fi
    VALUE=$(readPropsFile $LEDS_SETTING)
    if [ "$VALUE" == "" ]; then
        echo $LEDS_SETTING"=0" >> "${SETTINGS_FILE}"
    fi
    VALUE=$(readPropsFile $LEDN_SETTING)
    if [ "$VALUE" == "" ]; then
        echo $LEDN_SETTING"="$LEDN_DEFAULT >> "${SETTINGS_FILE}"
    fi
    VALUE=$(readPropsFile $LEDF_SETTING)
    if [ "$VALUE" == "" ]; then
        echo $LEDF_SETTING"=0" >> "${SETTINGS_FILE}"
    fi
    VALUE=$(readPropsFile $LPT_SETTING)
    if [ "$VALUE" == "" ]; then
        echo $LPT_SETTING"="$LPT_DEFAULT >> "${SETTINGS_FILE}"
    fi
    VALUE=$(readPropsFile $LPA_SETTING)
    if [ "$VALUE" == "" ]; then
        echo $LPA_SETTING"=0" >> "${SETTINGS_FILE}"
    fi
    VALUE=$(readPropsFile $PWR_SETTING)
    if [ "$VALUE" == "" ]; then
        echo $PWR_SETTING"=0" >> "${SETTINGS_FILE}"
    fi
fi


# map joystick to keyboard if running RetroPie
if [ -d $scriptdir ]; then
    source "$scriptdir/scriptmodules/helpers.sh"
	joy2keyStart
fi

# set up serial port
stty -F $SERIAL_PORT speed $SERIAL_SPEED -cstopb -parenb cs8 > /dev/null 2>&1

#-------------------------------------------------------------------------------
# Main loop

while [ $MENU_DONE -eq 0 ]; do
    doMain
done

#-------------------------------------------------------------------------------
# Cleanup

# TODO: does this work in retropie?
clear

# -)
