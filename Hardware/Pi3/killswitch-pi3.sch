EESchema Schematic File Version 4
LIBS:killswitch-pi3-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "KillSwitch for Pi 3"
Date "2019-06-11"
Rev "0.1.31"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L device:C C2
U 1 1 5B892C60
P 8400 3200
F 0 "C2" H 8425 3300 50  0000 L CNN
F 1 "10nF" H 8425 3100 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 8438 3050 50  0001 C CNN
F 3 "" H 8400 3200 50  0001 C CNN
	1    8400 3200
	1    0    0    -1  
$EndComp
$Comp
L opto:TSDP341xx U2
U 1 1 5B892CCF
P 5750 4950
F 0 "U2" H 5350 5250 50  0000 L CNN
F 1 "TSDP341xx" H 5350 4650 50  0000 L CNN
F 2 "Opto-Devices:IRReceiver_Vishay_MOLD-3pin" H 5700 4575 50  0001 C CNN
F 3 "" H 6400 5250 50  0001 C CNN
	1    5750 4950
	0    -1   -1   0   
$EndComp
$Comp
L device:C C3
U 1 1 5B892D2F
P 2250 4850
F 0 "C3" H 2275 4950 50  0000 L CNN
F 1 "10nF" H 2275 4750 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 2288 4700 50  0001 C CNN
F 3 "" H 2250 4850 50  0001 C CNN
	1    2250 4850
	1    0    0    -1  
$EndComp
$Comp
L device:R R1
U 1 1 5B892DD1
P 2250 4550
F 0 "R1" V 2330 4550 50  0000 C CNN
F 1 "4.7K" V 2250 4550 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 2180 4550 50  0001 C CNN
F 3 "" H 2250 4550 50  0001 C CNN
	1    2250 4550
	1    0    0    -1  
$EndComp
$Comp
L device:R R4
U 1 1 5B892DFC
P 5200 4300
F 0 "R4" V 5280 4300 50  0000 C CNN
F 1 "100" V 5200 4300 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 5130 4300 50  0001 C CNN
F 3 "" H 5200 4300 50  0001 C CNN
	1    5200 4300
	1    0    0    -1  
$EndComp
$Comp
L device:R R3
U 1 1 5B892E2B
P 4750 4750
F 0 "R3" V 4830 4750 50  0000 C CNN
F 1 "1K" V 4750 4750 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 4680 4750 50  0001 C CNN
F 3 "" H 4750 4750 50  0001 C CNN
	1    4750 4750
	1    0    0    -1  
$EndComp
$Comp
L device:LED D1
U 1 1 5B892E70
P 4750 4100
F 0 "D1" H 4750 4200 50  0000 C CNN
F 1 "LED" H 4750 4000 50  0000 C CNN
F 2 "LEDs:LED_0603_HandSoldering" H 4750 4100 50  0001 C CNN
F 3 "" H 4750 4100 50  0001 C CNN
	1    4750 4100
	0    -1   -1   0   
$EndComp
$Comp
L switches:SW_Push SW1
U 1 1 5B892EE0
P 4300 4100
F 0 "SW1" H 4350 4200 50  0000 L CNN
F 1 "SW_Push" H 4300 4040 50  0000 C CNN
F 2 "Buttons_Switches_SMD:SW_SPST_PTS645" H 4300 4300 50  0001 C CNN
F 3 "" H 4300 4300 50  0001 C CNN
	1    4300 4100
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR01
U 1 1 5B893057
P 2250 5200
F 0 "#PWR01" H 2250 4950 50  0001 C CNN
F 1 "GND" H 2250 5050 50  0000 C CNN
F 2 "" H 2250 5200 50  0001 C CNN
F 3 "" H 2250 5200 50  0001 C CNN
	1    2250 5200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5B89327D
P 5200 5200
F 0 "#PWR02" H 5200 4950 50  0001 C CNN
F 1 "GND" H 5200 5050 50  0000 C CNN
F 2 "" H 5200 5200 50  0001 C CNN
F 3 "" H 5200 5200 50  0001 C CNN
	1    5200 5200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 5B89336A
P 8400 4050
F 0 "#PWR03" H 8400 3800 50  0001 C CNN
F 1 "GND" H 8400 3900 50  0000 C CNN
F 2 "" H 8400 4050 50  0001 C CNN
F 3 "" H 8400 4050 50  0001 C CNN
	1    8400 4050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR05
