EESchema Schematic File Version 4
LIBS:killswitch-pi3-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "KillSwitch for Pi 3"
Date "2019-06-14"
Rev "0.1.49"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L device:C C7
U 1 1 5B892C60
P 8000 4450
F 0 "C7" H 8025 4550 50  0000 L CNN
F 1 "10nF" H 8025 4350 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 8038 4300 50  0001 C CNN
F 3 "" H 8000 4450 50  0001 C CNN
	1    8000 4450
	1    0    0    -1  
$EndComp
$Comp
L opto:TSDP341xx U1
U 1 1 5B892CCF
P 1650 5700
F 0 "U1" H 1250 6000 50  0000 L CNN
F 1 "TSDP341xx" H 1250 5400 50  0000 L CNN
F 2 "Opto-Devices:IRReceiver_Vishay_MOLD-3pin" H 1600 5325 50  0001 C CNN
F 3 "" H 2300 6000 50  0001 C CNN
	1    1650 5700
	0    -1   -1   0   
$EndComp
$Comp
L device:C C6
U 1 1 5B892D2F
P 5100 5650
F 0 "C6" H 5125 5750 50  0000 L CNN
F 1 "10nF" H 5125 5550 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 5138 5500 50  0001 C CNN
F 3 "" H 5100 5650 50  0001 C CNN
	1    5100 5650
	1    0    0    -1  
$EndComp
$Comp
L device:R R6
U 1 1 5B892DD1
P 5100 5150
F 0 "R6" V 5180 5150 50  0000 C CNN
F 1 "4.7K" V 5100 5150 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 5030 5150 50  0001 C CNN
F 3 "" H 5100 5150 50  0001 C CNN
	1    5100 5150
	1    0    0    -1  
$EndComp
$Comp
L device:R R1
U 1 1 5B892DFC
P 1100 5050
F 0 "R1" V 1180 5050 50  0000 C CNN
F 1 "100" V 1100 5050 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 1030 5050 50  0001 C CNN
F 3 "" H 1100 5050 50  0001 C CNN
	1    1100 5050
	1    0    0    -1  
$EndComp
$Comp
L device:R R5
U 1 1 5B892E2B
P 4250 5500
F 0 "R5" V 4330 5500 50  0000 C CNN
F 1 "333" V 4250 5500 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 4180 5500 50  0001 C CNN
F 3 "" H 4250 5500 50  0001 C CNN
	1    4250 5500
	1    0    0    -1  
$EndComp
$Comp
L device:LED D3
U 1 1 5B892E70
P 4250 4850
F 0 "D3" H 4250 4950 50  0000 C CNN
F 1 "LED_STATUS" H 4250 4700 50  0000 C CNN
F 2 "LEDs:LED_0603_HandSoldering" H 4250 4850 50  0001 C CNN
F 3 "" H 4250 4850 50  0001 C CNN
	1    4250 4850
	0    -1   -1   0   
$EndComp
$Comp
L switches:SW_Push SW1
U 1 1 5B892EE0
P 4700 4850
F 0 "SW1" H 4750 4950 50  0000 L CNN
F 1 "SW_Push" H 4700 4790 50  0000 C CNN
F 2 "Buttons_Switches_SMD:SW_SPST_PTS645" H 4700 5050 50  0001 C CNN
F 3 "" H 4700 5050 50  0001 C CNN
	1    4700 4850
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR013
U 1 1 5B893057
P 5100 6400
F 0 "#PWR013" H 5100 6150 50  0001 C CNN
F 1 "GND" H 5100 6250 50  0000 C CNN
F 2 "" H 5100 6400 50  0001 C CNN
F 3 "" H 5100 6400 50  0001 C CNN
	1    5100 6400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5B89327D
P 1100 6400
F 0 "#PWR02" H 1100 6150 50  0001 C CNN
F 1 "GND" H 1100 6250 50  0000 C CNN
F 2 "" H 1100 6400 50  0001 C CNN
F 3 "" H 1100 6400 50  0001 C CNN
	1    1100 6400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR011
