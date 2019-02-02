/*-----------------------------------------------------------------------------
 * KillSwitch.cpp
 * KillSwitch
 *
 * Copyright 2018 Dana Hynes.
 * All rights reserved.
 ----------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------
// Includes

#include <Arduino.h>
#include <EEPROM.h>
#include <IRremote.h>
#include "DHButton.h"
#include "DHLED.h"
#include "DHTimer.h"
#include "DHPulseCounter.h"

//-----------------------------------------------------------------------------
// Constants

const char VERSION_NUMBER[] = "0.1";
const char VERSION_BUILD[] = "19.0.27";

const int STATE_OFF = 0;
const int STATE_BOOTING = 1;
const int STATE_ON = 2;
const int STATE_SHUTDOWN = 3;
const int STATE_REBOOT = 4;
const int STATE_PROGRAMMING = 5;

const int PROG_STATE_NONE = 0;
const int PROG_STATE_CODE_ON = 1;
const int PROG_STATE_CODE_OFF = 2;

const int PIN_BUTTON = 12;
const int PIN_IR = 7;
const int PIN_FEEDBACK = 5;
const int PIN_STATUS = 6;

const int PIN_TRIGGER = 13;
const int PIN_POWER = 4;

const int DEBOUNCE_DELAY = 50;
const int HOLD_TIME_DEFAULT = 5000;
//const int HOLD_ACTION_REBOOT = 0;
//const int HOLD_ACTION_SHUTDOWN = 1;
//const int HOLD_ACTION_DEFAULT = HOLD_ACTION_REBOOT;

//const int STATUS_OFF_DEFAULT = 0;
const int STATUS_BRIGHTNESS_DEFAULT = 255;
//const int STATUS_PULSE_DEFAULT = 0;
//const int STATUS_INVERT_DEFAULT = 0;

const int PROG_TIMEOUT = 15000;

const int EEPROM_ADDR_CODE_ON = 0;
const int EEPROM_ADDR_CODE_OFF = 4;
const int EEPROM_ADDR_BRIGHTNESS = 8;
const int EEPROM_ADDR_PULSE = 9;
const int EEPROM_ADDR_INVERT = 10;
const int EEPROM_ADDR_HOLD_TIME = 11;
const int EEPROM_ADDR_HOLD_ACTION = 15;
const int EEPROM_ADDR_BRIGHT_SET = 16;
const int EEPROM_ADDR_STATUS_OFF = 17;

const int PULSE_CYCLE_SLOW = 500;
const int PULSE_CYCLE_FAST = 125;
const int FLASH_CYCLE_SLOW = 1000;
const int FLASH_CYCLE_FAST = 250;

const int TRIGGER_SHUTDOWN_TIME = 1000;
const int TRIGGER_REBOOT_TIME = 5000;

const char CMD_START = '!';
const char CMD_SEPERATOR = '|';
const char CMD_END = '?';

const int SERIAL_STATE_NONE = 0;
const int SERIAL_STATE_CMD = 1;
const int SERIAL_STATE_VALUE = 2;

//-----------------------------------------------------------------------------
// Variables

int state = STATE_OFF;
int progState = PROG_STATE_NONE;
int beforeProgState = STATE_OFF;

DHButton button(PIN_BUTTON, true, DEBOUNCE_DELAY, HOLD_TIME_DEFAULT);

IRrecv irrecv(PIN_IR);
decode_results results;

DHPulseCounter feedbackCounter(PIN_FEEDBACK, LOW);

DHLED ledStatus(PIN_STATUS);

bool progChanging = false;
bool progFlashStart = false;
DHTimer progTimer(PROG_TIMEOUT);

DHTimer triggerTimer(TRIGGER_SHUTDOWN_TIME);

bool rebootFlag = false;

String serialCmd = "";
String serialValue = "";
int serialState = SERIAL_STATE_NONE;

//------------------------------------------------------------------------------
// Helpers

/*------------------------------------------------------------------------------
 * Writes a long value to EEPROM.
 ----------------------------------------------------------------------------*/
