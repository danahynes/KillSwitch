/*-----------------------------------------------------------------------------
 * KillSwitch.cpp
 * KillSwitch
 *
 * Copyright © 2019 Dana Hynes <danahynes@gmail.com>
 * This work is free. You can redistribute it and/or modify it under the terms
 * of the Do What The Fuck You Want To Public License, Version 2, as published
 * by Sam Hocevar. See the LICENSE file for more details.
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
// Defines

#define DH_DEBUG 1
#define ERASE_EEPROM 0

//-----------------------------------------------------------------------------
// Constants

const char VERSION_NUMBER[] PROGMEM = "0.4.16";

const int STATE_OFF = 0;
const int STATE_BOOTING = 1;
const int STATE_ON = 2;
const int STATE_SHUTDOWN = 3;
const int STATE_REBOOT = 4;

const int PROG_STATE_NONE = 0;
const int PROG_STATE_CODE_ON = 1;
const int PROG_STATE_CODE_OFF = 2;

#if DH_DEBUG == 1
const int PIN_BUTTON = 2;
const int PIN_IR = 7;
const int PIN_FEEDBACK = 5;
const int PIN_STATUS = 6;
const int PIN_TRIGGER = 13;
const int PIN_POWER = 4;

const int PIN_DEBUG_FEEDBACK_IN = 8;
const int PIN_DEBUG_FEEDBACK_OUT = 9;
#else
// TODO: pins for ATTiny84
#endif

const int DEBOUNCE_DELAY = 50;
const int HOLD_TIME_DEFAULT = 5000;

const int STATUS_ON_BRIGHTNESS_DEFAULT = 255;

const int STATUS_TYPE_NORMAL = 0;
const int STATUS_TYPE_INVERT = 1;
const int STATUS_TYPE_OFF = 2;

const int PROG_TIMEOUT = 15000;

const int EEPROM_ADDR_CODE_ON = 0;
const int EEPROM_ADDR_CODE_OFF = 4;
const int EEPROM_ADDR_SET_DEFAULT = 8;
const int EEPROM_ADDR_ON_BRIGHTNESS = 9;
const int EEPROM_ADDR_OFF_BRIGHTNESS = 10;
const int EEPROM_ADDR_TYPE = 11;
const int EEPROM_ADDR_PULSE = 12;
const int EEPROM_ADDR_HOLD_TIME = 13;
const int EEPROM_ADDR_HOLD_ACTION = 17;
const int EEPROM_ADDR_POWER_AFTER_FAIL = 18;
const int EEPROM_ADDR_POWER_WAS_ON = 19;

const int PULSE_CYCLE_SLOW = 500;
const int PULSE_CYCLE_FAST = 125;
const int FLASH_CYCLE_SLOW = 1000;
const int FLASH_CYCLE_FAST = 250;

const int TRIGGER_SHUTDOWN_TIME = 100;
const int TRIGGER_REBOOT_TIME = 500;

const char CMD_START = '?';
const char CMD_SEPERATOR = '|';
const char CMD_END = '!';

const int SERIAL_BUFF_SIZE = 8;

const int SERIAL_STATE_NONE = 0;
const int SERIAL_STATE_CMD = 1;
const int SERIAL_STATE_VALUE = 2;

const char SERIAL_LBN[] PROGMEM = "LBN"; // led on brightness
const char SERIAL_LBF[] PROGMEM = "LBF"; // led off brightness
const char SERIAL_LTP[] PROGMEM = "LTP"; // led type
const char SERIAL_LPL[] PROGMEM = "LPL"; // led pulse
const char SERIAL_REC[] PROGMEM = "REC";
const char SERIAL_LPT[] PROGMEM = "LPT";
const char SERIAL_LPA[] PROGMEM = "LPA";
const char SERIAL_PWR[] PROGMEM = "PWR";

//-----------------------------------------------------------------------------
// Variables

int state = STATE_OFF;
int progState = PROG_STATE_NONE;

DHButton button(PIN_BUTTON, true, DEBOUNCE_DELAY);

#if DH_DEBUG == 1
DHButton tmpFeedback(PIN_DEBUG_FEEDBACK_IN, true, DEBOUNCE_DELAY);
#endif

IRrecv irrecv(PIN_IR);
decode_results results;

DHPulseCounter feedbackCounter(PIN_FEEDBACK, LOW);

DHLED ledStatus(PIN_STATUS);

bool progChanging = false;
bool progFlashStart = false;
DHTimer progTimer(PROG_TIMEOUT);

DHTimer triggerTimer(TRIGGER_SHUTDOWN_TIME);

char serialCmd[SERIAL_BUFF_SIZE];
char serialValue[SERIAL_BUFF_SIZE];
int serialState = SERIAL_STATE_NONE;
int serialIndex = 0;

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
void sendSerial(char* CMD, char* VAL) {
	Serial.print(CMD_START);
	Serial.print(CMD);
	Serial.print(CMD_SEPERATOR);
	Serial.print(VAL);
	Serial.println(CMD_END);
}

/*-----------------------------------------------------------------------------
 * Starts booting the pi.
 ----------------------------------------------------------------------------*/