U 1 1 5B893627
P 4250 6400
F 0 "#PWR011" H 4250 6150 50  0001 C CNN
F 1 "GND" H 4250 6250 50  0000 C CNN
F 2 "" H 4250 6400 50  0001 C CNN
F 3 "" H 4250 6400 50  0001 C CNN
	1    4250 6400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 5B893659
P 4700 6400
F 0 "#PWR09" H 4700 6150 50  0001 C CNN
F 1 "GND" H 4700 6250 50  0000 C CNN
F 2 "" H 4700 6400 50  0001 C CNN
F 3 "" H 4700 6400 50  0001 C CNN
	1    4700 6400
	1    0    0    -1  
$EndComp
Text GLabel 5800 3450 0    60   Input ~ 0
TR
Text GLabel 5800 3650 0    60   Input ~ 0
FB
Text GLabel 5800 4350 0    60   Input ~ 0
MOSI
Text GLabel 5750 5050 0    60   Input ~ 0
RST
Wire Wire Line
	1100 5200 1100 5250
Connection ~ 1100 5250
Wire Wire Line
	4250 5000 4250 5350
Wire Wire Line
	4250 5650 4250 6400
Text GLabel 5800 4250 0    60   Input ~ 0
TX
Text GLabel 5800 4050 0    60   Input ~ 0
RX
$Comp
L device:CP C2
U 1 1 5B893E32
P 1850 1900
F 0 "C2" H 1875 2000 50  0000 L CNN
F 1 "10uF" H 1875 1800 50  0000 L CNN
F 2 "Capacitors_SMD:CP_Elec_3x5.3" H 1888 1750 50  0001 C CNN
F 3 "" H 1850 1900 50  0001 C CNN
	1    1850 1900
	1    0    0    -1  
$EndComp
Text GLabel 8900 1350 0    60   Input ~ 0
FB
Text GLabel 8900 1450 0    60   Input ~ 0
TR
$Comp
L power:GND #PWR018
U 1 1 5B8946FF
P 9100 2400
F 0 "#PWR018" H 9100 2150 50  0001 C CNN
F 1 "GND" H 9100 2250 50  0000 C CNN
F 2 "" H 9100 2400 50  0001 C CNN
F 3 "" H 9100 2400 50  0001 C CNN
	1    9100 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR019
U 1 1 5B89472D
P 9850 2400
F 0 "#PWR019" H 9850 2150 50  0001 C CNN
F 1 "GND" H 9850 2250 50  0000 C CNN
F 2 "" H 9850 2400 50  0001 C CNN
F 3 "" H 9850 2400 50  0001 C CNN
	1    9850 2400
	1    0    0    -1  
$EndComp
Text GLabel 10000 1650 2    60   Input ~ 0
TX
Text GLabel 10000 1550 2    60   Input ~ 0
RX
Wire Wire Line
	9100 1650 9200 1650
Wire Wire Line
	9700 1450 9850 1450
$Comp
L device:CP C1
U 1 1 5B894EA4
P 1100 5500
F 0 "C1" H 1125 5600 50  0000 L CNN
F 1 "100uf" H 1125 5400 50  0000 L CNN
F 2 "Capacitors_SMD:CP_Elec_3x5.3" H 1138 5350 50  0001 C CNN
F 3 "" H 1100 5500 50  0001 C CNN
	1    1100 5500
	1    0    0    -1  
$EndComp
Text GLabel 8900 1750 0    60   Input ~ 0
MOSI
Text GLabel 10000 1750 2    60   Input ~ 0
MISO
Text GLabel 5800 4450 0    60   Input ~ 0
MISO
Text GLabel 5800 4850 0    60   Input ~ 0
SCK
Text GLabel 8900 1850 0    60   Input ~ 0
SCK
Text GLabel 8900 1550 0    60   Input ~ 0
RST
Wire Wire Line
	4700 5050 4700 6400
