#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# killSwitch-settings.sh
# KillSwitch
#
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Constants

VERSION_NUMBER="0.1"
VERSION_BUILD="19.01.26"

DIALOG_OK=0
DIALOG_CANCEL=1
DIALOG_ESCAPE=255

SETTINGS_DIR="${HOME}/.killswitch"
SETTINGS_FILE="${SETTINGS_DIR}/killswitch-settings.conf"

# TODO: change serial port
SERIAL_PORT=/dev/pts/5
SERIAL_SPEED=9600

LEDB_DEFAULT=255            # 0-255
LPT_DEFAULT=5               # in seconds

ACTION_START="?"
ACTION_SEPARATOR="|"
ACTION_END="!"

STATE_ON="on"
STATE_OFF="off"

WINDOW_TITLE="KillSwitch Settings v${VERSION_NUMBER} (${VERSION_BUILD}) \
(c) 2019 Dana Hynes"
OK_LABEL="OK"
BACK_LABEL="Back"
EXIT_LABEL="Exit"
CANCEL_LABEL="Cancel"

MENU_TITLE="KillSwitch Settings"
MENU_TEXT="Choose an item:"
MENU_HEIGHT=16
MENU_WIDTH=40
MENU_ITEM_HEIGHT=9
MENU_TAGS=(\
    "1" \
    "2" \
    "3" \
    "4" \
    "5" \
    "6" \
    "7" \
    "8" \
    "9" \
)
MENU_ITEMS=(\
    "Status LED options" \
    "Start recording" \
    "Long press time" \
    "Long press action" \
    "Firmware update" \
    "Shutdown" \
    "Reboot" \
    "Uninstall" \
    "Exit" \
)
MENU_HELP=(\
	"Set the status LED options" \
	"Start recording new remote codes" \
	"Set how long to hold the button for a long press action" \
	"Set the action to take when the button is held" \
	"Update the code in the KillSwitch module" \
	"Shut down the Raspberry Pi" \
	"Reboot the Raspberry Pi" \
	"Uninstall all KillSwitch files" \
	"Quit this program" \
)

LED_MENU_TITLE="LED Options"
LED_MENU_TEXT="Choose an item:"
LED_MENU_HEIGHT=11
LED_MENU_WIDTH=40
LED_MENU_ITEM_HEIGHT=9
LED_MENU_TAGS=(\
    "1" \
    "2" \
    "3" \
    "4" \
)
LED_MENU_ITEMS=(\
    "LED on/off" \
    "LED brightness" \
    "LED type" \
    "LED state" \
)
LED_MENU_HELP=(\
    "Turn the LED on or off" \
    "Set the LED brightness" \
    "Set the LED type to flash or pulse" \
    "Set whether the LED is on when the pi is on, or vice versa"
)

LEDO_TITLE="LED on/off"
LEDO_TEXT="Turn the LED on or off"
LEDO_HEIGHT=10
LEDO_WIDTH=40
LEDO_ITEM_HEIGHT=2
LEDO_TAGS=("1" "2")
LEDO_ITEMS=("On" "Off")
LEDO_SETTING="LEDO"
LEDO_ACTION="LEDO"

LEDB_TITLE="LED brightness"
LEDB_TEXT="Set the LED brightness (0 - 255):"
LEDB_HEIGHT=3
LEDB_WIDTH=40
LEDB_MIN=0
LEDB_MAX=255
LEDB_SETTING="LEDB"
LEDB_ACTION="LEDB"

LEDT_TITLE="LED type"
LEDT_TEXT="Select the LED type:"
LEDT_HEIGHT=10
LEDT_WIDTH=40
LEDT_ITEM_HEIGHT=2
LEDT_TAGS=("1" "2")
LEDT_ITEMS=("Flash" "Pulse")
LEDT_SETTING="LEDT"
LEDT_ACTION="LEDT"

LEDS_TITLE="LED state"
LEDS_TEXT="Select whether to invert the LED state:"
LEDS_HEIGHT=10
LEDS_WIDTH=40
LEDS_ITEM_HEIGHT=2
LEDS_TAGS=("1" "2")
LEDS_ITEMS=("Normal" "Invert")
LEDS_SETTING="LEDS"
LEDS_ACTION="LEDS"

REC_TITLE="Record new remote codes"
REC_TEXT="Press OK to start recording new codes on the device. The status LED \
will begin flashing rapidly. Point the remote at the device and press the \
button for 'on'. When you see the status LED flash once slowly, point the \
remote at the device and press the button for 'off'. When the LED flashes \
slowly twice, recording is complete."
REC_HEIGHT=14
REC_WIDTH=40
REC_ACTION="REC"