void EEPROMWriteLong(int address, long value) {
	byte four = (value & 0xFF);
	byte three = ((value >> 8) & 0xFF);
	byte two = ((value >> 16) & 0xFF);
	byte one = ((value >> 24) & 0xFF);

	EEPROM.update(address, four);
	EEPROM.update((address + 1), three);
	EEPROM.update((address + 2), two);
	EEPROM.update((address + 3), one);
}

/*-----------------------------------------------------------------------------
 * Reads a long value from EEPROM.
 ----------------------------------------------------------------------------*/
long EEPROMReadLong(long address) {
	long four = EEPROM.read(address);
	long three = EEPROM.read(address + 1);
	long two = EEPROM.read(address + 2);
	long one = EEPROM.read(address + 3);

	return (
		((four << 0) & 0xFF) +
		((three << 8) & 0xFFFF) +
		((two << 16) & 0xFFFFFF) +
		((one << 24) & 0xFFFFFFFF)
	);
}

/*-----------------------------------------------------------------------------
 * Sends a command-value pair to the pi.
 ----------------------------------------------------------------------------*/
void sendSerial(String CMD, String VAL) {
	Serial.println(CMD_START + CMD + CMD_SEPERATOR + VAL + CMD_END);
}

/*-----------------------------------------------------------------------------
 * Starts booting the pi.
 ----------------------------------------------------------------------------*/
void doOn() {
	state = STATE_BOOTING;
	Serial.println("state changed to STATE_BOOTING");
}

/*-----------------------------------------------------------------------------
 * Starts shutting down the pi.
 ----------------------------------------------------------------------------*/
void doOff(bool gui = false) {
	state = STATE_SHUTDOWN;
	Serial.println("state changed to STATE_SHUTDOWN");

	if (!gui) {

		// set the trigger state and starts its timer
		digitalWrite(PIN_TRIGGER, HIGH);
		triggerTimer.setTime(TRIGGER_SHUTDOWN_TIME);
		triggerTimer.start();
	}
}

/*-----------------------------------------------------------------------------
 * Reboots the pi.
 ----------------------------------------------------------------------------*/
void doReboot(bool gui = false) {
	state = STATE_REBOOT;
	Serial.println("state changed to STATE_REBOOT");

	// clear flag to ignore feedback
	rebootFlag = false;

	if (!gui) {

		// set the trigger state and starts its timer
		digitalWrite(PIN_TRIGGER, HIGH);
		triggerTimer.setTime(TRIGGER_REBOOT_TIME);
		triggerTimer.start();
	}
}

/*-----------------------------------------------------------------------------
 * Puts the device into programming mode.
 ----------------------------------------------------------------------------*/
void startProgramming() {
	state = STATE_PROGRAMMING;
	Serial.println("state changed to STATE_PROGRAMMING");

	progState = PROG_STATE_CODE_ON;
	Serial.println("progState changed to PROG_STATE_CODE_ON");

	// don't count flashes, start watchdog
	progChanging = false;
	progTimer.start();
}

/*-----------------------------------------------------------------------------
 * Takes the device out of programming mode.
 ----------------------------------------------------------------------------*/
void stopProgramming() {

	state = beforeProgState;
	if (beforeProgState == STATE_OFF) {
		Serial.println("state changed to STATE_OFF");
	} else {
		Serial.println("state changed to STATE_ON");
	}

	progState = PROG_STATE_NONE;
	Serial.println("progState changed to PROG_STATE_NONE");

	// don't count flashes, stop watchdog
	progChanging = false;
	progTimer.stop();

	// send serial for stop programming in settings
	//sendSerial("PGM", "STOP");
}

/*-----------------------------------------------------------------------------
 * Called when the button has been pressed for a short time (< hold time).
 ----------------------------------------------------------------------------*/