Wire Wire Line
	8900 1450 9200 1450
Wire Wire Line
	1100 5650 1100 6400
$Comp
L power:GND #PWR05
U 1 1 5B8A8F80
P 2250 6400
F 0 "#PWR05" H 2250 6150 50  0001 C CNN
F 1 "GND" H 2250 6250 50  0000 C CNN
F 2 "" H 2250 6400 50  0001 C CNN
F 3 "" H 2250 6400 50  0001 C CNN
	1    2250 6400
	1    0    0    -1  
$EndComp
Wire Wire Line
	1850 5300 2250 5300
Wire Wire Line
	2250 5300 2250 6400
Wire Wire Line
	1100 5250 1450 5250
Wire Wire Line
	1450 5250 1450 5300
Wire Wire Line
	1100 5250 1100 5350
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
L power:+5V #PWR03
U 1 1 5C057F09
P 1850 1050
F 0 "#PWR03" H 1850 900 50  0001 C CNN
F 1 "+5V" H 1865 1223 50  0000 C CNN
F 2 "" H 1850 1050 50  0001 C CNN
F 3 "" H 1850 1050 50  0001 C CNN
	1    1850 1050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR04
U 1 1 5C059198
P 1850 2400
F 0 "#PWR04" H 1850 2150 50  0001 C CNN
F 1 "GND" H 1855 2227 50  0000 C CNN
F 2 "" H 1850 2400 50  0001 C CNN
F 3 "" H 1850 2400 50  0001 C CNN
	1    1850 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	950  2200 1050 2200
Connection ~ 1050 2200
Wire Wire Line
	9700 1250 9700 1350
NoConn ~ 1350 1800
NoConn ~ 1350 1900
NoConn ~ 9200 1250
Wire Wire Line
	1350 2000 1350 2200
Wire Wire Line
	1350 2200 1050 2200
$Comp
L power:+5V #PWR06
U 1 1 5C06F21D
P 3150 4900
F 0 "#PWR06" H 3150 4750 50  0001 C CNN
F 1 "+5V" H 3165 5073 50  0000 C CNN
F 2 "" H 3150 4900 50  0001 C CNN
F 3 "" H 3150 4900 50  0001 C CNN
	1    3150 4900
	1    0    0    -1  
$EndComp
$Comp
L device:Polyfuse F1
U 1 1 5C075F00
P 1550 1600
F 0 "F1" H 1462 1554 50  0000 R CNN
F 1 "1A" H 1462 1645 50  0000 R CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 1600 1400 50  0001 L CNN
F 3 "" H 1550 1600 50  0001 C CNN
	1    1550 1600
	0    -1   -1   0   
$EndComp
$Comp
L device:Q_PMOS_GSD Q1
U 1 1 5C05D7DF
P 3250 5600
F 0 "Q1" H 3456 5646 50  0000 L CNN
F 1 "Q_PMOS_GSD" H 3456 5555 50  0000 L CNN
F 2 "TO_SOT_Packages_SMD:SOT-323_SC-70_Handsoldering" H 3450 5700 50  0001 C CNN
F 3 "" H 3250 5600 50  0001 C CNN
	1    3250 5600
	-1   0    0    1   
$EndComp
Text GLabel 10000 1250 2    50   Input ~ 0
VOUT
Wire Wire Line
	10000 1250 9700 1250
Text GLabel 2900 6500 0    50   Input ~ 0
VOUT
Wire Wire Line
	2950 5950 3150 5950
Wire Wire Line
	3150 5950 3150 5800
Text GLabel 5800 3950 0    50   Input ~ 0
BTN
Text GLabel 5800 3850 0    50   Input ~ 0
LED
Text GLabel 7150 1200 0    50   Input ~ 0
BTN
Text GLabel 7150 1400 0    50   Input ~ 0
LED
Wire Wire Line
	7350 1400 7150 1400
