# M1.2l — CPLD physical pin assignment

## Reference device

Lattice **LC4032V-5TN48C**, 48-pin TQFP, 32 macrocells / 32 user I/O. The package pinout below follows the ispMACH 4000V 48-pin TQFP device table. The device operates from 3.3 V; W5500 also uses a 3.3 V supply domain and accepts 5 V input levels on its digital inputs.

## Physical assignment

| Package pin | CPLD pad | C64Ethernet signal | Direction | Notes |
|---:|---|---|---|---|
| 2 | A5 | DATA0 / PB0 | bidirectional | C64 User Port |
| 3 | A6 | DATA1 / PB1 | bidirectional | C64 User Port |
| 4 | A7 | DATA2 / PB2 | bidirectional | C64 User Port |
| 7 | A8 | DATA3 / PB3 | bidirectional | C64 User Port |
| 8 | A9 | DATA4 / PB4 | bidirectional | C64 User Port |
| 9 | A10 | DATA5 / PB5 | bidirectional | C64 User Port |
| 10 | A11 | DATA6 / PB6 | bidirectional | C64 User Port |
| 13 | A12 | DATA7 / PB7 | bidirectional | C64 User Port |
| 14 | A13 | HOST_STROBE / PA2 | input | C64 → CPLD |
| 15 | A14 | DEVICE_IRQ / FLAG2 | output | CPLD → C64 |
| 16 | A15 | CPLD_RESET_N | input | local reset supervisor / C64 reset |
| 19 | B1 | W5500_SCLK | output | SPI clock |
| 20 | B2 | W5500_MOSI | output | SPI MOSI |
| 21 | B3 | W5500_MISO | input | SPI MISO |
| 22 | B4 | W5500_SCSN | output | SPI chip select, active low |
| 24 | B5 | W5500_INTN | input | W5500 interrupt, active low |
| 28 | B7 | W5500_RSTN | output | W5500 reset, active low |

## Reserved / required pins

| Package pin | Function | Handling |
|---:|---|---|
| 1 | TDI | JTAG/programming header |
| 11 | TCK | JTAG/programming header |
| 25 | TMS | JTAG/programming header |
| 35 | TDO | JTAG/programming header |
| 5, 12, 29, 37 | GND | common ground |
| 6, 30 | VCCO | 3.3 V I/O supply |
| 11, 36 | VCC / TCK* | see package/device documentation; pin 11 is TCK in the device table |

The JTAG and power pins must be represented explicitly in the KiCad symbol. No external signal may be assigned to a reserved JTAG pin.

## Important correction to earlier logical draft

The earlier M1.2f document intentionally stopped at logical assignment. This revision freezes the physical package mapping based on the published 48-pin TQFP pin table. The mapping deliberately avoids TMS (pin 25) and keeps all four JTAG pins available.

## Electrical notes

- The eight C64 data signals are bidirectional and require explicit tri-state control in the CPLD HDL.
- CPLD outputs toward the C64 are 3.3 V logic, not 5 V drive.
- W5500-side signals remain in the 3.3 V domain.
- W5500 itself is specified for 3.3 V operation with 5 V-tolerant digital inputs.
- This pin assignment does not constitute ERC or timing qualification.

## Status

**M1.2l — physical pin assignment baseline PASS.**

Remaining M1.2b work:

- Native KiCad symbol/net capture
- Package/footprint verification in KiCad
- ERC
- PCB placement and routing