U 1 1 5B893627
P 4750 5200
F 0 "#PWR05" H 4750 4950 50  0001 C CNN
F 1 "GND" H 4750 5050 50  0000 C CNN
F 2 "" H 4750 5200 50  0001 C CNN
F 3 "" H 4750 5200 50  0001 C CNN
	1    4750 5200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR06
U 1 1 5B893659
P 4300 5200
F 0 "#PWR06" H 4300 4950 50  0001 C CNN
F 1 "GND" H 4300 5050 50  0000 C CNN
F 2 "" H 4300 5200 50  0001 C CNN
F 3 "" H 4300 5200 50  0001 C CNN
	1    4300 5200
	1    0    0    -1  
$EndComp
Text GLabel 6000 3600 0    60   Input ~ 0
TR_A
Text GLabel 6000 3800 0    60   Input ~ 0
FB_A
Text GLabel 6000 3200 0    60   Input ~ 0
MOSI_A
Text GLabel 6000 2600 0    60   Input ~ 0
RST_A
Wire Wire Line
	5200 4450 5200 4500
Connection ~ 5200 4500
Wire Wire Line
	4750 4250 4750 4600
Wire Wire Line
	4750 4900 4750 5200
Text GLabel 6000 2900 0    60   Input ~ 0
TX_A
Text GLabel 6000 2800 0    60   Input ~ 0
RX_A
$Comp
L power:GND #PWR07
U 1 1 5B893D92
P 1500 3450
F 0 "#PWR07" H 1500 3200 50  0001 C CNN
F 1 "GND" H 1500 3300 50  0000 C CNN
F 2 "" H 1500 3450 50  0001 C CNN
F 3 "" H 1500 3450 50  0001 C CNN
	1    1500 3450
	1    0    0    -1  
$EndComp
$Comp
L device:CP C1
U 1 1 5B893E32
P 1550 1800
F 0 "C1" H 1575 1900 50  0000 L CNN
F 1 "10uF" H 1575 1700 50  0000 L CNN
F 2 "Capacitors_SMD:CP_Elec_3x5.3" H 1588 1650 50  0001 C CNN
F 3 "" H 1550 1800 50  0001 C CNN
	1    1550 1800
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG011
U 1 1 5B893FBF
P 1500 3150
F 0 "#FLG011" H 1500 3225 50  0001 C CNN
F 1 "PWR_FLAG" H 1500 3300 50  0000 C CNN
F 2 "" H 1500 3150 50  0001 C CNN
F 3 "" H 1500 3150 50  0001 C CNN
	1    1500 3150
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG012
U 1 1 5B893FE9
P 1150 3450
F 0 "#FLG012" H 1150 3525 50  0001 C CNN
F 1 "PWR_FLAG" H 1150 3600 50  0000 C CNN
F 2 "" H 1150 3450 50  0001 C CNN
F 3 "" H 1150 3450 50  0001 C CNN
	1    1150 3450
	-1   0    0    1   
$EndComp
Wire Wire Line
	1500 3150 1500 3450
Text GLabel 6700 1350 0    60   Input ~ 0
FB_P
Text GLabel 6700 1450 0    60   Input ~ 0
TR_P
$Comp
L power:GND #PWR014
U 1 1 5B8946FF
P 6900 1950
F 0 "#PWR014" H 6900 1700 50  0001 C CNN
F 1 "GND" H 6900 1800 50  0000 C CNN
F 2 "" H 6900 1950 50  0001 C CNN
F 3 "" H 6900 1950 50  0001 C CNN
	1    6900 1950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR015
U 1 1 5B89472D
P 7650 1950
F 0 "#PWR015" H 7650 1700 50  0001 C CNN
F 1 "GND" H 7650 1800 50  0000 C CNN
F 2 "" H 7650 1950 50  0001 C CNN
F 3 "" H 7650 1950 50  0001 C CNN
	1    7650 1950
	1    0    0    -1  
$EndComp
Text GLabel 7800 1650 2    60   Input ~ 0
TX_P
Text GLabel 7800 1550 2    60   Input ~ 0
RX_P
Wire Wire Line
	6900 1650 7000 1650
Wire Wire Line
	7500 1450 7650 1450
$Comp
L device:CP C4
U 1 1 5B894EA4
P 5200 4750
F 0 "C4" H 5225 4850 50  0000 L CNN
F 1 "100uf" H 5225 4650 50  0000 L CNN
F 2 "Capacitors_SMD:CP_Elec_3x5.3" H 5238 4600 50  0001 C CNN
F 3 "" H 5200 4750 50  0001 C CNN
	1    5200 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2250 4700 2500 4700