$Comp
L power:GND #PWR015
U 1 1 5C0C0F0C
P 7300 2400
F 0 "#PWR015" H 7300 2150 50  0001 C CNN
F 1 "GND" H 7305 2227 50  0000 C CNN
F 2 "" H 7300 2400 50  0001 C CNN
F 3 "" H 7300 2400 50  0001 C CNN
	1    7300 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 1500 7300 1500
Connection ~ 9700 1250
Wire Wire Line
	9850 1450 9850 1850
Wire Wire Line
	9700 1650 10000 1650
Wire Wire Line
	3150 4900 3150 5100
$Comp
L device:R R3
U 1 1 5C5E8AF0
P 3450 5250
F 0 "R3" V 3550 5200 50  0000 L CNN
F 1 "50K" V 3450 5200 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 3380 5250 50  0001 C CNN
F 3 "" H 3450 5250 50  0001 C CNN
	1    3450 5250
	1    0    0    -1  
$EndComp
$Comp
L device:R R4
U 1 1 5C5E8B9C
P 3650 5600
F 0 "R4" V 3550 5550 50  0000 C CNN
F 1 "1K" V 3650 5600 50  0000 C CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 3580 5600 50  0001 C CNN
F 3 "" H 3650 5600 50  0001 C CNN
	1    3650 5600
	0    1    1    0   
$EndComp
Wire Wire Line
	3800 5600 3850 5600
Wire Wire Line
	3450 5600 3500 5600
Wire Wire Line
	3450 5100 3150 5100
Connection ~ 3150 5100
Wire Wire Line
	3150 5100 3150 5400
Wire Wire Line
	3450 5400 3450 5600
Connection ~ 3450 5600
$Comp
L conn:Conn_02x07_Odd_Even J3
U 1 1 5C5F3F28
P 9400 1550
F 0 "J3" H 9450 2067 50  0000 C CNN
F 1 "PI" H 9450 1976 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_2x07_Pitch2.54mm" H 9400 1550 50  0001 C CNN
F 3 "~" H 9400 1550 50  0001 C CNN
	1    9400 1550
	1    0    0    -1  
$EndComp
Wire Wire Line
	8900 1350 9200 1350
Wire Wire Line
	8900 1550 9200 1550
Wire Wire Line
	8900 1750 9200 1750
Wire Wire Line
	8900 1850 9200 1850
Wire Wire Line
	10000 1750 9700 1750
Wire Wire Line
	9700 1550 10000 1550
Wire Wire Line
	9700 1850 9850 1850
Connection ~ 9850 1850
$Comp
L regul:AZ1117-3.3 U2
U 1 1 5C66B62E
P 3800 1450
F 0 "U2" H 3800 1692 50  0000 C CNN
F 1 "AZ1117-3.3" H 3800 1601 50  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-89-3_Handsoldering" H 3800 1700 50  0001 C CIN
F 3 "https://www.diodes.com/assets/Datasheets/AZ1117.pdf" H 3800 1450 50  0001 C CNN
	1    3800 1450
	1    0    0    -1  
$EndComp
$Comp
L device:C C3
U 1 1 5C66B6B4
P 3250 1600
F 0 "C3" H 3365 1646 50  0000 L CNN
F 1 "10uF" H 3365 1555 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 3288 1450 50  0001 C CNN
F 3 "" H 3250 1600 50  0001 C CNN
	1    3250 1600
	1    0    0    -1  
$EndComp
$Comp
L device:C C4
U 1 1 5C66B734
P 4250 1600
F 0 "C4" H 4365 1646 50  0000 L CNN
F 1 "22uF" H 4365 1555 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 4288 1450 50  0001 C CNN
F 3 "" H 4250 1600 50  0001 C CNN
	1    4250 1600
	1    0    0    -1  
$EndComp
$Comp
L device:C C5
U 1 1 5C67014F
P 4700 1600
F 0 "C5" H 4815 1646 50  0000 L CNN
F 1 "0.1uF" H 4815 1555 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603_HandSoldering" H 4738 1450 50  0001 C CNN
F 3 "" H 4700 1600 50  0001 C CNN
	1    4700 1600
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 1750 3800 1750
Wire Wire Line
	3800 1750 4250 1750
