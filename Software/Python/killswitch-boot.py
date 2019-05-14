#! /usr/bin/env python3

#-------------------------------------------------------------------------------
# killswitch-boot.py
# KillSwitch
#
# Copyright © 2019 Dana Hynes <danahynes@gmail.com>
# This work is free. You can redistribute it and/or modify it under the terms
# of the Do What The Fuck You Want To Public License, Version 2, as published
# by Sam Hocevar. See the LICENSE file for more details.
#-------------------------------------------------------------------------------

VERSION_NUMBER = "0.1.0"

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
import signal
import subprocess
import sys

# set locale
locale.setlocale(locale.LC_ALL, '')

#-------------------------------------------------------------------------------
# constants
#-------------------------------------------------------------------------------
pin_trigger = 3
time_hold = 5
time_debounce = 0.05

#-------------------------------------------------------------------------------
# variables
#-------------------------------------------------------------------------------
trg_held = False

#-------------------------------------------------------------------------------
# Called when the trigger pin is held low.
#-------------------------------------------------------------------------------
def held():
    global trg_held

    # set flag
    trg_held = True

    # reboot on long press
    subprocess.call(['shutdown', '-r', 'now'], shell = False)

    # debug
    if (DEBUG == 1):
        print("long press")

#-------------------------------------------------------------------------------
# Called when trigger pin goes high.
#-------------------------------------------------------------------------------
def released():
    global trg_held

    # if not held
    if (trg_held == False):

        # shutdown on short press
        subprocess.call(['shutdown', '-h', 'now'], shell = False)

        # debug
        if (DEBUG == 1):
            print("short press")

    # clear flag
    trg_held = False

#-------------------------------------------------------------------------------
# objects
#-------------------------------------------------------------------------------

if (onPi):

    # set up trigger pin
    trigger = g0.Button(pin_trigger, hold_time = time_hold, \
        bounce_time = time_debounce)

#-------------------------------------------------------------------------------
# initialize
#-------------------------------------------------------------------------------

if (onPi):

    # make sure the pin starts off LOW (in case it was held over)
    trigger.wait_for_release()

    # assign button functions
    trigger.when_held = held
    trigger.when_released = released

#-------------------------------------------------------------------------------
# main loop
#-------------------------------------------------------------------------------

signal.pause()

# cleanup
sys.exit(0)

# -)