void doShortPress(DHButton* button) {
	if (state == STATE_OFF) {
		doOn();
	} else if (state == STATE_ON) {
		doOff();
	} else if (state == STATE_PROGRAMMING) {
		if (progState == PROG_STATE_CODE_ON) {

			// count flashes, start watchdog
			progChanging = true;
			progTimer.start();

			// send serial for next mode in settings
			//sendSerial("PGM", "NEXT");
		} else if (progState == PROG_STATE_CODE_OFF) {

			// make off code same as on code
			long onCode = EEPROMReadLong(EEPROM_ADDR_CODE_ON);
			long offCode = onCode;
			EEPROMWriteLong(EEPROM_ADDR_CODE_OFF, offCode);

			// count flashes before exiting programming mode
			progChanging = true;

			// send serial for next mode in settings
			//sendSerial("PGM", "NEXT");
		}
	}
}

/*-----------------------------------------------------------------------------
 * Called when the button is held longer than the hold time.
 ----------------------------------------------------------------------------*/
void doLongPress(DHButton* button) {

	// get long press action
	bool forceQuitOnHold = EEPROM.read(EEPROM_ADDR_HOLD_ACTION);

	if (state == STATE_ON) {
		if (!forceQuitOnHold) {
			doReboot();
		} else {

			// force shutdown
			state = STATE_OFF;
			Serial.println("state changed to STATE_OFF");
		}
	} else if (state == STATE_OFF) {
		beforeProgState = STATE_OFF;
		startProgramming();
	} else if (state == STATE_PROGRAMMING) {

		// abort programming
		stopProgramming();
	}
}

/*-----------------------------------------------------------------------------
 * Called when the trigger timer expires.
 ----------------------------------------------------------------------------*/
void doTriggerTimerUp(DHTimer* timer) {
	digitalWrite(PIN_TRIGGER, LOW);
}

/*-----------------------------------------------------------------------------
 * Called when the watchdog timer expires.
 ----------------------------------------------------------------------------*/
void doProgTimerUp(DHTimer* timer) {

	// abort programming
	stopProgramming();
}

/*-----------------------------------------------------------------------------
 * Called when the LED is done flashing for a count.
 ----------------------------------------------------------------------------*/
void doLEDDoneFlashing(DHLED* led) {

	// stop counting flashes
	progFlashStart = false;
	progChanging = false;

	// switch from on code to off code
	if (progState == PROG_STATE_CODE_ON) {
		progState = PROG_STATE_CODE_OFF;
		Serial.println("progState changed to PROG_STATE_CODE_OFF");

		// send serial to settings app
		//sendSerial("PGM", "NEXT");
	} else if (progState == PROG_STATE_CODE_OFF) {

		// done with off code
		stopProgramming();
	}
}

/*-----------------------------------------------------------------------------
 * Called when the pulse counter is done counting.
 ----------------------------------------------------------------------------*/
void doCounterDone(DHPulseCounter* counter) {
	/* N.B. the counter is basically used to differentiate between an edge
	change (the old style) and a pulse count (the new style).
	*/
	int i = counter->getCount();

	// from GUI
	if (i > 0) {

		Serial.print("pulses: ");
		Serial.println(i);

		if (state == STATE_ON) {
			if (i == 1) {

				// shutdown from gui
				doOff(true);
			} else if (i == 2) {

				// reboot from gui
				doReboot(true);
			}
		}
	} else {
		Serial.println("no pulses");

		if (state == STATE_BOOTING) {
			if (digitalRead(PIN_FEEDBACK) == LOW) {
				state = STATE_ON;
				Serial.println("state changed to STATE_ON");

				// new feedback state to watch for
				feedbackCounter.setValue(HIGH);
			}
		} else if ((state == STATE_SHUTDOWN) || (state == STATE_ON)) {
			if (digitalRead(PIN_FEEDBACK) == HIGH) {
				state = STATE_OFF;
				Serial.println("state changed to STATE_OFF");

				// new feedback state to watch for
				feedbackCounter.setValue(LOW);
			}
		} else if (state == STATE_REBOOT) {
			if (digitalRead(PIN_FEEDBACK) == HIGH) {

				// set flag to watch feedback
				rebootFlag = true;

				// new feedback state to watch for
				feedbackCounter.setValue(LOW);
			} else {
				if (rebootFlag) {
					state = STATE_ON;
					Serial.println("state changed to STATE_ON");

					// clear reboot flag
					rebootFlag = false;

					// new feedback state to watch for
					feedbackCounter.setValue(HIGH);
				}
			}
		}
	}
	feedbackCounter.start();
}

