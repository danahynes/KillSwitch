#! /usr/bin/env python

#-------------------------------------------------------------------------------
# killswitch-shutdown.py
# KillSwitch
#
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

VERSION_NUMBER = "0.1"
VERSION_BUILD = "19.01.30"

# are we running on a pi?
hasg0 = False

#-------------------------------------------------------------------------------
# imports
#-------------------------------------------------------------------------------
try :
    import gpiozero as g0
    hasg0 = True
except ImportError:
    hasg0 = False
import serial
import sys
import time

#-------------------------------------------------------------------------------
# constants
#-------------------------------------------------------------------------------
pin_feedback = 2

# TODO: change serial port
serial_port = '/dev/pts/4'
serial_speed = 9600

# set up serial
ser = serial.Serial(serial_port, serial_speed, timeout = 1);

#-------------------------------------------------------------------------------
# objects
#-------------------------------------------------------------------------------

if (hasg0):

    # feedback (active_high = True, initial_value = False)
    # when the script starts, this pin will stay LOW
    # we then pulse the pin based on whether we are shutting down or rebooting
    feedback = g0.OutputDevice(pin_feedback)

#-------------------------------------------------------------------------------
# get args
#-------------------------------------------------------------------------------

args = str(sys.argv)
if (sys.argv[1:] == "poweroff") or (sys.argv[1:] == "halt"):

    # pulse the pin once - high/low
    feedback.on()
    time.sleep(0.02)
    feedback.off()

    # write to serial
    ser.write("?SHT|!")
elif (sys.argv[1:] == "reboot"):

    # pulse the pin twice - high/low/high/low
    feedback.on()
    time.sleep(0.02)
    feedback.off()
    time.sleep(0.02)
    feedback.on()
    time.sleep(0.02)
    feedback.off()

    # write to serial
    ser.write("?RBT|!")

# -)