Text GLabel 6700 1750 0    60   Input ~ 0
MOSI_P
Text GLabel 7800 1750 2    60   Input ~ 0
MISO_P
Text GLabel 6000 3300 0    60   Input ~ 0
MISO_A
Text GLabel 6000 3400 0    60   Input ~ 0
SCK_A
Text GLabel 6700 1850 0    60   Input ~ 0
SCK_P
Text GLabel 6700 1550 0    60   Input ~ 0
RST_P
Wire Wire Line
	4300 4300 4300 5200
Wire Wire Line
	6700 1450 7000 1450
Wire Wire Line
	5200 4900 5200 5200
$Comp
L power:GND #PWR017
U 1 1 5B8A8F80
P 6350 5200
F 0 "#PWR017" H 6350 4950 50  0001 C CNN
F 1 "GND" H 6350 5050 50  0000 C CNN
F 2 "" H 6350 5200 50  0001 C CNN
F 3 "" H 6350 5200 50  0001 C CNN
	1    6350 5200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5950 4550 6350 4550
Wire Wire Line
	6350 4550 6350 5200
Wire Wire Line
	5200 4500 5550 4500
Wire Wire Line
	5550 4500 5550 4550
Wire Wire Line
	6300 3700 5750 3700
Wire Wire Line
	5750 3700 5750 4550
Wire Wire Line
	5200 4500 5200 4600
$Comp
L atmel:ATTINY84-20SSU U1
U 1 1 5C0484FF
P 7350 3200
F 0 "U1" H 7350 2333 50  0000 C CNN
F 1 "ATTINY84-20SSU" H 7350 2424 50  0000 C CNN
F 2 "Housings_SOIC:SOIC-14_3.9x8.7mm_Pitch1.27mm" H 7350 3000 50  0001 C CIN
F 3 "http://www.atmel.com/Images/doc8006.pdf" H 7350 3200 50  0001 C CNN
	1    7350 3200
	-1   0    0    1   
$EndComp
$Comp
L conn:USB_OTG J1
U 1 1 5C056CAA
P 1050 1800
F 0 "J1" H 1105 2267 50  0000 C CNN
F 1 "PWR_IN" H 1105 2176 50  0000 C CNN
F 2 "Connectors_USB:USB_Micro-B_Molex-105017-0001" H 1200 1750 50  0001 C CNN
F 3 "" H 1200 1750 50  0001 C CNN
	1    1050 1800
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR08
U 1 1 5C057F09
P 1350 1050
F 0 "#PWR08" H 1350 900 50  0001 C CNN
F 1 "+5V" H 1365 1223 50  0000 C CNN
F 2 "" H 1350 1050 50  0001 C CNN
F 3 "" H 1350 1050 50  0001 C CNN
	1    1350 1050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR04
U 1 1 5C059198
P 1050 2400
F 0 "#PWR04" H 1050 2150 50  0001 C CNN
F 1 "GND" H 1055 2227 50  0000 C CNN
F 2 "" H 1050 2400 50  0001 C CNN
F 3 "" H 1050 2400 50  0001 C CNN
	1    1050 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	950  2200 1050 2200
Wire Wire Line
	1050 2200 1050 2400
Connection ~ 1050 2200
$Comp
L power:+5V #PWR016
U 1 1 5C05DC14
P 8400 2350
F 0 "#PWR016" H 8400 2200 50  0001 C CNN
F 1 "+5V" H 8415 2523 50  0000 C CNN
F 2 "" H 8400 2350 50  0001 C CNN
F 3 "" H 8400 2350 50  0001 C CNN
	1    8400 2350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR018
U 1 1 5C05DCA1
P 2250 4150
F 0 "#PWR018" H 2250 4000 50  0001 C CNN
F 1 "+5V" H 2265 4323 50  0000 C CNN
F 2 "" H 2250 4150 50  0001 C CNN
F 3 "" H 2250 4150 50  0001 C CNN
	1    2250 4150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR011
U 1 1 5C05DE93
P 5200 4150
F 0 "#PWR011" H 5200 4000 50  0001 C CNN
F 1 "+5V" H 5215 4323 50  0000 C CNN
F 2 "" H 5200 4150 50  0001 C CNN
F 3 "" H 5200 4150 50  0001 C CNN
	1    5200 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 1250 7500 1350
