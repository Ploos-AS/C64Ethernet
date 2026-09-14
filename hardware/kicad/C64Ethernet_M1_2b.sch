EESchema Schematic File Version 4
LIBS:C64Ethernet
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
Sheet 1 1
Title "C64Ethernet W5500 Reference Schematic"
Comment1 "M1.2b engineering schematic draft"
Comment2 "Commodore 64 User Port Ethernet adapter"
Comment3 "W5500 / 3.3V / RJ45 magnetics"
Comment4 "NOT RELEASED - ERC/PCB review required"
$EndDescr
Text Notes 800 900 0 100 ~ 20
C64 USER PORT INTERFACE
Text Notes 800 1150 0 60 ~ 12
PB0-PB7 and PA2 are the proposed 8-bit data/control interface. Exact transfer protocol is defined separately.
Text Notes 800 1450 0 100 ~ 20
POWER
Text Notes 800 1700 0 60 ~ 12
+5V from User Port -> protected input -> 3.3V regulator -> W5500 VDD domains
Text Notes 800 2200 0 100 ~ 20
W5500 HOST INTERFACE
Text Notes 800 2450 0 60 ~ 12
MOSI / MISO / SCLK / CS / RESET / INT are routed between controller interface and W5500.
Text Notes 800 3000 0 100 ~ 20
ETHERNET PHY
Text Notes 800 3250 0 60 ~ 12
W5500 MDI differential pairs -> Ethernet magnetics / MagJack -> RJ45.
Text Notes 800 3900 0 80 ~ 16
Design requirements:
Text Notes 1000 4150 0 60 ~ 12
- Follow WIZnet W5500 reference schematic for crystal, decoupling, PHY bias and magnetics.
Text Notes 1000 4350 0 60 ~ 12
- Keep Ethernet differential routing away from User Port and switching power circuitry.
Text Notes 1000 4550 0 60 ~ 12
- Provide ESD protection at the external RJ45 boundary.
Text Notes 1000 4750 0 60 ~ 12
- Do not mark ERC/DRC PASS until the native KiCad design is reviewed on the target KiCad version.
Text Notes 800 5300 0 100 ~ 20
M1.2b STATUS
Text Notes 1000 5550 0 60 ~ 12
Reference topology captured. Native symbol-level implementation and ERC remain required before M1.2 completion.
$EndSCHEMATC
