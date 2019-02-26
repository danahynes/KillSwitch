#! /usr/bin/env python

#-------------------------------------------------------------------------------
# killswitch-boot.py
# KillSwitch
#
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

VERSION_NUMBER = "0.3.3"

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
import signal
import subprocess

#-------------------------------------------------------------------------------
# constants
#-------------------------------------------------------------------------------
pin_feedback = 2
pin_trigger = 3
time_hold = 0.5
time_debounce = 0.05

#if (onPi):
#    serial_port = '/dev/ttyS0'
#else:
#    serial_port = '/dev/pts/5'
#serial_speed = 9600

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

    # feedback (active_high = True, initial_value = False)
    # when the script starts, this pin will be HIGH (the poweroff/sleep default)
    # and then go LOW
    # when the pi is sleeping, this pin will use its internal pullup to set
    # the pin back to HIGH
    # if we are shutting power to the pi, the arduino will use ITS internal
    # pullup to set this pin HIGH
    feedback = g0.OutputDevice(pin_feedback)

# set up serial
#ser = serial.Serial(serial_port, serial_speed, timeout = 1);

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

# watch serial
# while (1):
#     line = ser.readline()
#     if (len(line) > 0):
#
#         # split by separator
#         cmds = line.split("|")
#         cmd = cmds[0]
#         val = cmds[1]
#
#         # strip leading '?'
#         cmd = cmd[1:]
#
#         # strip trailing '!' and add two for CR/LF
#         val = val[:-3]
#
#         if (cmd == "SHT"):
#             subprocess.call(['shutdown', '-h', 'now'], shell = False)
#         elif (cmd == "RBT"):
#             subprocess.call(['shutdown', '-r', 'now'], shell = False)

signal.pause()

# -)