LPT_TITLE="Long press time"
LPT_TEXT="Set the long press time in seconds (1 - 10):"
LPT_HEIGHT=3
LPT_WIDTH=40
LPT_MIN=1
LPT_MAX=10
LPT_SETTING="LPT"
LPT_ACTION="LPT"

LPA_TITLE="Long press action"
LPA_TEXT="Set the long press action:"
LPA_HEIGHT=10
LPA_WIDTH=40
LPA_ITEM_HEIGHT=2
LPA_TAGS=("1" "2")
LPA_ITEMS=("Reboot" "Force quit")
LPA_SETTING="LPA"
LPA_ACTION="LPA"

FIRMWARE_TITLE="Firmware update"
FIRMWARE_TEXT=""
FIRMWARE_HEIGHT=12
FIRMWARE_WIDTH=40
FIRMWARE_TEXT_CURRENT="Current version: "
FIRMWARE_TEXT_NEW="Latest version:  "
FIRMWARE_UPDATE_TEXT="Are you sure you want to update?"
FIRMWARE_OK_TEXT="Your firmware is up to date."

# TODO: hide this
FIRMWARE_TOKEN="3868839158c75239f3ed89a4aedfe620e72156b4"
FIRMWARE_REMOTE_REPO=\
"https://api.github.com/repos/danahynes/KillSwitch/contents/Arduino"

FIRMWARE_REMOTE_FILE_NAME="version.txt"
FIRMWARE_REMOTE_VERSION_FILE=\
"${FIRMWARE_REMOTE_REPO}/${FIRMWARE_REMOTE_FILE_NAME}"
FIRMWARE_REMOTE_COPY_VERSION_FILE=\
"${SETTINGS_DIR}/${FIRMWARE_REMOTE_FILE_NAME}"

FIRMWARE_REMOTE_VERSION_NUMBER=""
FIRMWARE_REMOTE_VERSION_BUILD=""

FIRMWARE_REMOTE_HEX_BASE_FILE="killswitch-firmware"
FIRMWARE_REMOTE_HEX_FILE=\
"${FIRMWARE_REMOTE_REPO}/${FIRMWARE_REMOTE_HEX_BASE_FILE}-\
${FIRMWARE_REMOTE_VERSION_NUMBER}-${FIRMWARE_REMOTE_VERSION_BUILD}.hex"
FIRMWARE_REMOTE_COPY_HEX_FILE=\
"${SETTINGS_DIR}/${FIRMWARE_REMOTE_COPY_HEX_BASE_FILE}-\
${FIRMWARE_REMOTE_VERSION_NUMBER}-${FIRMWARE_REMOTE_VERSION_BUILD}.hex"

ERROR_TITLE="Error"
ERROR_TEXT="There was an error downloading. Please check your internet \
connection and try again."
ERROR_HEIGHT=10
ERROR_WIDTH=40

SHUTDOWN_TITLE="Shutdown"
SHUTDOWN_TEXT="Are you sure you want to shut down?"
SHUTDOWN_HEIGHT=7
SHUTDOWN_WIDTH=40
SHUTDOWN_COMMAND="sudo shutdown -h now"

REBOOT_TITLE="Reboot"
REBOOT_TEXT="Are you sure you want to reboot?"
REBOOT_HEIGHT=7
REBOOT_WIDTH=40
REBOOT_COMMAND="sudo shutdown -r now"

UNINSTALL_TITLE="Uninstall"
UNINSTALL_TEXT="Are you sure you want to uninstall KillSwitch?"
UNINSTALL_HEIGHT=7
UNINSTALL_WIDTH=40
UNINSTALL_COMMAND="/usr/local/bin/killswitch-uninstall.sh"

# N.B. don't change $scriptdir name (used by joy2keyStart)
scriptdir="${HOME}/RetroPie-Setup"

#-------------------------------------------------------------------------------
# Variables

MENU_DONE=0
MENU_SEL=""
LED_MENU_DONE=0
LED_MENU_SEL=""
LEDO_STATES=($STATE_ON $STATE_OFF)
LEDT_STATES=($STATE_ON $STATE_OFF)
LEDS_STATES=($STATE_ON $STATE_OFF)
LPA_STATES=($STATE_ON $STATE_OFF)

#-------------------------------------------------------------------------------
# Helpers