void doBootup() {
	if (state != STATE_BOOTING) {
		state = STATE_BOOTING;

		// reset brightness
		int statusOnBrightness = EEPROM.read(EEPROM_ADDR_ON_BRIGHTNESS);
		ledStatus.setLevel(statusOnBrightness);

#if DH_DEBUG == 1
		Serial.println(F("state changed to STATE_BOOTING"));
#endif

		// feedback state to watch for when booting
		feedbackCounter.setValue(LOW);
	}
}

/*-----------------------------------------------------------------------------
 * Starts shutting down the pi.
 ----------------------------------------------------------------------------*/
void doShutdown(bool changeTrigger = true) {
	if (state != STATE_SHUTDOWN) {
		state = STATE_SHUTDOWN;

		// reset brightness
		int statusOnBrightness = EEPROM.read(EEPROM_ADDR_ON_BRIGHTNESS);
		ledStatus.setLevel(statusOnBrightness);

#if DH_DEBUG == 1
		Serial.println(F("state changed to STATE_SHUTDOWN"));
#endif

		// feedback state to watch for when shutting down
		feedbackCounter.setValue(HIGH);

		if (changeTrigger) {

			// set the trigger state and starts its timer
			digitalWrite(PIN_TRIGGER, HIGH);
			triggerTimer.setTime(TRIGGER_SHUTDOWN_TIME);
			triggerTimer.start();
		}
	}
}

/*-----------------------------------------------------------------------------
 * Reboots the pi.
 ----------------------------------------------------------------------------*/
void doReboot(bool changeTrigger = true) {
	if (state != STATE_REBOOT) {
		state = STATE_REBOOT;

		// reset brightness
		int statusOnBrightness = EEPROM.read(EEPROM_ADDR_ON_BRIGHTNESS);
		ledStatus.setLevel(statusOnBrightness);

#if DH_DEBUG == 1
		Serial.println(F("state changed to STATE_REBOOT"));
#endif

		// feedback state to watch for when rebooting
		feedbackCounter.setValue(LOW);

		if (changeTrigger) {

			// set the trigger state and starts its timer
			digitalWrite(PIN_TRIGGER, HIGH);
			triggerTimer.setTime(TRIGGER_REBOOT_TIME);
			triggerTimer.start();
		}
	}
}

/*-----------------------------------------------------------------------------
 * Puts the device into programming mode.
 ----------------------------------------------------------------------------*/
void startProgramming() {

	// reset brightness
	int statusOnBrightness = EEPROM.read(EEPROM_ADDR_ON_BRIGHTNESS);
	ledStatus.setLevel(statusOnBrightness);

	// change prog state
	progState = PROG_STATE_CODE_ON;

#if DH_DEBUG == 1
	Serial.println(F("progState changed to PROG_STATE_CODE_ON"));
#endif

	// don't count flashes, start watchdog
	progChanging = false;
	progTimer.start();
}

/*-----------------------------------------------------------------------------
 * Takes the device out of programming mode.
 ----------------------------------------------------------------------------*/
void stopProgramming() {

	// change prog state
	progState = PROG_STATE_NONE;

#if DH_DEBUG == 1
	Serial.println(F("progState changed to PROG_STATE_NONE"));
#endif

	// don't count flashes, stop watchdog
	progChanging = false;
	progTimer.stop();
}

/*-----------------------------------------------------------------------------
 * Called when the button has been pressed for a short time (< hold time).
 ----------------------------------------------------------------------------*/
