# KillSwitch

Source code and binaries for the KillSwitch project

<< TODO: FILL IN DESCRIPTION OF DEVICE, PURPOSE AND USE >>

## Software installation

If you want to download and install the KillSwitch software on your Pi, first go to the [latest release](https://github.com/danahynes/KillSwitch/releases/latest). Click the link for the "Source code (zip)" or "Source code (tar.gz)" file. Download and extract the file and follow the instructions below:

Step 1: (recommended) \
sudo apt-get update \
sudo apt-get upgrade

Step 2: \
Open a terminal to the KillSwitch-N.N.N/Software/Bash folder \
sudo ./killswitch-install.sh

Here is a one-line command that will do it for you: \
sudo apt-get update && sudo apt-get upgrade && curl -H "Authorization: token 3868839158c75239f3ed89a4aedfe620e72156b4" -H "Accept: application/vnd.github.v3.raw" -O https://api.github.com/repos/danahynes/KillSwitch/contents/install-latest.py && chmod +x install-latest.py && python3 install-latest.py

The software requires an OS of Raspbian Jessie or higher, or any other OS that
uses systemd. If you're not sure, Google is your friend...

Note that installing the software will turn off your ability to log in to the Pi using a serial console, as the hardware serial port is used to communicate to the device when using the settings script. If you don't know what this means, don't worry. You'll probably never use this feature. This does not affect the software serial port, although on newer devices that port is used for the built-in Bluetooth.

## Updating

To update the software and firmware, use the settings menu on the Pi. Open a terminal and type "killswitch-settings.sh". Then use the "Update" menu item. This will update the firmware on your device and the software on your Pi, if necessary.

## Source code

The source code is arranged as an [Atom](https://ide.atom.io) project (which has been discontinued, sigh...), and the firmware is built using the [PlatformIO](https://platformio.org) plugin.

If you want to compile the source for the firmware yourself, you'll also need to download the [Arduino-Libraries repo](https://github.com/danahynes/Arduino-Libraries/releases/latest).
You will also need to adjust the relative paths of the library file links in Firmware/src/ since I use symlinks to the library files that reside outside this project. (I don't like having to copy/paste library directories every time I change something in one of them, so symlinks just pull in the latest version of a header or source file, from where it lives in a different repo folder on my build system. I know this isn't the most "correct" way to do it, and I could write a script to automate it or create Arduino packages, and maybe I will, but hey, for now... it works!)

## Licensing

The source code for the firmware, hardware, and software are licensed under the WTFPL v2. See the LICENSE file or http://www.wtfpl.net/ for more info.

# -)