function readPropsFile() {
    echo $(grep "${1}=" "$SETTINGS_FILE" | cut -d "=" -f2)
}

function writePropsFile() {
    sed -i "s/^${1}=.*/${1}=${2}/g" "$SETTINGS_FILE"
}

function readSerial() {
    if [ read -r LINE < $SERIAL_PORT ]; then
        echo $LINE
    fi
}

function writeSerial() {
    CMD="${ACTION_START}${1}${ACTION_SEPARATOR}${2}${ACTION_END}"
    echo "$CMD" > $SERIAL_PORT
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
    "${MENU_TAGS[7]}" "${MENU_ITEMS[7]}" "${MENU_HELP[7]}" \
    "${MENU_TAGS[8]}" "${MENU_ITEMS[8]}" "${MENU_HELP[8]}" \
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
        doFirmware
    elif [ "$RESULT" = "${MENU_TAGS[5]}" ]; then
        doShutdown
    elif [ "$RESULT" = "${MENU_TAGS[6]}" ]; then
        doReboot
    elif [ "$RESULT" = "${MENU_TAGS[7]}" ]; then
    	doUninstall
    elif [ "$RESULT" = "${MENU_TAGS[8]}" ]; then
        doExit
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
        doLEDOn
    elif [ "$RESULT" = "${LED_MENU_TAGS[1]}" ]; then
        doLEDBrightness
    elif [ "$RESULT" = "${LED_MENU_TAGS[2]}" ]; then
        doLEDType
    elif [ "$RESULT" = "${LED_MENU_TAGS[3]}" ]; then
        doLEDState
    fi
}

