#! /usr/bin/env bash

#-------------------------------------------------------------------------------
# killswitch-shutdown.sh
# KillSwitch
#
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

VERSION_NUMBER="0.1"
VERSION_BUILD="19.01.30"

FEEDBACK=2

# TODO: change serial port
SERIAL_PORT=/dev/pts/6
SERIAL_SPEED=9600

# set up serial port
stty -F $SERIAL_PORT speed $SERIAL_SPEED -cstopb -parenb cs8

# make a directory for the pin
echo $FEEDBACK > /sys/class/gpio/export

# write pin direction to pin direction file
echo out > /sys/class/gpio/gpio${FEEDBACK}/direction

if [ "$1" = "poweroff" ] || [ "$1" = "halt" ]; then

    # pulse the pin once - high/low
    echo 1 > /sys/class/gpio/gpio${FEEDBACK}/value
    sleep 0.2
    echo 0 > /sys/class/gpio/gpio${FEEDBACK}/value
    echo "?SHT|!" > $SERIAL_PORT
elif [ "$1" = "reboot" ]; then

    # pulse the pin twice - high/low/high/low
    echo 1 > /sys/class/gpio/gpio${FEEDBACK}/value
    sleep 0.2
    echo 0 > /sys/class/gpio/gpio${FEEDBACK}/value
    sleep 0.2
    echo 1 > /sys/class/gpio/gpio${FEEDBACK}/value
    sleep 0.2
    echo 0 > /sys/class/gpio/gpio${FEEDBACK}/value
    echo "?RBT|!" > $SERIAL_PORT
fi

# -)