NoConn ~ 1350 1800
NoConn ~ 1350 1900
NoConn ~ 7000 1250
Wire Wire Line
	1350 2000 1350 2200
Wire Wire Line
	1350 2200 1050 2200
$Comp
L power:+5V #PWR013
U 1 1 5C06F21D
P 3300 4150
F 0 "#PWR013" H 3300 4000 50  0001 C CNN
F 1 "+5V" H 3315 4323 50  0000 C CNN
F 2 "" H 3300 4150 50  0001 C CNN
F 3 "" H 3300 4150 50  0001 C CNN
	1    3300 4150
	1    0    0    -1  
$EndComp
$Comp
L device:Polyfuse F1
U 1 1 5C075F00
P 1350 1200
F 0 "F1" H 1262 1154 50  0000 R CNN
F 1 "1A" H 1262 1245 50  0000 R CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 1400 1000 50  0001 L CNN
F 3 "" H 1350 1200 50  0001 C CNN
	1    1350 1200
	-1   0    0    1   
$EndComp
Wire Wire Line
	1350 1350 1350 1600
$Comp
L power:+5V #PWR0101
U 1 1 5C0853E7
P 1150 3150
F 0 "#PWR0101" H 1150 3000 50  0001 C CNN
F 1 "+5V" H 1165 3323 50  0000 C CNN
F 2 "" H 1150 3150 50  0001 C CNN
F 3 "" H 1150 3150 50  0001 C CNN
	1    1150 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 3450 1150 3150
$Comp
L device:Q_PMOS_GSD Q1
U 1 1 5C05D7DF
P 3400 4850
F 0 "Q1" H 3606 4896 50  0000 L CNN
F 1 "Q_PMOS_GSD" H 3606 4805 50  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SOT-323_SC-70_Handsoldering" H 3600 4950 50  0001 C CNN
F 3 "" H 3400 4850 50  0001 C CNN
	1    3400 4850
	-1   0    0    1   
$EndComp
Text GLabel 7800 1250 2    50   Input ~ 0
VOUT
Wire Wire Line
	7800 1250 7500 1250
Wire Wire Line
	8400 3050 8400 2600
Wire Wire Line
	8400 2600 8400 2350
Connection ~ 8400 2600
Wire Wire Line
	8400 3350 8400 3800
Wire Wire Line
	1350 2000 1550 2000
Wire Wire Line
	1550 2000 1550 1950
Connection ~ 1350 2000
Wire Wire Line
	1350 1600 1550 1600
Wire Wire Line
	1550 1600 1550 1650
Connection ~ 1350 1600
Text GLabel 3100 5200 0    50   Input ~ 0
VOUT
Wire Wire Line
	3100 5200 3300 5200
Wire Wire Line
	3300 5200 3300 5050
Wire Wire Line
	4300 3100 6300 3100
Wire Wire Line
	2500 4700 2500 2600
Wire Wire Line
	2250 5000 2250 5200
Wire Wire Line
	4300 3100 4300 3900
Connection ~ 2250 4700
Wire Wire Line
	8400 3800 8400 4050
Connection ~ 8400 3800
Wire Wire Line
	2500 2600 6300 2600
Wire Wire Line
	6300 3500 4750 3500
Wire Wire Line
	4750 3500 4750 3950
Wire Wire Line
	6000 3600 6300 3600
Text GLabel 6000 3100 0    50   Input ~ 0
BTN
Text GLabel 6000 3500 0    50   Input ~ 0
LED
Text GLabel 4850 1250 0    50   Input ~ 0
BTN
Text GLabel 4850 1450 0    50   Input ~ 0
LED
Wire Wire Line
	5050 1450 4850 1450
$Comp
L power:GND #PWR09
U 1 1 5C0C0F0C
P 5000 2050
F 0 "#PWR09" H 5000 1800 50  0001 C CNN
F 1 "GND" H 5005 1877 50  0000 C CNN
F 2 "" H 5000 2050 50  0001 C CNN
F 3 "" H 5000 2050 50  0001 C CNN
	1    5000 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	5050 1550 5000 1550
Connection ~ 7500 1250
Wire Wire Line
	7650 1450 7650 1850
Wire Wire Line
	6900 1650 6900 1950
Wire Wire Line
	7500 1650 7800 1650
Wire Wire Line
	6000 2900 6300 2900
Wire Wire Line
	6000 3300 6300 3300
Wire Wire Line
	6300 3200 6000 3200
Wire Wire Line
	3300 4150 3300 4350
