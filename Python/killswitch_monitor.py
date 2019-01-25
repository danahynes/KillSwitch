#! /usr/bin/env python

#-------------------------------------------------------------------------------
# killswitch_monitor.py
# KillSwitch
# Copyright (c) 2019 Dana Hynes.
# All rights reserved.
#-------------------------------------------------------------------------------

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
#import signal
import subprocess

#-------------------------------------------------------------------------------
# constants
#-------------------------------------------------------------------------------
pin_feedback = 2
pin_trigger = 3
time_hold = 5
time_debounce = 0.05

# TODO: change serial port
serial_port = '/dev/pts/4'
serial_speed = 9600

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

if (hasg0):

    # set up trigger pin
    trigger = g0.Button(pin_trigger, hold_time = time_hold, \
        bounce_time = time_debounce)

    # feedback (active_high = True, initial_value = False)
    # when the script starts, this pin will turn off
    # when the pi is off, this pin will use its internal pullup to turn
    # the output on
    feedback = g0.OutputDevice(pin_feedback)

#-------------------------------------------------------------------------------
# initialize
#-------------------------------------------------------------------------------

if (hasg0):

    # make sure the pin starts off low (in case it was held over)
    trigger.wait_for_release()

    # assign button functions
    trigger.when_held = held
    trigger.when_released = released

#-------------------------------------------------------------------------------
# main loop
#-------------------------------------------------------------------------------

# set up serial
ser = serial.Serial(serial_port, serial_speed, timeout = 1);

# watch serial
while (1):
    line = ser.readline()
    if (len(line) > 0):

        # split by separator
        cmds = line.split("|")
        cmd = cmds[0]
        val = cmds[1]

        # strip leading '?' and trailing '!'
        cmd = cmd[1:]
        
        # add two for CR/LF
        val = val[:-3]

        if (cmd == "SHT"):
            subprocess.call(['shutdown', '-h', 'now'], shell = False)
        elif (cmd == "RBT"):
            subprocess.call(['shutdown', '-r', 'now'], shell = False)

#signal.pause()

# -)