Connection ~ 3800 1750
Wire Wire Line
	4700 1750 4250 1750
Connection ~ 4250 1750
Wire Wire Line
	4100 1450 4250 1450
Wire Wire Line
	4250 1450 4700 1450
Connection ~ 4250 1450
Wire Wire Line
	3500 1450 3250 1450
Connection ~ 3250 1450
Connection ~ 4700 1450
$Comp
L power:GND #PWR08
U 1 1 5C685CA1
P 3800 2400
F 0 "#PWR08" H 3800 2150 50  0001 C CNN
F 1 "GND" H 3805 2227 50  0000 C CNN
F 2 "" H 3800 2400 50  0001 C CNN
F 3 "" H 3800 2400 50  0001 C CNN
	1    3800 2400
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR010
U 1 1 5C685DC7
P 4700 1050
F 0 "#PWR010" H 4700 900 50  0001 C CNN
F 1 "+3.3V" H 4715 1223 50  0000 C CNN
F 2 "" H 4700 1050 50  0001 C CNN
F 3 "" H 4700 1050 50  0001 C CNN
	1    4700 1050
	1    0    0    -1  
$EndComp
$Comp
L conn:Conn_01x07 J2
U 1 1 5C6F40BD
P 7550 1500
F 0 "J2" H 7550 2050 50  0000 L CNN
F 1 "REMOTE" H 7500 1950 50  0000 L CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x07_Pitch2.54mm" H 7550 1500 50  0001 C CNN
F 3 "~" H 7550 1500 50  0001 C CNN
	1    7550 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7300 1500 7300 1800
Wire Wire Line
	7350 1800 7300 1800
Connection ~ 7300 1800
Wire Wire Line
	7350 1700 7150 1700
Text GLabel 7150 1700 0    50   Input ~ 0
IR
Text GLabel 5800 3550 0    50   Input ~ 0
IR
Wire Wire Line
	7150 1200 7350 1200
Wire Wire Line
	7350 1300 7300 1300
Wire Wire Line
	7300 1300 7300 1500
Connection ~ 7300 1500
$Comp
L device:LED D1
U 1 1 5C703E52
P 2250 1350
F 0 "D1" V 2288 1233 50  0000 R CNN
F 1 "LED_PWR_IN" V 2197 1233 50  0000 R CNN
F 2 "LEDs:LED_0603_HandSoldering" H 2250 1350 50  0001 C CNN
F 3 "" H 2250 1350 50  0001 C CNN
	1    2250 1350
	0    -1   -1   0   
$EndComp
$Comp
L device:R R2
U 1 1 5C7077B8
P 2250 1750
F 0 "R2" H 2320 1796 50  0000 L CNN
F 1 "1K" H 2320 1705 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" V 2180 1750 50  0001 C CNN
F 3 "" H 2250 1750 50  0001 C CNN
	1    2250 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2250 1600 2250 1500
Wire Wire Line
	2250 2000 2250 1900
$Comp
L device:D D2
U 1 1 5CA44E20
P 2950 5300
F 0 "D2" V 2904 5379 50  0000 L CNN
F 1 "PWR_ICSP" V 2995 5379 50  0000 L CNN
F 2 "Diodes_SMD:D_0603" H 2950 5300 50  0001 C CNN
F 3 "" H 2950 5300 50  0001 C CNN
	1    2950 5300
	0    1    1    0   
$EndComp
Wire Wire Line
	2950 5450 2950 5950
Wire Wire Line
	2950 5150 2950 5100
Wire Wire Line
	2950 5100 3150 5100
Wire Wire Line
	3250 1050 3250 1450