void doShortPress(DHButton* button) {

	// normal
	if (progState == PROG_STATE_NONE) {
		if (state == STATE_OFF) {
			doBootup();
		} else if (state == STATE_ON) {
			doShutdown();
		}

	// programming
	} else {
		if (progState == PROG_STATE_CODE_ON) {

			// count flashes, start watchdog
			progChanging = true;
			progTimer.start();
		} else if (progState == PROG_STATE_CODE_OFF) {

			// make off code same as on code
			long onCode = EEPROMReadLong(EEPROM_ADDR_CODE_ON);
			long offCode = onCode;
			EEPROMWriteLong(EEPROM_ADDR_CODE_OFF, offCode);

			// count flashes before exiting programming mode
			progChanging = true;
		}
	}
}

/*-----------------------------------------------------------------------------
 * Called when the button is held longer than the hold time.
 ----------------------------------------------------------------------------*/
void doLongPress(DHButton* button) {

	// normal
	if (progState == PROG_STATE_NONE) {

		// get long press action
		bool forceQuitOnHold = EEPROM.read(EEPROM_ADDR_HOLD_ACTION);

		if (state == STATE_ON) {
			if (!forceQuitOnHold) {
				doReboot();
			} else {

				// force shutdown
				state = STATE_OFF;

				// store state for auto boot after power fail
				EEPROM.write(EEPROM_ADDR_POWER_WAS_ON, 0);

#if DH_DEBUG == 1
				Serial.println(F("state changed to STATE_OFF"));
#endif

			}
		} else if (state == STATE_OFF) {
			startProgramming();
		}
	} else {

		// abort programming
		stopProgramming();
	}
}

#if DH_DEBUG == 1
/*-----------------------------------------------------------------------------
 * Called when the DEBUG feedback pin goes LOW.
 * This is used to prevent bounce on the pin when using a jumper by hand.
 ----------------------------------------------------------------------------*/
void doFeedbackPress(DHButton* button) {
	digitalWrite(PIN_DEBUG_FEEDBACK_OUT, LOW);
}

/*-----------------------------------------------------------------------------
 * Called when the DEBUG feedback pin goes HIGH.
 * This is used to prevent bounce on the pin when using a jumper by hand.
 ----------------------------------------------------------------------------*/
void doFeedbackRelease(DHButton* button) {
	digitalWrite(PIN_DEBUG_FEEDBACK_OUT, HIGH);
}
#endif

/*-----------------------------------------------------------------------------
 * Called when the trigger timer expires.
 ----------------------------------------------------------------------------*/
void doTriggerTimerUp(DHTimer* timer) {
	digitalWrite(PIN_TRIGGER, LOW);
}

/*-----------------------------------------------------------------------------
 * Called when the programming watchdog timer expires.
 ----------------------------------------------------------------------------*/
void doProgTimerUp(DHTimer* timer) {

	// abort programming
	stopProgramming();
}

/*-----------------------------------------------------------------------------
 * Called when the LED is done flashing for a count.
 ----------------------------------------------------------------------------*/
void doLEDDoneFlashing(DHLED* led) {

	// NB: delay() is bad but we need to differentiate between
	// the "waiting for code" flashes and the "got a code" flashes
	// is it worth a whole other timer/callback for this?
	delay(FLASH_CYCLE_SLOW / 2);

	// stop counting flashes
	progFlashStart = false;
	progChanging = false;

	// switch from on code to off code
	if (progState == PROG_STATE_CODE_ON) {
		progState = PROG_STATE_CODE_OFF;

#if DH_DEBUG == 1
		Serial.println(F("progState changed to PROG_STATE_CODE_OFF"));
#endif

	} else if (progState == PROG_STATE_CODE_OFF) {

		// done with off code
		stopProgramming();
	}
}

/*-----------------------------------------------------------------------------
 * Called when the pulse counter is done counting.
 ----------------------------------------------------------------------------*/