Wire Wire Line
	2250 4150 2250 4400
$Comp
L device:R R2
U 1 1 5C5E8AF0
P 3600 4500
F 0 "R2" H 3670 4546 50  0000 L CNN
F 1 "50K" V 3600 4450 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 3530 4500 50  0001 C CNN
F 3 "" H 3600 4500 50  0001 C CNN
	1    3600 4500
	1    0    0    -1  
$EndComp
$Comp
L device:R R5
U 1 1 5C5E8B9C
P 3800 4850
F 0 "R5" V 3700 4800 50  0000 C CNN
F 1 "1K" V 3800 4850 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 3730 4850 50  0001 C CNN
F 3 "" H 3800 4850 50  0001 C CNN
	1    3800 4850
	0    1    1    0   
$EndComp
Wire Wire Line
	3950 4850 4000 4850
Wire Wire Line
	3600 4850 3650 4850
Wire Wire Line
	3600 4350 3300 4350
Connection ~ 3300 4350
Wire Wire Line
	3300 4350 3300 4650
Wire Wire Line
	3600 4650 3600 4850
Connection ~ 3600 4850
$Comp
L conn:Conn_02x07_Odd_Even J3
U 1 1 5C5F3F28
P 7200 1550
F 0 "J3" H 7250 2067 50  0000 C CNN
F 1 "PI" H 7250 1976 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_2x07_Pitch2.54mm" H 7200 1550 50  0001 C CNN
F 3 "~" H 7200 1550 50  0001 C CNN
	1    7200 1550
	1    0    0    -1  
$EndComp
Wire Wire Line
	6700 1350 7000 1350
Wire Wire Line
	6700 1550 7000 1550
Wire Wire Line
	6700 1750 7000 1750
Wire Wire Line
	6700 1850 7000 1850
Wire Wire Line
	7800 1750 7500 1750
Wire Wire Line
	7500 1550 7800 1550
Wire Wire Line
	6000 3400 6300 3400
Wire Wire Line
	6000 3800 6300 3800
Wire Wire Line
	7500 1850 7650 1850
Connection ~ 7650 1850
Wire Wire Line
	7650 1850 7650 1950
$Comp
L texas:TXB0108DQSR U4
U 1 1 5C61E818
P 10100 3100
F 0 "U4" H 9650 2400 50  0000 C CNN
F 1 "TXB0108DQSR" H 9650 2300 50  0000 C CNN
F 2 "Housings_SON:USON-20_2x4mm_Pitch0.4mm" H 10450 3550 50  0001 L CNN
F 3 "http://www.ti.com/lit/ds/symlink/txb0108.pdf" H 10100 3000 50  0001 C CNN
	1    10100 3100
	1    0    0    -1  
$EndComp
Text GLabel 10600 3000 2    60   Input ~ 0
FB_P
Text GLabel 10600 3100 2    60   Input ~ 0
TR_P
Text GLabel 10600 3400 2    60   Input ~ 0
MOSI_P
Text GLabel 10600 3500 2    60   Input ~ 0
SCK_P
Text GLabel 10600 3200 2    60   Input ~ 0
RST_P
Text GLabel 10600 2800 2    60   Input ~ 0
TX_P
Text GLabel 10600 2900 2    60   Input ~ 0
RX_P
Text GLabel 10600 3300 2    60   Input ~ 0
MISO_P
Text GLabel 9600 3000 0    60   Input ~ 0
FB_A
Text GLabel 9600 3100 0    60   Input ~ 0
TR_A
Text GLabel 9600 3400 0    60   Input ~ 0
MOSI_A
Text GLabel 9600 3500 0    60   Input ~ 0
SCK_A
Text GLabel 9600 3200 0    60   Input ~ 0
RST_A
Text GLabel 9600 2800 0    60   Input ~ 0
TX_A
Text GLabel 9600 2900 0    60   Input ~ 0
RX_A
Text GLabel 9600 3300 0    60   Input ~ 0
MISO_A
$Comp
L power:GND #PWR023
U 1 1 5C631261
P 10100 3900
F 0 "#PWR023" H 10100 3650 50  0001 C CNN
F 1 "GND" H 10105 3727 50  0000 C CNN
F 2 "" H 10100 3900 50  0001 C CNN
F 3 "" H 10100 3900 50  0001 C CNN
	1    10100 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	10100 3900 10100 3800
Wire Wire Line
	9600 2800 9700 2800
Wire Wire Line
	9700 2900 9600 2900
