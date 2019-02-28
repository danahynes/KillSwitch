#! /usr/bin/env python

#-------------------------------------------------------------------------------
# killswitch-shutdown.py
# KillSwitch
#
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

VERSION_NUMBER = "0.3.4"

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
import sys
import time

#-------------------------------------------------------------------------------
# constants
#-------------------------------------------------------------------------------
pin_feedback = 2

#-------------------------------------------------------------------------------
# objects
#-------------------------------------------------------------------------------

if (onPi):

    # feedback (active_high = True, initial_value = False)
    # when the script starts, this pin will stay LOW
    # we then pulse the pin based on whether we are shutting down or rebooting
    feedback = g0.OutputDevice(pin_feedback)

#-------------------------------------------------------------------------------
# main code
#-------------------------------------------------------------------------------

if (sys.argv[1] == "poweroff") or (sys.argv[1] == "halt"):

    if (onPi):

        # pulse the pin once - high/low
        feedback.on()
        time.sleep(0.02)
        feedback.off()

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

# -)