void doCounterDone(DHPulseCounter* counter) {

	/* N.B.
	The counter is basically used to differentiate between a pulse count (early
	in shutdown/reboot) and a permanent change (after the boot/shutdown/reboot
	process is complete), on the feedback line.
	Only a permanent change is seen at bootup.
	This method is only called when the pin changes from the NOT WANTED state to
	the WANTED state. So if the line is LOW, and you're looking for a LOW, this
	method will wait until the pin goes HIGH, and then goes LOW. If the pin is
	HIGH, and you're looking for a LOW, this method will be called as soon as
	the pin changes. (This  actually makes it an edge detector, but that's
	really just semantics... and also this class includes the counter part,
	which an edge detector would not)

	For pulses, the parameter to doShutdown/doReboot determines whether we
	toggle the trigger pin, by testing for state.
	If the state is ON, then we weren't expecting this event and thus got here
	by GUI. In that case, the pi already knows about the event, so don't confuse
	it by toggling the trigger.
	If the state is anything else, we got here by the button/ir since their code
	does the change at the event. We need to toggle the trigger pin to tell the
	pi what to do in their code, not here.
	Ir is shutdown only. Button is shutdown, and reboot if set to reboot and not
	force shutdown, otherwise it kills the power using the arduino's output and
	there is no need for scripting (see the killswitch-settings script).

	If it's a solid change (i.e. no pulses for longer than the default of 1
	second), the pi has changed state. So we set the new state based on the old
	state and the new feedback reading. We also invert the line level we are
	looking for, to watch for the next event.
	*/

	int pulses = counter->getCount();

	// if there are pulses, we are early in the shutdown
	if (pulses > 0) {

#if DH_DEBUG == 1
		Serial.print(F("pulses: "));
		Serial.println(pulses);
#endif

		// if state is on, change came from GUI
		if (state == STATE_ON) {
			if (pulses == 1) {

				// start of shutdown (don't touch trigger)
				doShutdown(false);
			} else if (pulses == 2) {

				// start of reboot (don't touch trigger)
				doReboot(false);
			}
		}

	// no pulses, finish boot/shutdown/reboot
	} else {

#if DH_DEBUG == 1
		Serial.println(F("no pulses"));
#endif

		// if feedback went LOW, we are booted
		if (digitalRead(PIN_FEEDBACK) == LOW) {
			state = STATE_ON;

			// store state for auto boot after power fail
			EEPROM.write(EEPROM_ADDR_POWER_WAS_ON, 1);

#if DH_DEBUG == 1
			Serial.println(F("state changed to STATE_ON"));
#endif

			// new feedback state to watch for
			feedbackCounter.setValue(HIGH);

		// if feedback went HIGH, we are shut down
		} else if (digitalRead(PIN_FEEDBACK) == HIGH) {
			state = STATE_OFF;

			// store state for auto boot after power fail
			EEPROM.write(EEPROM_ADDR_POWER_WAS_ON, 0);

#if DH_DEBUG == 1
			Serial.println(F("state changed to STATE_OFF"));
#endif

			// new feedback state to watch for
			feedbackCounter.setValue(LOW);
		}
	}
}

//-----------------------------------------------------------------------------
// Main Program

/*-----------------------------------------------------------------------------
 * Called once when the program starts.
 ----------------------------------------------------------------------------*/
