# KillSwitch

Source code and binaries for the KillSwitch project

If you just want to download and install KillSwitch on your Pi, first go to
the releases page by clicking on the "N releases" link above (where "N" is some number) or click on this link: https://github.com/danahynes/KillSwitch/releases.
Scroll until you find the first release marked with a green box that says "Latest release". Click the link for the "Source code (zip)" or "Source code (tar.gz)" file. Download and extract the file and follow the instructions below:

Step 1: (recommended) \
sudo apt-get update \
sudo apt-get upgrade

Step 2: \
Open a terminal to the KillSwitch-N.N.N/Software/Bash folder \
sudo ./killswitch-install.sh

The software requires an OS of Raspbian Jessie or higher, or any other OS that
uses systemd. If you're not sure, Google is your friend...

To update the firmware in the KillSwitch device, use the settings menu on the
Pi. Open a terminal and type "killswitch-settings.sh". Then use the "Update" menu item. This will update the firmware on your device, as well as the software on your Pi.

# -)