Wire Wire Line
	9600 3000 9700 3000
Wire Wire Line
	9700 3100 9600 3100
Wire Wire Line
	9600 3200 9700 3200
Wire Wire Line
	9700 3300 9600 3300
Wire Wire Line
	9600 3400 9700 3400
Wire Wire Line
	9700 3500 9600 3500
Wire Wire Line
	10500 3500 10600 3500
Wire Wire Line
	10600 3400 10500 3400
Wire Wire Line
	10600 3300 10500 3300
Wire Wire Line
	10500 3200 10600 3200
Wire Wire Line
	10600 3100 10500 3100
Wire Wire Line
	10500 3000 10600 3000
Wire Wire Line
	10600 2900 10500 2900
Wire Wire Line
	10500 2800 10600 2800
$Comp
L power:+5V #PWR022
U 1 1 5C65F0EC
P 10000 2150
F 0 "#PWR022" H 10000 2000 50  0001 C CNN
F 1 "+5V" H 10015 2323 50  0000 C CNN
F 2 "" H 10000 2150 50  0001 C CNN
F 3 "" H 10000 2150 50  0001 C CNN
	1    10000 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	10000 2150 10000 2250
$Comp
L device:R R6
U 1 1 5C661D9C
P 9700 2400
F 0 "R6" H 9770 2446 50  0000 L CNN
F 1 "10k" H 9770 2355 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 9630 2400 50  0001 C CNN
F 3 "" H 9700 2400 50  0001 C CNN
	1    9700 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	9700 2550 9700 2700
Wire Wire Line
	9700 2250 10000 2250
Connection ~ 10000 2250
Wire Wire Line
	10000 2250 10000 2400
$Comp
L device:C C8
U 1 1 5C666840
P 9250 2400
F 0 "C8" H 9365 2446 50  0000 L CNN
F 1 "0.1uf" H 9365 2355 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 9288 2250 50  0001 C CNN
F 3 "" H 9250 2400 50  0001 C CNN
	1    9250 2400
	1    0    0    -1  
$EndComp
$Comp
L device:C C9
U 1 1 5C6668B3
P 10700 2400
F 0 "C9" H 10815 2446 50  0000 L CNN
F 1 "0.1uF" H 10815 2355 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 10738 2250 50  0001 C CNN
F 3 "" H 10700 2400 50  0001 C CNN
	1    10700 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR025
U 1 1 5C666A1C
P 10700 2550
F 0 "#PWR025" H 10700 2300 50  0001 C CNN
F 1 "GND" H 10705 2377 50  0000 C CNN
F 2 "" H 10700 2550 50  0001 C CNN
F 3 "" H 10700 2550 50  0001 C CNN
	1    10700 2550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR021
U 1 1 5C666A80
P 9250 2550
F 0 "#PWR021" H 9250 2300 50  0001 C CNN
F 1 "GND" H 9255 2377 50  0000 C CNN
F 2 "" H 9250 2550 50  0001 C CNN
F 3 "" H 9250 2550 50  0001 C CNN
	1    9250 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	9250 2250 9700 2250
Connection ~ 9700 2250
Wire Wire Line
	10200 2400 10200 2250
Wire Wire Line
	10200 2250 10700 2250
$Comp
L regul:AZ1117-3.3 U3
U 1 1 5C66B62E
P 2850 1450
F 0 "U3" H 2850 1692 50  0000 C CNN
F 1 "AZ1117-3.3" H 2850 1601 50  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-89-3_Handsoldering" H 2850 1700 50  0001 C CIN
F 3 "https://www.diodes.com/assets/Datasheets/AZ1117.pdf" H 2850 1450 50  0001 C CNN
	1    2850 1450
	1    0    0    -1  
$EndComp
$Comp
L device:C C5
U 1 1 5C66B6B4
P 2300 1600
F 0 "C5" H 2415 1646 50  0000 L CNN
F 1 "10uF" H 2415 1555 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 2338 1450 50  0001 C CNN
F 3 "" H 2300 1600 50  0001 C CNN
	1    2300 1600
	1    0    0    -1  
$EndComp
$Comp
L device:C C6
U 1 1 5C66B734
P 3300 1600
F 0 "C6" H 3415 1646 50  0000 L CNN
F 1 "22uF" H 3415 1555 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 3338 1450 50  0001 C CNN
F 3 "" H 3300 1600 50  0001 C CNN
	1    3300 1600
	1    0    0    -1  