void setup() {

#if ERASE_EEPROM == 1
	EEPROMWriteLong(EEPROM_ADDR_CODE_ON, 0);
	EEPROMWriteLong(EEPROM_ADDR_CODE_OFF, 0);
	EEPROM.write(EEPROM_ADDR_SET_DEFAULT, 0);
	EEPROM.write(EEPROM_ADDR_ON_BRIGHTNESS, 0);
	EEPROM.write(EEPROM_ADDR_OFF_BRIGHTNESS, 0);
	EEPROM.write(EEPROM_ADDR_TYPE, 0);
	EEPROM.write(EEPROM_ADDR_PULSE, 0);
	EEPROMWriteLong(EEPROM_ADDR_HOLD_TIME, 0);
	EEPROM.write(EEPROM_ADDR_HOLD_ACTION, 0);
	EEPROM.write(EEPROM_ADDR_POWER_AFTER_FAIL, 0);
	EEPROM.write(EEPROM_ADDR_POWER_WAS_ON, 0);
#endif

#if DH_DEBUG == 1
	EEPROM.write(EEPROM_ADDR_PULSE, 1);
#endif

	// start serial port
	Serial.begin(9600);

	// pin directions
	pinMode(PIN_IR, INPUT_PULLUP);
	pinMode(PIN_FEEDBACK, INPUT_PULLUP);
	pinMode(PIN_TRIGGER, OUTPUT);
	pinMode(PIN_POWER, OUTPUT);

#if DH_DEBUG == 1
	pinMode(PIN_DEBUG_FEEDBACK_OUT, OUTPUT);
#endif

	// pin values
	digitalWrite(PIN_STATUS, LOW);
	digitalWrite(PIN_TRIGGER, LOW);
	digitalWrite(PIN_POWER, LOW);

#if DH_DEBUG == 1
	digitalWrite(PIN_DEBUG_FEEDBACK_OUT, HIGH);
#endif

	// set defaults
	int holdTime = EEPROMReadLong(EEPROM_ADDR_HOLD_TIME);
	byte statusOnBrightness = EEPROM.read(EEPROM_ADDR_ON_BRIGHTNESS);
	int setDefaults = EEPROM.read(EEPROM_ADDR_SET_DEFAULT);
	if (setDefaults == 0) {

		// set hold time
		holdTime = HOLD_TIME_DEFAULT;
		EEPROMWriteLong(EEPROM_ADDR_HOLD_TIME, holdTime);

		// set on brightness
		statusOnBrightness = STATUS_ON_BRIGHTNESS_DEFAULT;
		EEPROM.write(EEPROM_ADDR_ON_BRIGHTNESS, statusOnBrightness);

		// defaults are set
		EEPROM.write(EEPROM_ADDR_SET_DEFAULT, 1);
	}

	// set up button
	button.setHoldTime(holdTime);
	button.setOnShortPress(doShortPress);
	button.setOnLongPress(doLongPress);

#if DH_DEBUG == 1
	tmpFeedback.setOnPress(doFeedbackPress);
	tmpFeedback.setOnRelease(doFeedbackRelease);
#endif

#if DH_BEBUG == 0
	// set up ir receiver
	irrecv.enableIRIn();
#endif

	// set up timers
	triggerTimer.setOnDone(doTriggerTimerUp);
	progTimer.setOnDone(doProgTimerUp);

	// set up LED
	int statusOffBrightness = EEPROM.read(EEPROM_ADDR_OFF_BRIGHTNESS);
	ledStatus.setLevel(statusOffBrightness);
	ledStatus.setOnDoneFlashing(doLEDDoneFlashing);
	ledStatus.on();

	// set up pulse counter
	feedbackCounter.setOnDone(doCounterDone);
	feedbackCounter.setValue(LOW);

	// check for auto boot after power failure
	int bootAfterFail = EEPROM.read(EEPROM_ADDR_POWER_AFTER_FAIL);
	if (bootAfterFail) {
		int wasOn = EEPROM.read(EEPROM_ADDR_POWER_WAS_ON);
		if (wasOn) {
			doBootup();
		}
	}
}

/*-----------------------------------------------------------------------------
 * Called repeatedly during the program's life.
 ----------------------------------------------------------------------------*/
