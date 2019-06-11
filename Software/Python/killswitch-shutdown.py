#! /usr/bin/env python3

#-------------------------------------------------------------------------------
# killswitch-shutdown.py
# KillSwitch
#
# Copyright © 2019 Dana Hynes <danahynes@gmail.com>
# This work is free. You can redistribute it and/or modify it under the terms
# of the Do What The Fuck You Want To Public License, Version 2, as published
# by Sam Hocevar. See the LICENSE file for more details.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------
import gpiozero
import locale
import sys
import time

#-------------------------------------------------------------------------------
# Constants
#-------------------------------------------------------------------------------
VERSION_NUMBER = "0.1.33"
PIN_FEEDBACK = 2

#-------------------------------------------------------------------------------
# Objects
#-------------------------------------------------------------------------------
# feedback (active_high = True, initial_value = False)
# when the script starts, this pin will stay LOW
# we then pulse the pin based on whether we are shutting down or rebooting
feedback = gpiozero.OutputDevice(PIN_FEEDBACK)

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
def doMain():

    # get systemd parameter
    if (sys.argv[1] == "poweroff") or (sys.argv[1] == "halt"):

        # pulse the pin once - high/low
        feedback.on()
        time.sleep(0.02)
        feedback.off()

    elif (sys.argv[1] == "reboot"):

        # pulse the pin twice - high/low/high/low
        feedback.on()
        time.sleep(0.02)
        feedback.off()
        time.sleep(0.02)
        feedback.on()
        time.sleep(0.02)
        feedback.off()

#-------------------------------------------------------------------------------
# Init
#-------------------------------------------------------------------------------
# set locale
locale.setlocale(locale.LC_ALL, '')

#-------------------------------------------------------------------------------
# Main code
#-------------------------------------------------------------------------------
doMain()

#-------------------------------------------------------------------------------
# Cleanup
#-------------------------------------------------------------------------------
sys.exit(0)

# -)