$EndComp
$Comp
L device:C C7
U 1 1 5C67014F
P 3750 1600
F 0 "C7" H 3865 1646 50  0000 L CNN
F 1 "0.1uF" H 3865 1555 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 3788 1450 50  0001 C CNN
F 3 "" H 3750 1600 50  0001 C CNN
	1    3750 1600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2300 1750 2850 1750
Wire Wire Line
	2850 1750 3300 1750
Connection ~ 2850 1750
Wire Wire Line
	3750 1750 3300 1750
Connection ~ 3300 1750
Wire Wire Line
	3150 1450 3300 1450
Wire Wire Line
	3300 1450 3750 1450
Connection ~ 3300 1450
Wire Wire Line
	2550 1450 2300 1450
Wire Wire Line
	2300 1450 2300 1300
Connection ~ 2300 1450
Wire Wire Line
	3750 1450 3750 1300
Connection ~ 3750 1450
$Comp
L power:GND #PWR019
U 1 1 5C685CA1
P 2850 1900
F 0 "#PWR019" H 2850 1650 50  0001 C CNN
F 1 "GND" H 2855 1727 50  0000 C CNN
F 2 "" H 2850 1900 50  0001 C CNN
F 3 "" H 2850 1900 50  0001 C CNN
	1    2850 1900
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR012
U 1 1 5C685D18
P 2300 1300
F 0 "#PWR012" H 2300 1150 50  0001 C CNN
F 1 "+5V" H 2315 1473 50  0000 C CNN
F 2 "" H 2300 1300 50  0001 C CNN
F 3 "" H 2300 1300 50  0001 C CNN
	1    2300 1300
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR020
U 1 1 5C685DC7
P 3750 1300
F 0 "#PWR020" H 3750 1150 50  0001 C CNN
F 1 "+3.3V" H 3765 1473 50  0000 C CNN
F 2 "" H 3750 1300 50  0001 C CNN
F 3 "" H 3750 1300 50  0001 C CNN
	1    3750 1300
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR024
U 1 1 5C68C481
P 10200 2150
F 0 "#PWR024" H 10200 2000 50  0001 C CNN
F 1 "+3.3V" H 10215 2323 50  0000 C CNN
F 2 "" H 10200 2150 50  0001 C CNN
F 3 "" H 10200 2150 50  0001 C CNN
	1    10200 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	10200 2150 10200 2250
Connection ~ 10200 2250
Wire Wire Line
	2850 1750 2850 1900
$Comp
L conn:Conn_01x07 J2
U 1 1 5C6F40BD
P 5250 1550
F 0 "J2" H 5329 1592 50  0000 L CNN
F 1 "REMOTE" H 5329 1501 50  0000 L CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x07_Pitch2.54mm" H 5250 1550 50  0001 C CNN
F 3 "~" H 5250 1550 50  0001 C CNN
	1    5250 1550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 1550 5000 1850
Wire Wire Line
	5050 1850 5000 1850
Connection ~ 5000 1850
Wire Wire Line
	5000 1850 5000 2050
$Comp
L power:+5V #PWR010
U 1 1 5C6FA291
P 4500 1300
F 0 "#PWR010" H 4500 1150 50  0001 C CNN
F 1 "+5V" H 4515 1473 50  0000 C CNN
F 2 "" H 4500 1300 50  0001 C CNN
F 3 "" H 4500 1300 50  0001 C CNN
	1    4500 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4500 1300 4500 1650
Wire Wire Line
	4500 1650 5050 1650
Wire Wire Line
	5050 1750 4850 1750
Text GLabel 4850 1750 0    50   Input ~ 0
IR
Text GLabel 6000 3700 0    50   Input ~ 0
IR
Wire Wire Line
	4850 1250 5050 1250
Wire Wire Line
	5050 1350 5000 1350
Wire Wire Line
	5000 1350 5000 1550
Connection ~ 5000 1550
$Comp
L device:LED D2
U 1 1 5C703E52
P 1850 1250
F 0 "D2" V 1888 1133 50  0000 R CNN
F 1 "LED" V 1797 1133 50  0000 R CNN
F 2 "LEDs:LED_0603_HandSoldering" H 1850 1250 50  0001 C CNN
F 3 "" H 1850 1250 50  0001 C CNN
	1    1850 1250
	0    -1   -1   0   
$EndComp
Wire Wire Line
	1850 1100 1850 1050
Wire Wire Line
	1850 1050 1350 1050