//-----------------------------------------------------------------------------
// Main Program

/*-----------------------------------------------------------------------------
 * Called once when the program starts.
 ----------------------------------------------------------------------------*/
void setup() {

	// start serial port
	Serial.begin(9600);

	// pin directions
	pinMode(PIN_IR, INPUT_PULLUP);
	pinMode(PIN_FEEDBACK, INPUT_PULLUP);
	pinMode(PIN_TRIGGER, OUTPUT);
	pinMode(PIN_POWER, OUTPUT);

	// pin values
	digitalWrite(PIN_STATUS, LOW);
	digitalWrite(PIN_TRIGGER, LOW);
	digitalWrite(PIN_POWER, LOW);

	// set up button
	int holdTime = EEPROM.read(EEPROM_ADDR_HOLD_TIME);
	if (holdTime == 0) {
		holdTime = HOLD_TIME_DEFAULT;
	}
	button.setHoldTime(holdTime);
	button.setOnShortPress(doShortPress);
	button.setOnLongPress(doLongPress);

	// set up ir receiver
//	irrecv.enableIRIn();

	// set up timers
	triggerTimer.setOnDone(doTriggerTimerUp);
	progTimer.setOnDone(doProgTimerUp);

	// set up LED
	byte statusBrightness = EEPROM.read(EEPROM_ADDR_BRIGHTNESS);
	if (statusBrightness == 0) {
		byte brightSet = EEPROM.read(EEPROM_ADDR_BRIGHT_SET);
		if (!brightSet) {

			// if brightness is 0 and set is 0, must be fresh so set default
			statusBrightness = STATUS_BRIGHTNESS_DEFAULT;
		}
	}
	ledStatus.setLevel(statusBrightness);
	ledStatus.setOnDoneFlashing(doLEDDoneFlashing);

	// set up pulse counter
	feedbackCounter.setOnDone(doCounterDone);
	feedbackCounter.start();
}

/*-----------------------------------------------------------------------------
 * Called repeatedly during the program's life.
 ----------------------------------------------------------------------------*/
