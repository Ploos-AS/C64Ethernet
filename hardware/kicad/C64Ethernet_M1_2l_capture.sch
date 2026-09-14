EESchema Schematic File Version 4
LIBS:C64Ethernet-cache
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
Sheet 1 1
Title "C64Ethernet - User Port Ethernet Adapter"
Comment1 "M1.2l symbol capture source"
Comment2 "C64 User Port -> LC4032V CPLD -> W5500 -> Ethernet"
Comment3 "Engineering baseline; ERC pending"
$EndDescr
Text Notes 900 900 0 100 ~ 20
C64Ethernet M1.2l - symbol capture source
Text Notes 900 1150 0 60 ~ 12
C64 User Port: PB0..PB7 bidirectional, PA2 HOST_STROBE, FLAG2 DEVICE_IRQ
Text Notes 900 1300 0 60 ~ 12
Controller: LC4032V-5TN48C | Ethernet: W5500 | Supply: +5V User Port -> protected +3V3
Text Notes 900 1450 0 60 ~ 12
This source captures the intended component/net topology before native KiCad symbol embedding and ERC.
$Comp
L Connector_Generic:Conn_02x12_Odd_Even J1
U 1 1 1
P 1800 3000
F 0 "J1" H 1850 3717 50 0000 C CNN
F 1 "C64_USERPORT" H 1850 3626 50 0000 C CNN
	1    1800 3000
	1 0 0 -1
$EndComp
$Comp
L CPLD_Lattice:LC4032V-5TN48C U1
U 1 1 2
P 5000 3300
F 0 "U1" H 5000 4767 50 0000 C CNN
F 1 "LC4032V-5TN48C" H 5000 4676 50 0000 C CNN
	1    5000 3300
	1 0 0 -1
$EndComp
$Comp
L Interface_Ethernet:W5500 U2
U 1 1 3
P 7900 3300
F 0 "U2" H 7900 4781 50 0000 C CNN
F 1 "W5500" H 7900 4690 50 0000 C CNN
	1    7900 3300
	1 0 0 -1
$EndComp
$Comp
L Connector:RJ45_Magnetics J2
U 1 1 4
P 10100 3300
F 0 "J2" H 10158 3967 50 0000 C CNN
F 1 "RJ45_MAGJACK" H 10158 3876 50 0000 C CNN
	1    10100 3300
	1 0 0 -1
$EndComp
$Comp
L Device:R R1
U 1 1 5
P 6900 5100
F 0 "R1" H 6970 5146 50 0000 L CNN
F 1 "12.4k 1%" H 6970 5055 50 0000 L CNN
	1    6900 5100
	1 0 0 -1
$EndComp
$Comp
L Device:Crystal Y1
U 1 1 6
P 6900 5600
F 0 "Y1" V 6854 5731 50 0000 L CNN
F 1 "25MHz" V 6945 5731 50 0000 L CNN
	1    6900 5600
	0 1 1 0
$EndComp
$Comp
L Regulator_Linear:AMS1117-3.3 U3
U 1 1 7
P 5000 5600
F 0 "U3" H 5000 5842 50 0000 C CNN
F 1 "3V3_REGULATOR" H 5000 5751 50 0000 C CNN
	1    5000 5600
	1 0 0 -1
$EndComp
Text Label 2500 2600 0 50 ~ 0
PB0
Text Label 2500 2700 0 50 ~ 0
PB1
Text Label 2500 2800 0 50 ~ 0
PB2
Text Label 2500 2900 0 50 ~ 0
PB3
Text Label 2500 3000 0 50 ~ 0
PB4
Text Label 2500 3100 0 50 ~ 0
PB5
Text Label 2500 3200 0 50 ~ 0
PB6
Text Label 2500 3300 0 50 ~ 0
PB7
Text Label 2500 3400 0 50 ~ 0
PA2_HOST_STROBE
Text Label 2500 3500 0 50 ~ 0
FLAG2_DEVICE_IRQ
Text Label 2500 3600 0 50 ~ 0
RESET
Text Label 6200 2600 0 50 ~ 0
W5500_SCLK
Text Label 6200 2700 0 50 ~ 0
W5500_MOSI
Text Label 6200 2800 0 50 ~ 0
W5500_MISO
Text Label 6200 2900 0 50 ~ 0
W5500_SCSN
Text Label 6200 3000 0 50 ~ 0
W5500_INTN
Text Label 6200 3100 0 50 ~ 0
W5500_RSTN
Text Label 8600 2600 0 50 ~ 0
ETH_TXP
Text Label 8600 2700 0 50 ~ 0
ETH_TXN
Text Label 8600 2800 0 50 ~ 0
ETH_RXP
Text Label 8600 2900 0 50 ~ 0
ETH_RXN
Text Notes 1500 4050 0 55 ~ 11
Pins 10/11 (9 VAC) intentionally NC. Pins 4-9 unused in Rev A.
Text Notes 4400 6100 0 55 ~ 11
3V3 rail powers CPLD + W5500. Decoupling and protection to be added in native capture.
Text Notes 6500 6100 0 55 ~ 11
W5500 EXRES1=12.4k 1%; 25MHz reference clock; exact reference network pending native capture.
$EndSCHEMATC
