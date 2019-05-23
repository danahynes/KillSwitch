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

#-------------------------------------------------------------------------------
# imports
#-------------------------------------------------------------------------------
import gpiozero as g0
import locale
import signal
import subprocess
import sys

#-------------------------------------------------------------------------------
# Constants
#-------------------------------------------------------------------------------
VERSION_NUMBER = "0.1.8"
PIN_TRIGGER = 3
TIME_HOLD = 5
TIME_DEBOUNCE = 0.05

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
# TODO: how/when do we get this from settings???

trg_held = False

#-------------------------------------------------------------------------------
# Objects
#-------------------------------------------------------------------------------
# set up trigger pin
trigger = g0.Button(PIN_TRIGGER, hold_time = TIME_HOLD, \
    bounce_time = TIME_DEBOUNCE)

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
def held():
    global trg_held

    # set flag
    trg_held = True

    # reboot on long press
    subprocess.call(['shutdown', '-r', 'now'], shell = False)

def released():
    global trg_held

    # if not held
    if (trg_held == False):

        # shutdown on short press
        subprocess.call(['shutdown', '-h', 'now'], shell = False)

    # clear flag
    trg_held = False

def doMain():

    # make sure the pin starts off LOW (in case it was held over)
    trigger.wait_for_release()

    # assign button functions
    trigger.when_held = held
    trigger.when_released = released

    signal.pause()

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
