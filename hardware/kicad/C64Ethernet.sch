EESchema Schematic File Version 4
LIBS:C64Ethernet-cache
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
Sheet 1 1
Title "C64Ethernet - User Port W5500 Ethernet"
Date "2026-09-15"
Rev "M1.2a"
Comp "Ploos-AS"
Comment1 "Engineering schematic draft - User Port to W5500"
Comment2 "5V User Port input, regulated 3.3V controller domain"
Comment3 "Pin allocation follows documented C64 User Port"
Comment4 "ERC/DRC and exact footprints are pending review"
$EndDescr
Text Notes 900 900 0 100 ~ 20
C64 USER PORT
Text Notes 900 1200 0 60 ~ 12
1 GND / 2 +5V / 3 RESET / B FLAG2 / C-L PB0..PB7 / M PA2 / N GND
Text Notes 900 1550 0 60 ~ 12
PB0..PB7 are reserved as the parallel transport data bus. Control/status signals are allocated in the transport specification.
Text Notes 900 1950 0 100 ~ 20
POWER
Text Notes 900 2250 0 60 ~ 12
User Port +5V is the board input. Do not draw more than the documented User Port current budget.
Text Notes 900 2450 0 60 ~ 12
Generate regulated +3V3 for W5500 and interface logic. Final regulator and protection values are selected after current-budget review.
Text Notes 900 2850 0 100 ~ 20
W5500
Text Notes 900 3150 0 60 ~ 12
SPI: SCLK / MOSI / MISO / CS. Control: RESETn / INTn. Ethernet PHY connects to magnetics/RJ45 per vendor reference design.
Text Notes 900 3450 0 60 ~ 12
Use level/interface protection between 5V C64-side signals and 3V3 W5500-side logic as required by the final transport implementation.
Text Notes 900 3850 0 100 ~ 20
ETHERNET
Text Notes 900 4150 0 60 ~ 12
W5500 differential TX/RX pairs -> Ethernet magnetics -> RJ45. Keep the analog section short and isolated from noisy digital routing.
Text Notes 900 4350 0 60 ~ 12
Place low-capacitance ESD protection at the external RJ45 boundary.
Text Notes 900 4750 0 100 ~ 20
M1.2 EXIT CHECKLIST
Text Notes 900 5050 0 60 ~ 12
[ ] Verify User Port allocation against authoritative C64 documentation
Text Notes 900 5250 0 60 ~ 12
[ ] Freeze controller transport and control-signal allocation
Text Notes 900 5450 0 60 ~ 12
[ ] Select W5500 reference circuit and exact magnetics
Text Notes 900 5650 0 60 ~ 12
[ ] Select 3V3 regulator and protection components
Text Notes 900 5850 0 60 ~ 12
[ ] Convert this engineering draft into native KiCad 8/9 schematic and run ERC
Text Notes 900 6050 0 60 ~ 12
[ ] PCB placement, routing and DRC
$EndSCHEMATC
