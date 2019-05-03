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

VERSION_NUMBER = "0.5.18"

DEBUG = 1

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
import locale
import sys
import time

# set locale
locale.setlocale(locale.LC_ALL, '')

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

#debug
if (DEBUG == 1):
    print(sys.argv[1])

# get systemd parameter
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

# cleanup
sys.exit(0)

# -)
