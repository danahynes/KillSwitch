# KillSwitch

Source code and binaries for the KillSwitch project

![3D Image](./3D.png)
## RetroPie users
Where you see "killswitch-settings.py" below, select "KillSwitch" from the "Ports" menu item.

## About

KillSwitch is a small PCB that attaches to your Raspberry Pi 2/3/0 (40 pin GPIO) and allows you to turn the Pi on or off using a push button or an IR remote. It also has an LED status indicator that is completely programmable. It is also compatible with almost any infrared remote control, or IR blaster devices like the [Harmony Hub](https://www.logitech.com/en-us/product/harmony-hub) or [SparkX WiFi IR Blaster](https://www.sparkfun.com/products/15000).

## Programming

To program a remote for use with KillSwitch using the hardware button:
1. Attach the KillSwitch to your Pi and plug the power source in to the KillSwitch.
2. Press and hold the push button on the device for a few seconds (The default is 5 seconds, but this can be changed using the Settings program, see below). The status LED will begin flashing rapidly. Release the button.
3. Point the remote at the device's IR receiver and press the button on the remote that you want to use as the "On" button (note that you have 15 seconds before the device exits the programming mode). The status LED will flash once slowly, then flash rapidly again.
4. Press the button on the remote that you want to use as the "Off" button (again, you have 15 seconds before the device exits programming mode). It can be the same as the "On" button if you wish, creating a "toggle" button. The status LED will flash twice slowly, then turn off.

During programming, the button works in the following ways:
* If the button is held for Long Press Time, exit Programming mode, leaving any unrecorded codes unchanged.
* If the button is pressed quickly, and you are currently recording the "On" code, the "On" code is left unchanged, and Programming is set to record a new "Off" code ("Skip code" in the table below).
* If the button is pressed quickly, and you are currently recording the "Off" code, the Programming mode is exited, and the new "Off" code is the same as the previously recorded "On" code ("Copy code" in the table below).

That's it! Your KillSwitch will now turn power on to the Pi when you press the "On" remote button, and will safely shut down and power off when you press the "Off" remote button (or the "On" button again, it the buttons are the same).

To change the remote codes, you can either shut down the Pi and repeat the steps above, or you can use the Settings program by typing in a terminal "killswitch-settings.py" and selecting the "Start recording" option.

## Button operation
The hardware button on the KillSwitch device serves different purposes, depending on the state of the device and the Pi it is attached to. Here are its functions:

| Pi is             | Button press | Button hold      |
|-------------------|--------------|------------------|
| Off               | Pi boot      | Program mode     |
| On                | Pi shutdown  | Reboot/Force Off |

| KillSwitch is     | Button press | Button hold      |
|-------------------|--------------|------------------|
| Programming "On"  | Skip code    | Exit programming |
| Programming "Off" | Copy code    | Exit programming |

The hold time is configurable using "killswitch-settings.py" and selecting the "Long Press Time" option. By default it is 5 seconds. The action of reboot/force off is also configurable through "killswitch-settings.py", and selecting the "Long Press Action" option.

## Settings

#### LED options
The LED on the KillSwitch is arguably the most configurable part of the device. Here you can set different options for the status LED on the KillSwitch.

###### LED Type
* On (default) - the LED is at the "On" brightness when the Pi is on, and at the "Off" brightness when the Pi is off. You can set the "Off" brightness to a low value to have a dim "Standby" indicator, or 0 (the default) for completely off.
* Off - the LED is always off, unless the device is being programmed.

###### LED Style
* Flash (default) - the LED flashes sharply from "On" brightness to completely off during bootup and shutdown.
* Pulse - the LED uses PWM to fade from completely off to "On" brightness and back to completely off during bootup and shutdown.

###### LED On Brightness
Sets the brightness of the LED, from 0 to 255, when the LED flashes/pulses during the bootup/shutdown process or when the Pi is fully booted and running. Note that this setting does not affect the brightness of the LED duting programming. The default is 255.
###### LED Off Brightness
Sets the brightness of the LED, from 0 to 255, when the Pi is completely shut down and powered off. The default is 0.
#### Start Recording
Select this item and read the instructions that follow (or read the above section on Programming) to program the device to recognize new infrared remote commands to turn the Pi on and off.
#### Long Press Time
This setting determines how long, in seconds, the physical push button on the device must be held down to either start recording new codes, or reboot/force quit the Pi. The default is 5 seconds.
#### Long Press Action
Here you can set what happens when the physical push button on the device is held down for the Long Press Time when the Pi is running (see above). Holding the button down when the Pi is off will always enter programming mode.
* Reboot (default) - sends the "reboot" command the the Pi, which will shut down safely and restart. If the Pi is not responding, this option will have no effect and you will need to remove the power plug from the device, or remove the device from the Pi to shut it off.
* Force quit - if you prefer to have the device cut the power completely to the Pi when it is not responding (same as pulling out the power plug), set this option. This option is useful if the power plug is not easily accessible, but the physical button is (for instance, an enclosure where the button is custom-mounted in a different location).

#### Restart After Power Failure
This option lets you decide if the Pi is rebooted after an unexpected power failure. If this option is selected, and the the Pi was running, and power to the device was lost without a proper shutdown, KillSwitch will automagically restore power to the Pi once power is restored. If the option is unselected, you will need to use the physical button/remote button to turn the Pi back on after power is restored.

Note that the whole point of KillSwitch is that it is unsafe/unwise to simply remove power from the Pi without a safe shutdown. Therefore, the device will restore power to the Pi and attempt to boot it, however if the SD card in the Pi was corrupted during the power loss, it may not boot. The device will only restore power to the Pi, after that it's up to the Pi (and the integrity of it's SD card) to decide if it will actually boot up.