function doLEDOn() {
    LEDO_VALUE=$(readPropsFile $LEDO_SETTING)

    # set highlighted item
    LEDO_HIGHLIGHT="${LEDO_ITEMS[$LEDO_VALUE]}"

    # size of array
    SIZE=${#LEDO_STATES[@]}

    # all off
    for (( i=0; i<$SIZE; i++ )); do
        LEDO_STATES[i]=$STATE_OFF
    done

    # set checked item
    LEDO_STATES[$LEDO_VALUE]=$STATE_ON

    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$LEDO_TITLE" \
    --cancel-label "$BACK_LABEL" \
    --default-item "$LEDO_HIGHLIGHT" \
    --radiolist \
    "$LEDO_TEXT" \
    $LEDO_HEIGHT \
    $LEDO_WIDTH \
    $LEDO_ITEM_HEIGHT \
    "${LEDO_TAGS[0]}" "${LEDO_ITEMS[0]}" "${LEDO_STATES[0]}" \
    "${LEDO_TAGS[1]}" "${LEDO_ITEMS[1]}" "${LEDO_STATES[1]}" \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # save highlighted/selected item
        for (( i=0; i<$SIZE; i++ )); do
            if [ "${LEDO_TAGS[i]}" = "$RESULT" ]; then
                writePropsFile $LEDO_SETTING $i
                writeSerial $LEDO_ACTION $i
                break
            fi
        done
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        LED_MENU_DONE=1
        MENU_DONE=1
    fi
}

function doLEDBrightness() {
    LEDB_VALUE=$(readPropsFile $LEDB_SETTING)

    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$LEDB_TITLE" \
    --cancel-label "$BACK_LABEL" \
    --rangebox \
    "$LEDB_TEXT" \
    $LEDB_HEIGHT \
    $LEDB_WIDTH \
    $LEDB_MIN \
    $LEDB_MAX \
    $LEDB_VALUE \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # trim whitespace
        RESULT=$(echo $RESULT | xargs)
        writePropsFile $LEDB_SETTING $RESULT
        writeSerial $LEDB_ACTION $RESULT
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        LED_MENU_DONE=1
        MENU_DONE=1
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
    --radiolist \
    "$LEDT_TEXT" \
    $LEDT_HEIGHT \
    $LEDT_WIDTH \
    $LEDT_ITEM_HEIGHT \
    "${LEDT_TAGS[0]}" "${LEDT_ITEMS[0]}" "${LEDT_STATES[0]}" \
    "${LEDT_TAGS[1]}" "${LEDT_ITEMS[1]}" "${LEDT_STATES[1]}" \
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
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        LED_MENU_DONE=1
        MENU_DONE=1
    fi
}

function doLEDState() {
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
    elif [ $BTN == $DIALOG_ESCAPE ]; then
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
         $REC_ACTION ""
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

function doError() {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$ERROR_TITLE" \
    --msgbox \
    "$ERROR_TEXT" \
    $ERROR_HEIGHT \
    $ERROR_WIDTH \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doUpdateFirmware() {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$FIRMWARE_TITLE" \
    --yesno \
    "$FIRMWARE_TEXT" \
    $FIRMWARE_HEIGHT \
    $FIRMWARE_WIDTH \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then

        # get lastest firmware from github
        RES=$(curl \
        -H "Authorization: token ${FIRMWARE_TOKEN}" \
        -H "Accept: application/vnd.github.v3.raw" \
        -L "${FIRMWARE_REMOTE_HEX_FILE}" \
        -o "${FIRMWARE_REMOTE_COPY_HEX_FILE}" \
        -s \
        > /dev/null)

        RES=$?
        if [ $RES -ne 0 ]; then
            doError
            return
        else
            # do avrdude update with hex file
            avrdude \
            -p atmega328p \
            -C "/etc/avrdude.conf" \
            -c "killswitch" \
            -U flash:w:${FIRMWARE_REMOTE_COPY_HEX_FILE}:i

            # remove hex file
            rm "$FIRMWARE_REMOTE_COPY_HEX_FILE"
        fi
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doIsUpToDate() {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$FIRMWARE_TITLE" \
    --msgbox \
    "$FIRMWARE_TEXT" \
    $FIRMWARE_HEIGHT \
    $FIRMWARE_WIDTH \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doFirmware() {

    # get current version from arduino
    writeSerial "VER" ""
    # TODO: read serial, this is faked
    #FIRMWARE_LOCAL_VERSION_NUMBER=readSerial
    #FIRMWARE_LOCAL_VERSION_BUILD=readSerial
    FIRMWARE_LOCAL_VERSION_NUMBER="0.1"
    FIRMWARE_LOCAL_VERSION_BUILD="19.01.24"

    FIRMWARE_LOCAL_VERSION_NUMBER_A=$(echo $FIRMWARE_LOCAL_VERSION_NUMBER | \
    cut -d "." -f1)
    FIRMWARE_LOCAL_VERSION_NUMBER_B=$(echo $FIRMWARE_LOCAL_VERSION_NUMBER | \
    cut -d "." -f2)
    FIRMWARE_LOCAL_VERSION_BUILD_A=$(echo $FIRMWARE_LOCAL_VERSION_BUILD | \
    cut -d "." -f1)
    FIRMWARE_LOCAL_VERSION_BUILD_B=$(echo $FIRMWARE_LOCAL_VERSION_BUILD | \
    cut -d "." -f2)
    FIRMWARE_LOCAL_VERSION_BUILD_C=$(echo $FIRMWARE_LOCAL_VERSION_BUILD | \
    cut -d "." -f3)

    # get lastest firmware version from github
    RESULT=$(curl \
    -H "Authorization: token ${FIRMWARE_TOKEN}" \
    -H "Accept: application/vnd.github.v3.raw" \
    -L "${FIRMWARE_REMOTE_VERSION_FILE}" \
    -o "${FIRMWARE_REMOTE_COPY_VERSION_FILE}" \
    -s \
    > /dev/null)

    RES=$?
    if [ $RES -ne 0 ]; then
        doError
        return
    else
        FIRMWARE_REMOTE_VERSION_NUMBER=$(grep "VERSION_NUMBER=" \
        "${FIRMWARE_REMOTE_COPY_VERSION_FILE}" | cut -d "=" -f2)
        FIRMWARE_REMOTE_VERSION_BUILD=$(grep "VERSION_BUILD=" \
        "${FIRMWARE_REMOTE_COPY_VERSION_FILE}" | cut -d "=" -f2)

        FIRMWARE_REMOTE_VERSION_NUMBER_A=$(echo \
        $FIRMWARE_REMOTE_VERSION_NUMBER | cut -d "." -f1)
        FIRMWARE_REMOTE_VERSION_NUMBER_B=$(echo \
        $FIRMWARE_REMOTE_VERSION_NUMBER | cut -d "." -f2)
        FIRMWARE_REMOTE_VERSION_BUILD_A=$(echo \
        $FIRMWARE_REMOTE_VERSION_BUILD | cut -d "." -f1)
        FIRMWARE_REMOTE_VERSION_BUILD_B=$(echo \
        $FIRMWARE_REMOTE_VERSION_BUILD | cut -d "." -f2)
        FIRMWARE_REMOTE_VERSION_BUILD_C=$(echo \
        $FIRMWARE_REMOTE_VERSION_BUILD | cut -d "." -f3)
    fi

    # do comparison
    IS_NEWER=1

    if [ $FIRMWARE_LOCAL_VERSION_NUMBER_A -gt \
    $FIRMWARE_REMOTE_VERSION_NUMBER_A ]; then
        IS_NEWER=0
    elif [ $FIRMWARE_LOCAL_VERSION_NUMBER_B -gt \
    $FIRMWARE_REMOTE_VERSION_NUMBER_B ]; then
        IS_NEWER=0
    elif [ $FIRMWARE_LOCAL_VERSION_BUILD_A -gt \
    $FIRMWARE_REMOTE_VERSION_BUILD_A ]; then
        IS_NEWER=0
    elif [ $FIRMWARE_LOCAL_VERSION_BUILD_B -gt \
    $FIRMWARE_REMOTE_VERSION_BUILD_B ]; then
        IS_NEWER=0
    elif [ $FIRMWARE_LOCAL_VERSION_BUILD_C -gt \
    $FIRMWARE_REMOTE_VERSION_BUILD_C ]; then
        IS_NEWER=0
    fi

    # remove local version file
    rm "${FIRMWARE_REMOTE_COPY_VERSION_FILE}"

    # update text with version/build numbers
    FIRMWARE_TEXT="$FIRMWARE_TEXT_CURRENT"
    FIRMWARE_TEXT+="${FIRMWARE_LOCAL_VERSION_NUMBER}-"
    FIRMWARE_TEXT+="${FIRMWARE_LOCAL_VERSION_BUILD} \n"
    FIRMWARE_TEXT+="$FIRMWARE_TEXT_NEW"
    FIRMWARE_TEXT+="${FIRMWARE_REMOTE_VERSION_NUMBER}-"
    FIRMWARE_TEXT+="${FIRMWARE_REMOTE_VERSION_BUILD} \n"
    FIRMWARE_TEXT+="\n"

    #if newer, do yes/no
    if [ $IS_NEWER -eq 1 ]; then
        FIRMWARE_TEXT+="$FIRMWARE_UPDATE_TEXT"
        doUpdateFirmware

    # show message "up to date"
    else
        FIRMWARE_TEXT+="$FIRMWARE_OK_TEXT"
        doIsUpToDate
    fi
}

function doShutdown() {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$SHUTDOWN_TITLE" \
    --yesno \
    "$SHUTDOWN_TEXT" \
    $SHUTDOWN_HEIGHT \
    $SHUTDOWN_WIDTH \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then
        # TODO: replace this with real call
        echo "$SHUTDOWN_COMMAND"
        MENU_DONE=1
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
    fi
}

function doReboot() {
    RESULT=$(dialog \
    --backtitle "$WINDOW_TITLE" \
    --title "$REBOOT_TITLE" \
    --yesno \
    "$REBOOT_TEXT" \
    $REBOOT_HEIGHT \
    $REBOOT_WIDTH \
    3>&1 1>&2 2>&3 3>&-)

    BTN=$?
    if [ $BTN -eq $DIALOG_OK ]; then
        # TODO: replace this with real call
        echo "$REBOOT_COMMAND"
        MENU_DONE=1
    elif [ $BTN -eq $DIALOG_ESCAPE ]; then
        MENU_DONE=1
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

function doExit() {
    MENU_DONE=1
}

#-------------------------------------------------------------------------------
# Init

# check if file exists
if [ ! -f "$SETTINGS_FILE" ]; then

    # if not, write defaults
    mkdir -p "${SETTINGS_DIR}"
    touch "$SETTINGS_FILE"
    echo $LEDO_SETTING"="$LEDO_DEFAULT >> "$SETTINGS_FILE"
    echo $LEDB_SETTING"="$LEDB_DEFAULT >> "$SETTINGS_FILE"
    echo $LEDT_SETTING"="$LEDT_DEFAULT >> "$SETTINGS_FILE"
    echo $LEDS_SETTING"="$LEDS_DEFAULT >> "$SETTINGS_FILE"
    echo $LPT_SETTING"="$LPT_DEFAULT >> "$SETTINGS_FILE"
    echo $LPA_SETTING"="$LPA_DEFAULT >> "$SETTINGS_FILE"
fi

# map joystick to keyboard if running RetroPie
if [ -d $scriptdir ]; then
    source "$scriptdir/scriptmodules/helpers.sh"
	joy2keyStart
fi

# set up serial port
stty -F $SERIAL_PORT speed $SERIAL_SPEED -cstopb -parenb cs8

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