void loop() {

//-----------------------------------------------------------------------------
// button

	button.update();

//-----------------------------------------------------------------------------
// ir

	if (irrecv.decode(&results)) {
		Serial.println(results.value, HEX);

		if (results.value != REPEAT) {

			// normal on/off
			if (state != STATE_PROGRAMMING) {
				unsigned long onCode = EEPROMReadLong(EEPROM_ADDR_CODE_ON);
				unsigned long offCode = EEPROMReadLong(EEPROM_ADDR_CODE_OFF);
				if ((results.value == onCode) && (state == STATE_OFF)) {
					doOn();
				} else if ((results.value == offCode) && (state == STATE_ON)) {
					doOff();
				}

			// programming
			} else {
				if (progState == PROG_STATE_CODE_ON) {
					long onCode = results.value;
					EEPROMWriteLong(EEPROM_ADDR_CODE_ON, onCode);

					// count flashes and start watchdog
					progChanging = true;
					progTimer.start();
				} else if (progState == PROG_STATE_CODE_OFF) {
					long offCode = results.value;
					EEPROMWriteLong(EEPROM_ADDR_CODE_OFF, offCode);

					// count flashes before exiting programming mode
					progChanging = true;
				}
			}
		}

		// get the next code
		irrecv.resume();
	}

//-----------------------------------------------------------------------------
// feedback

	feedbackCounter.update();

//-----------------------------------------------------------------------------
// status

	ledStatus.update();

	// get current values of pulse and invert from properties
	bool statusOff = EEPROM.read(EEPROM_ADDR_STATUS_OFF);
	bool statusPulse = EEPROM.read(EEPROM_ADDR_PULSE);
	bool statusInvert = EEPROM.read(EEPROM_ADDR_INVERT);

	if ((state == STATE_BOOTING) ||
			(state == STATE_SHUTDOWN) ||
			(state == STATE_REBOOT)) {

		// flash/pulse slow
		if (!statusOff) {
			if (ledStatus.getState() != ledStatus.FLASHING) {
				if (statusPulse) {
					ledStatus.setOnTime(PULSE_CYCLE_SLOW / 2);
					ledStatus.setOffTime(PULSE_CYCLE_SLOW / 2);
					ledStatus.setFadeOnTime(PULSE_CYCLE_SLOW / 2);
					ledStatus.setFadeOffTime(PULSE_CYCLE_SLOW / 2);
				} else {
					ledStatus.setOnTime(FLASH_CYCLE_SLOW / 2);
					ledStatus.setOffTime(FLASH_CYCLE_SLOW / 2);
				}
				ledStatus.flash(statusPulse);
			}
		} else {
			ledStatus.off();
		}

	} else if (state == STATE_ON) {

		// no flashing
		if (!statusOff) {
			if (statusInvert) {
				 ledStatus.off();
			} else {
				ledStatus.on();
			}
		} else {
			ledStatus.off();
		}
	} else if (state == STATE_OFF) {

		// no flashing
		if (!statusOff) {
			if (statusInvert) {
				 ledStatus.on();
			} else {
				ledStatus.off();
			}
		} else {
			ledStatus.off();
		}
	} else if (state == STATE_PROGRAMMING) {

		if (progChanging) {

			// put the led in a known state and start a new cycle
			if (progFlashStart == false) {
				progFlashStart = true;

				// off for half cycle before flash
				ledStatus.off();

				// XXX: delay() is bad but we need to differentiate between
				// the "waiting for code" flashes and the "got a code" flashes
				// is it worth a whole other timer/callback for this?
				delay(FLASH_CYCLE_SLOW / 2);

				// flash/pulse slow
				if (statusPulse) {
					ledStatus.setOnTime(PULSE_CYCLE_SLOW / 2);
					ledStatus.setOffTime(PULSE_CYCLE_SLOW / 2);
					ledStatus.setFadeOnTime(PULSE_CYCLE_SLOW / 2);
					ledStatus.setFadeOffTime(PULSE_CYCLE_SLOW / 2);
				} else {
					ledStatus.setOnTime(FLASH_CYCLE_SLOW / 2);
					ledStatus.setOffTime(FLASH_CYCLE_SLOW / 2);
				}

				// flash for count
				if (progState == PROG_STATE_CODE_ON) {
					ledStatus.flashForCount(1, statusPulse);
				} else if (progState == PROG_STATE_CODE_OFF) {
					ledStatus.flashForCount(2, statusPulse);
				}
			}

		// not changing, just waiting for a code
		} else {

			// flash fast
			if (ledStatus.getState() != ledStatus.FLASHING) {
				if (statusPulse) {
					ledStatus.setOnTime(PULSE_CYCLE_FAST / 2);
					ledStatus.setOffTime(PULSE_CYCLE_FAST / 2);
					ledStatus.setFadeOnTime(PULSE_CYCLE_FAST / 2);
					ledStatus.setFadeOffTime(PULSE_CYCLE_FAST / 2);
				} else {
					ledStatus.setOnTime(FLASH_CYCLE_FAST / 2);
					ledStatus.setOffTime(FLASH_CYCLE_FAST / 2);
				}
				ledStatus.flash(statusPulse);
			}
		}
	}

//-----------------------------------------------------------------------------
// trigger

	triggerTimer.update();

//-----------------------------------------------------------------------------
// power

	// states that do not require pi to be powered
	if ((state == STATE_OFF) || (state == STATE_PROGRAMMING)) {
		digitalWrite(PIN_POWER, LOW);
	} else {
		digitalWrite(PIN_POWER, HIGH);
	}

//-----------------------------------------------------------------------------
// prog watchdog

	progTimer.update();

//-----------------------------------------------------------------------------
// serial input

	if (Serial.available()) {

		// get next char in serial buffer
		char c = Serial.read();

		// command start
		if (c == CMD_START) {
			serialState = SERIAL_STATE_CMD;
			serialCmd = "";
			serialValue = "";

		// command end, value start
		} else if (c == CMD_SEPERATOR) {
			serialState = SERIAL_STATE_VALUE;

		// value end
		} else if (c == CMD_END) {
			serialState = SERIAL_STATE_NONE;
			Serial.println("Serial cmd: " + serialCmd);
			Serial.println("Serial val: " + serialValue);

			// check which command we got

//			if (serialCmd == "PGM") {
//				if (serialValue == "START") {
//					beforeProgState = STATE_ON;
//					startProgramming();
//				} else if (serialValue == "STOP") {
//					stopProgramming();
//				} else if (serialValue == "NEXT") {
//
//					// simulate button press
//					doShortPress(&button);
//				}
//			}

			if (serialCmd == "LEDO") {
				int ledOff = serialValue.toInt();
				EEPROM.update(EEPROM_ADDR_STATUS_OFF, ledOff);
			} else if (serialCmd == "LEDB") {
				int statusBrightness = serialValue.toInt();

				// since we convert to int, clamp it at byte value
				if (statusBrightness < 0) {
					statusBrightness = 0;
				} else if (statusBrightness > 255) {
					statusBrightness = 255;
				}

				// will take effect in next update()
				EEPROM.update(EEPROM_ADDR_BRIGHTNESS, statusBrightness);
				EEPROM.update(EEPROM_ADDR_BRIGHT_SET, 1);
				ledStatus.setLevel(statusBrightness);
			} else if (serialCmd == "LEDT") {

				// will take effect in next update()
				int pulse = serialValue.toInt();
				EEPROM.update(EEPROM_ADDR_PULSE, pulse);
			} else if (serialCmd == "LEDS") {

				// will take effect in next update()
				int inv = serialValue.toInt();
				EEPROM.update(EEPROM_ADDR_INVERT, inv);
			} else if (serialCmd == "REC") {
				beforeProgState = STATE_ON;
				startProgramming();
			} else if (serialCmd == "LPT") {

				// will take effect in next uopdate()
				unsigned long lpt = serialValue.toInt();
				EEPROMWriteLong(EEPROM_ADDR_HOLD_TIME, lpt);
			} else if (serialCmd == "LPA") {

				// will take effect in next uopdate()
				int lpa = serialValue.toInt();
				EEPROM.update(EEPROM_ADDR_HOLD_ACTION, lpa);
			} else if (serialCmd == "VER") {
				Serial.print("N=");
				Serial.println(VERSION_NUMBER);
				Serial.print("B=");
				Serial.println(VERSION_BUILD);
			// } else if (serialCmd == "SHT") {
			// 	doOff();
			// } else if (serialCmd == "RBT") {
			// 	doReboot();
			}

		// build up command or value
		} else {
			if (serialState == SERIAL_STATE_CMD) {
				serialCmd += String(c);
			} else if (serialState == SERIAL_STATE_VALUE) {
				serialValue += String(c);
			}
		}
	}

}