$Comp
L power:+3.3V #PWR012
U 1 1 5DAF34B5
P 5100 4900
F 0 "#PWR012" H 5100 4750 50  0001 C CNN
F 1 "+3.3V" H 5115 5073 50  0000 C CNN
F 2 "" H 5100 4900 50  0001 C CNN
F 3 "" H 5100 4900 50  0001 C CNN
	1    5100 4900
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR01
U 1 1 5DAF3F4B
P 1100 4900
F 0 "#PWR01" H 1100 4750 50  0001 C CNN
F 1 "+3.3V" H 1115 5073 50  0000 C CNN
F 2 "" H 1100 4900 50  0001 C CNN
F 3 "" H 1100 4900 50  0001 C CNN
	1    1100 4900
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR016
U 1 1 5DAF45EB
P 8000 3100
F 0 "#PWR016" H 8000 2950 50  0001 C CNN
F 1 "+3.3V" H 8015 3273 50  0000 C CNN
F 2 "" H 8000 3100 50  0001 C CNN
F 3 "" H 8000 3100 50  0001 C CNN
	1    8000 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR017
U 1 1 5DAF476B
P 8000 5950
F 0 "#PWR017" H 8000 5700 50  0001 C CNN
F 1 "GND" H 8005 5777 50  0000 C CNN
F 2 "" H 8000 5950 50  0001 C CNN
F 3 "" H 8000 5950 50  0001 C CNN
	1    8000 5950
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR07
U 1 1 5DAD8E06
P 3250 1050
F 0 "#PWR07" H 3250 900 50  0001 C CNN
F 1 "+5V" H 3265 1223 50  0000 C CNN
F 2 "" H 3250 1050 50  0001 C CNN
F 3 "" H 3250 1050 50  0001 C CNN
	1    3250 1050
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5DAE0FDD
P 2250 1050
F 0 "#FLG01" H 2250 1125 50  0001 C CNN
F 1 "PWR_FLAG" H 2250 1224 50  0000 C CNN
F 2 "" H 2250 1050 50  0001 C CNN
F 3 "" H 2250 1050 50  0001 C CNN
	1    2250 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 1050 4700 1450
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5DAE75D6
P 2250 2400
F 0 "#FLG02" H 2250 2475 50  0001 C CNN
F 1 "PWR_FLAG" H 2250 2573 50  0000 C CNN
F 2 "" H 2250 2400 50  0001 C CNN
F 3 "" H 2250 2400 50  0001 C CNN
	1    2250 2400
	-1   0    0    1   
$EndComp
Wire Wire Line
	5800 3450 6100 3450
Wire Wire Line
	5800 3650 6100 3650
Wire Wire Line
	5800 4050 6100 4050
$Comp
L atmel:ATTINY1634-SU U3
U 1 1 5DB37219
P 7050 4400
F 0 "U3" H 7050 5717 50  0000 C CNN
F 1 "ATTINY1634-SU" H 7050 5626 50  0000 C CNN
F 2 "Housings_SOIC:SOIC-20W_7.5x12.8mm_Pitch1.27mm" H 7050 4650 50  0001 C CIN
F 3 "http://www.atmel.com/Images/Atmel-8303-8-bit-AVR-Microcontroller-tinyAVR-ATtiny1634_Datasheet.pdf" H 7050 4850 50  0001 C CNN
	1    7050 4400
	-1   0    0    -1  
$EndComp
Wire Wire Line
	8000 5250 8000 5950
Wire Wire Line
	8000 3100 8000 3350
Wire Wire Line
	8000 3350 8000 4300
Connection ~ 8000 3350
Wire Wire Line
	8000 4600 8000 5250
Connection ~ 8000 5250
Wire Wire Line
	5750 5050 5950 5050
Wire Wire Line
	5950 5450 5950 5050
Connection ~ 5950 5050
Wire Wire Line
	5950 5050 6100 5050
Wire Wire Line
	5800 4250 6100 4250
Wire Wire Line
	5800 4850 6100 4850
Wire Wire Line
	5800 4450 6100 4450
Wire Wire Line
	5800 4350 6100 4350
Wire Wire Line
	5100 4900 5100 5000
Wire Wire Line
	5100 5800 5100 6400