void loop() {

//-----------------------------------------------------------------------------
// button

	button.update();

#if DH_DEBUG == 1
	tmpFeedback.update();
#endif

//-----------------------------------------------------------------------------
// ir

	if (irrecv.decode(&results)) {

#if DEBUG == 1
		Serial.println(results.value, HEX);
#endif

		if (results.value != REPEAT) {

			// normal on/off
			if (progState == PROG_STATE_NONE) {
				unsigned long onCode = EEPROMReadLong(EEPROM_ADDR_CODE_ON);
				unsigned long offCode = EEPROMReadLong(EEPROM_ADDR_CODE_OFF);
				if ((results.value == onCode) && (state == STATE_OFF)) {
					doBootup();
				} else if ((results.value == offCode) && (state == STATE_ON)) {
					doShutdown();
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

	// get current values of type and pulse from properties
	int statusType = EEPROM.read(EEPROM_ADDR_TYPE);
	bool statusOff = (statusType == STATUS_TYPE_OFF);
	bool statusInvert = (statusType == STATUS_TYPE_INVERT);
	bool statusPulse = EEPROM.read(EEPROM_ADDR_PULSE);

	// normal
	if (progState == PROG_STATE_NONE) {

		// states that require flashing
		if ((state == STATE_BOOTING) ||
				(state == STATE_SHUTDOWN) ||
				(state == STATE_REBOOT)) {

			// flash/pulse slow
			if (statusOff) {
				ledStatus.off();
			} else {
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
			}

		// no flashing
		} else if (state == STATE_ON) {
			if (statusOff) {
				ledStatus.off();
			} else {
				if (statusInvert) {
					byte br = EEPROM.read(EEPROM_ADDR_OFF_BRIGHTNESS);
					ledStatus.setLevel(br);
				} else {
					byte br = EEPROM.read(EEPROM_ADDR_ON_BRIGHTNESS);
					ledStatus.setLevel(br);
				}
				ledStatus.on();
			}

		// no flashing
		} else if (state == STATE_OFF) {
			if (statusOff) {
				ledStatus.off();
			} else {
				if (statusInvert) {
					byte br = EEPROM.read(EEPROM_ADDR_ON_BRIGHTNESS);
					ledStatus.setLevel(br);
				} else {
					byte br = EEPROM.read(EEPROM_ADDR_OFF_BRIGHTNESS);
					ledStatus.setLevel(br);
				}
				ledStatus.on();
			}
		}
	} else {

		// slow flash for confirmation
		if (progChanging) {

			// put the led in a known state and start a new cycle
			if (progFlashStart == false) {
				progFlashStart = true;

				// off for half cycle before flash
				ledStatus.off();

				// NB: delay() is bad but we need to differentiate between
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
	if (state == STATE_OFF) {
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
			memset(serialCmd, 0, SERIAL_BUFF_SIZE);
			memset(serialValue, 0, SERIAL_BUFF_SIZE);
			serialIndex = 0;

		// command end, value start
		} else if (c == CMD_SEPERATOR) {
			serialState = SERIAL_STATE_VALUE;
			serialIndex = 0;

		// value end
		} else if (c == CMD_END) {
			serialState = SERIAL_STATE_NONE;
			serialIndex = 0;

#if DH_DEBUG == 1
			Serial.print(F("Serial cmd: "));
			Serial.println(serialCmd);
			Serial.print(F("Serial val: "));
			Serial.println(serialValue);
#endif

			// check which command we got
			if (strcmp_P(serialCmd, SERIAL_LBN) == 0) {
				int lbn = atoi(serialValue);

				// will take effect in next update()
				EEPROM.update(EEPROM_ADDR_ON_BRIGHTNESS, lbn);
			} else if (strcmp_P(serialCmd, SERIAL_LBF) == 0) {
				int lbf = atoi(serialValue);

				// will take effect in next update()
				EEPROM.update(EEPROM_ADDR_OFF_BRIGHTNESS, lbf);
			} else if (strcmp_P(serialCmd, SERIAL_LTP) == 0) {
				int ltp = atoi(serialValue);

				// will take effect in next update()
				EEPROM.update(EEPROM_ADDR_TYPE, ltp);
			} else if (strcmp_P(serialCmd, SERIAL_LPL) == 0) {

				// will take effect in next update()
				int lpl = atoi(serialValue);
				EEPROM.update(EEPROM_ADDR_PULSE, lpl);
			} else if (strcmp_P(serialCmd, SERIAL_REC) == 0) {
				startProgramming();
			} else if (strcmp_P(serialCmd, SERIAL_LPT) == 0) {

				// will take effect in next uopdate()
				unsigned long lpt = atol(serialValue);
				EEPROMWriteLong(EEPROM_ADDR_HOLD_TIME, lpt);
			} else if (strcmp_P(serialCmd, SERIAL_LPA) == 0) {

				// will take effect in next uopdate()
				int lpa = atoi(serialValue);
				EEPROM.update(EEPROM_ADDR_HOLD_ACTION, lpa);
			} else if (strcmp_P(serialCmd, SERIAL_PWR) == 0) {

				// will take effect in next uopdate()
				int pwr = atoi(serialValue);
				EEPROM.update(EEPROM_ADDR_POWER_AFTER_FAIL, pwr);
			}

		// build up command or value
		} else {
			if (serialState == SERIAL_STATE_CMD) {
				serialCmd[serialIndex++] = c;
			} else if (serialState == SERIAL_STATE_VALUE) {
				serialValue[serialIndex++] = c;
			}
		}
	}
}

// -)
