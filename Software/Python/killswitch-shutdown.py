#! /usr/bin/env python

#-------------------------------------------------------------------------------
# killswitch-shutdown.py
# KillSwitch
#
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

VERSION_NUMBER = "0.3"
VERSION_BUILD = "19.02.20"

# are we running on a pi?
onPi = False

#-------------------------------------------------------------------------------
# imports
#-------------------------------------------------------------------------------
try :
    import gpiozero as g0
    onPi = True
except ImportError:
    onPi = False
#import serial
import sys
import time

#-------------------------------------------------------------------------------
# constants
#-------------------------------------------------------------------------------
pin_feedback = 2

#if (onPi):
#    serial_port = '/dev/ttyS0'
#else:
#    serial_port = '/dev/pts/5'
#serial_speed = 9600

#-------------------------------------------------------------------------------
# objects
#-------------------------------------------------------------------------------

if (onPi):

    # feedback (active_high = True, initial_value = False)
    # when the script starts, this pin will stay LOW
    # we then pulse the pin based on whether we are shutting down or rebooting
    feedback = g0.OutputDevice(pin_feedback)

# set up serial
#ser = serial.Serial(serial_port, serial_speed, timeout = 1);

#-------------------------------------------------------------------------------
# main code
#-------------------------------------------------------------------------------

if (sys.argv[1] == "poweroff") or (sys.argv[1] == "halt"):

    if (onPi):

        # pulse the pin once - high/low
        feedback.on()
        time.sleep(0.02)
        feedback.off()

    # write to serial
    #ser.write("?SHT|!")
elif (sys.argv[1] == "reboot"):

    if (onPi):

        # pulse the pin twice - high/low/high/low
        feedback.on()
        time.sleep(0.02)
        feedback.off()
        time.sleep(0.02)
        feedback.on()
        time.sleep(0.02)
        feedback.off()

    # write to serial
    #ser.write("?RBT|!")

# -)
