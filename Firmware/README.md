# KillSwitch firmware files

These are the source code and binary files for the firmware that resides on the KillSwitch device. It is currently written specifically for the Arduino Uno, as that is my primary testbed, although it should run or could be adapted to almost any Atmel AVR that Arduino supports.

It may also get rewritten in C to support microcontrollers not supported by Arduino, as well as saving space to make it work on smaller microcontrollers.

(Note also that the hardware design uses an ATTiny84, as that is the smallest chip that has enough GPIO pins)

The killswitch-firmware_N.N.N.hex file is the compiled binary that is
flashed onto the device.

The source code is arranged as an [Atom](https://ide.atom.io) project, and the firmware is built using the [PlatformIO](https://platformio.org) plugin.

# -)