Connection ~ 1350 1050
$Comp
L device:R R7
U 1 1 5C7077B8
P 1850 1650
F 0 "R7" H 1920 1696 50  0000 L CNN
F 1 "1K" H 1920 1605 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 1780 1650 50  0001 C CNN
F 3 "" H 1850 1650 50  0001 C CNN
	1    1850 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	1850 1500 1850 1400
Wire Wire Line
	1850 2200 1350 2200
Connection ~ 1350 2200
$Comp
L device:Jumper_NO_Small JP1
U 1 1 5C70F89C
P 1850 2000
F 0 "JP1" V 1804 2048 50  0000 L CNN
F 1 "Jumper_NO_Small" V 1895 2048 50  0000 L CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Bridged2Bar_Pad1.0x1.5mm" H 1850 2000 50  0001 C CNN
F 3 "" H 1850 2000 50  0001 C CNN
	1    1850 2000
	0    1    1    0   
$EndComp
Wire Wire Line
	1850 2100 1850 2200
Wire Wire Line
	1850 1900 1850 1800
$Comp
L device:D D3
U 1 1 5CA44E20
P 3100 4550
F 0 "D3" V 3054 4629 50  0000 L CNN
F 1 "D" V 3145 4629 50  0000 L CNN
F 2 "Diodes_SMD:D_0603" H 3100 4550 50  0001 C CNN
F 3 "" H 3100 4550 50  0001 C CNN
	1    3100 4550
	0    1    1    0   
$EndComp
Wire Wire Line
	3100 4700 3100 5200
Wire Wire Line
	3100 4400 3100 4350
Wire Wire Line
	3100 4350 3300 4350
Wire Wire Line
	6000 2800 6300 2800
Wire Wire Line
	4000 2700 4000 4850
Wire Wire Line
	4000 2700 6300 2700
$Comp
L power:+5V #PWR0102
U 1 1 5CDE9ACD
P 1100 4450
F 0 "#PWR0102" H 1100 4300 50  0001 C CNN
F 1 "+5V" H 1115 4623 50  0000 C CNN
F 2 "" H 1100 4450 50  0001 C CNN
F 3 "" H 1100 4450 50  0001 C CNN
	1    1100 4450
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 5CDE9B91
P 1200 4450
F 0 "#PWR0103" H 1200 4200 50  0001 C CNN
F 1 "GND" H 1205 4277 50  0000 C CNN
F 2 "" H 1200 4450 50  0001 C CNN
F 3 "" H 1200 4450 50  0001 C CNN
	1    1200 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	1200 4450 1200 4250
Wire Wire Line
	1100 4250 1100 4450
$Comp
L conn:Conn_01x02 J5
U 1 1 5CDF1F59
P 1100 4850
F 0 "J5" V 1066 4662 50  0000 R CNN
F 1 "Conn_01x02" V 975 4662 50  0000 R CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02_Pitch2.54mm" H 1100 4850 50  0001 C CNN
F 3 "~" H 1100 4850 50  0001 C CNN
	1    1100 4850
	0    -1   -1   0   
$EndComp
$Comp
L conn:Conn_01x02 J4
U 1 1 5CDF20BC
P 1100 4050
F 0 "J4" V 1066 3862 50  0000 R CNN
F 1 "Conn_01x02" V 975 3862 50  0000 R CNN
F 2 "Connectors_JST:JST_XH_B02B-XH-A_02x2.50mm_Straight" H 1100 4050 50  0001 C CNN
F 3 "~" H 1100 4050 50  0001 C CNN
	1    1100 4050
	0    -1   -1   0   
$EndComp
$Comp
L power:+5V #PWR026
U 1 1 5CDF21A0
P 1100 5250
F 0 "#PWR026" H 1100 5100 50  0001 C CNN
F 1 "+5V" H 1115 5423 50  0000 C CNN
F 2 "" H 1100 5250 50  0001 C CNN
F 3 "" H 1100 5250 50  0001 C CNN
	1    1100 5250
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR027
U 1 1 5CDF21A6
P 1200 5250
F 0 "#PWR027" H 1200 5000 50  0001 C CNN
F 1 "GND" H 1205 5077 50  0000 C CNN
F 2 "" H 1200 5250 50  0001 C CNN
F 3 "" H 1200 5250 50  0001 C CNN
	1    1200 5250
	1    0    0    -1  
$EndComp
Wire Wire Line
	1200 5250 1200 5050
Wire Wire Line
	1100 5050 1100 5250
$EndSCHEMATC