#### Update
This setting will attempt to update the software on your Pi, as well as the firmware in the device itself. It requires an internet connection to check for the latest release of the code on Github, then compares the GitHub version number to the version number running on the Pi/KillSwitch.
If a newer version is available, you will be asked to confirm the update. The software will attempt to reprogram the device using ICSP, and then run the new installer (which requires a sudo password, so please make sure you have a keyboard attached/paired to the Pi).

If the update is successful, the Pi will ask to be rebooted. Press "Enter" at the end of the installer, wait for the reboot, and you'll be good to go!
#### Uninstall
This one is pretty self-explanatory. It uninstalls all the files/folders from your Pi that were installed using the installer. If you use this option, please be sure to read the caveats at the end of the uninstall script output, as there are some things the uninstaller cannot revert, such as installed dependencies and the serial port options.

This script also requires running as root, so please make sure you have a keyboard attached/paired to the Pi to enter the root password.
## RetroPie
The software installed on your Pi is compatible with RetroPie (it was originally written specifically FOR RetroPie, and backported to support Raspian -).

A shortcut to "killswitch-settings.py" will be installed in the "Ports" directory (as "KillSwitch"), where you can access it and use it with a paired game controller. Use the D-Pad to navigate between menu options, and the A/B buttons to accept/cancel. (So far it is tested on a Pi 3 B+ with RetroPie v4.4, but it should work on any newer Pi hardware and RetroPie software). Note that the installer/uninstaller will need a root password, for which you will need a keyboard attached/paired to the Pi.

specific buttons to use depend on your setup, but the defaults are that the A button is Enter, and the B button is

## Software installation

If you want to download and install the KillSwitch software on your Pi, first go to the [latest release](https://github.com/danahynes/KillSwitch/releases/latest). Click the link for the "Source code (zip)" or "Source code (tar.gz)" file. Download and extract the file and follow the instructions below:

Step 1: (recommended) \
sudo apt-get update \
sudo apt-get upgrade

Step 2: \
Open a terminal to the KillSwitch-vN.N.N/Software/Bash folder and type: \
sudo ./killswitch-install.sh

Here is a one-line command that will do everything for you (requires python 3):
~~~~
sudo apt-get update && sudo apt-get upgrade && curl -H "Authorization: token 3868839158c75239f3ed89a4aedfe620e72156b4" -H "Accept: application/vnd.github.v3.raw" -O https://api.github.com/repos/danahynes/KillSwitch/contents/install-latest.py && chmod +x install-latest.py && python3 install-latest.py
~~~~

The software requires an OS of Raspbian Jessie or newer, or any other OS that
uses systemd. If you're not sure, Google is your friend -)

Note that installing the software will turn off your ability to log in to the Pi using a serial console, as the hardware serial port is used to communicate to the device when using the settings script. If you don't know what this means, don't worry. You'll probably never use this feature. This does not affect the software serial port, although on newer devices that port is used for the built-in Bluetooth.

## Updating

To update the software and firmware, use the settings menu on the Pi. Open a terminal and type "killswitch-settings.py". Then use the "Update" menu item. This will update the firmware on your device and the software on your Pi, if necessary.

## Source code

The source code is arranged as an [Atom](https://ide.atom.io) project (which has been discontinued, sigh...), and the firmware is built using the [PlatformIO](https://platformio.org) plugin.

If you want to compile the source for the firmware yourself, you'll also need to download the [Arduino-Libraries repo](https://github.com/danahynes/Arduino-Libraries/releases/latest).
You will also need to adjust the relative paths of the library file links in Firmware/src/ since I use symlinks to the library files that reside outside this project. (I don't like having to copy/paste library directories every time I change something in one of them, so symlinks just pull in the latest version of a header or source file, from where it lives in a different repo folder on my build system. I know this isn't the most "correct" way to do it, and I could write a script to automate it or create Arduino packages, and maybe I will, but hey, for now... it works!)

## Licensing

The source code for the firmware, hardware, and software are licensed under the WTFPL v2. See the LICENSE file or http://www.wtfpl.net/ for more info.

# -)