Wire Wire Line
	5100 5450 5950 5450
Wire Wire Line
	5100 5300 5100 5450
Connection ~ 5100 5450
Wire Wire Line
	5100 5450 5100 5500
Wire Wire Line
	4700 3950 6100 3950
Wire Wire Line
	4250 3850 6100 3850
Wire Wire Line
	3850 3750 6100 3750
Wire Wire Line
	3850 3750 3850 5600
Wire Wire Line
	1650 3550 1650 5300
Wire Wire Line
	1650 3550 6100 3550
NoConn ~ 6100 3350
NoConn ~ 6100 4550
NoConn ~ 6100 4750
NoConn ~ 6100 4950
NoConn ~ 6100 5150
NoConn ~ 6100 5250
$Comp
L device:Jumper_NC_Small JP1
U 1 1 5DB87A75
P 2250 2100
F 0 "JP1" V 2204 2174 50  0000 L CNN
F 1 "JPR_PWR_IN" V 2300 2200 50  0000 L CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Bridged_Pad1.0x1.5mm" H 2250 2100 50  0001 C CNN
F 3 "" H 2250 2100 50  0001 C CNN
	1    2250 2100
	0    1    1    0   
$EndComp
Wire Wire Line
	1700 1600 1850 1600
Wire Wire Line
	1850 1600 1850 1750
Wire Wire Line
	1850 2200 1850 2050
Connection ~ 1350 2200
Wire Wire Line
	1850 1050 1850 1150
Connection ~ 1850 1600
Wire Wire Line
	1350 2200 1850 2200
Wire Wire Line
	1850 2400 1850 2200
Connection ~ 1850 2200
Wire Wire Line
	1350 1600 1400 1600
Wire Wire Line
	2250 1150 1850 1150
Connection ~ 2250 1150
Wire Wire Line
	2250 1150 2250 1200
Connection ~ 1850 1150
Wire Wire Line
	1850 1150 1850 1600
Wire Wire Line
	2250 2200 1850 2200
Wire Wire Line
	2250 1050 2250 1150
Wire Wire Line
	2250 2400 2250 2200
Connection ~ 2250 2200
Wire Wire Line
	3800 1750 3800 2400
Wire Notes Line
	800  800  2950 800 
Wire Notes Line
	2950 800  2950 2700
Wire Notes Line
	2950 2700 800  2700
Wire Notes Line
	800  2700 800  800 
Wire Notes Line
	3100 800  5050 800 
Wire Notes Line
	5050 800  5050 2700
Wire Notes Line
	5050 2700 3100 2700
Wire Notes Line
	3100 2700 3100 800 
Wire Notes Line
	6600 800  8000 800 
Wire Notes Line
	8000 800  8000 2700
Wire Notes Line
	8000 2700 6600 2700
Wire Notes Line
	6600 2700 6600 800 
Wire Wire Line
	7300 1800 7300 2400
Wire Notes Line
	8450 800  10400 800 
Wire Notes Line
	10400 800  10400 2700
Wire Notes Line
	10400 2700 8450 2700
Wire Notes Line
	8450 2700 8450 800 
Wire Wire Line
	9100 1650 9100 2400
Wire Wire Line
	9850 1850 9850 2400
Wire Wire Line
	2950 5950 2950 6500
Wire Wire Line
	2950 6500 2900 6500
Connection ~ 2950 5950
Wire Notes Line
	8450 2850 5600 2850
Wire Notes Line
	5600 2850 5600 6200
Wire Notes Line
	5600 6200 8450 6200
Wire Notes Line
	8450 6200 8450 2900
Text GLabel 7150 1600 0    50   Input ~ 0
IR+
Wire Wire Line
	7150 1600 7350 1600
Text GLabel 850  5250 0    50   Input ~ 0
IR+
Wire Wire Line
	850  5250 1100 5250
Wire Wire Line
	4700 3950 4700 4650
Wire Wire Line
	4250 3850 4250 4700
$EndSCHEMATC
